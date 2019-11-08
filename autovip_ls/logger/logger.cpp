#include "logger.h"
#include <stdio.h>
#include <stdlib.h>
#include <QMutex>
#include <QDateTime>
#include <QThread>
#include <QObject>
#include <iostream>

Logger* Logger::defaultLogger=0;


QThreadStorage<QHash<QString,QString>*> Logger::logVars;


QMutex Logger::mutex;


Logger::Logger(QObject* parent)
    : QObject(parent),
    msgFormat("{timestamp} {type} {msg}"),
    timestampFormat("dd.MM.yyyy hh:mm:ss.zzz"),
    minLevel(QtDebugMsg),
    bufferSize(0)
    {}


Logger::Logger(const QString msgFormat,
               const QString timestampFormat, const QtMsgType minLevel, const int bufferSize, QObject* parent)
    :QObject(parent)
{
    this->msgFormat=msgFormat;
    this->timestampFormat=timestampFormat;
    this->minLevel=minLevel;
    this->bufferSize=bufferSize;
}


void Logger::msgHandler(const QtMsgType type, const QString &message, const QString &file, const QString &function, const int line)
{
    static QMutex recursiveMutex(QMutex::Recursive);
    static QMutex nonRecursiveMutex(QMutex::NonRecursive);

    recursiveMutex.lock();

    if (defaultLogger && nonRecursiveMutex.tryLock())
    {
        defaultLogger->log(type, message, file, function, line);
        nonRecursiveMutex.unlock();
    }
    else
    {
        fputs(qPrintable(message),stderr);
        fflush(stderr);
    }

    if (type>=QtFatalMsg)
    {
        abort();
    }

    recursiveMutex.unlock();
}


#if QT_VERSION >= 0x050000
    void Logger::msgHandler5(const QtMsgType type, const QMessageLogContext &context, const QString &message)
    {
      (void)(context); // suppress "unused parameter" warning
      msgHandler(type,message,context.file,context.function,context.line);
      #ifdef QT_DEBUG
      std::cout<<"Message : "<< message.toStdString()<<std::endl;
      #endif
    }
#else
    void Logger::msgHandler4(const QtMsgType type, const char* message)
    {
        msgHandler(type,message);
    }
#endif


Logger::~Logger()
{
    if (defaultLogger==this)
    {
#if QT_VERSION >= 0x050000
        qInstallMessageHandler(0);
#else
        qInstallMsgHandler(0);
#endif
        defaultLogger=0;
    }
}


void Logger::write(const LogMessage* logMessage)
{
    fputs(qPrintable(logMessage->toString(msgFormat,timestampFormat)),stderr);
    fflush(stderr);
}


void Logger::installMsgHandler()
{
    defaultLogger=this;
#if QT_VERSION >= 0x050000
    qInstallMessageHandler(msgHandler5);
#else
    qInstallMsgHandler(msgHandler4);
#endif
}


void Logger::set(const QString& name, const QString& value)
{
    mutex.lock();
    if (!logVars.hasLocalData())
    {
        logVars.setLocalData(new QHash<QString,QString>);
    }
    logVars.localData()->insert(name,value);
    mutex.unlock();
}


void Logger::clear(const bool buffer, const bool variables)
{
    mutex.lock();
    if (buffer && buffers.hasLocalData())
    {
        QList<LogMessage*>* buffer=buffers.localData();
        while (buffer && !buffer->isEmpty()) {
            LogMessage* logMessage=buffer->takeLast();
            delete logMessage;
        }
    }
    if (variables && logVars.hasLocalData())
    {
        logVars.localData()->clear();
    }
    mutex.unlock();
}


void Logger::log(const QtMsgType type, const QString& message, const QString &file, const QString &function, const int line)
{
    mutex.lock();

    if (bufferSize>0) {
        if (!buffers.hasLocalData()) {
            buffers.setLocalData(new QList<LogMessage*>());
        }
        QList<LogMessage*>* buffer=buffers.localData();
        LogMessage* logMessage=new LogMessage(type,message,logVars.localData(),file,function,line);
        buffer->append(logMessage);
        if (buffer->size()>bufferSize)
        {
            delete buffer->takeFirst();
        }
        if (type>=minLevel) {
            while (!buffer->isEmpty())
            {
                LogMessage* logMessage=buffer->takeFirst();
                write(logMessage);
                delete logMessage;
            }
        }
    }

    else {
        if (type>=minLevel)
        {
            LogMessage logMessage(type,message,logVars.localData(),file,function,line);
            write(&logMessage);
        }
    }
    mutex.unlock();
}
