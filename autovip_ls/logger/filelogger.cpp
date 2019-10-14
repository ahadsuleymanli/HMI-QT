#include "filelogger.h"
#include <QTime>
#include <QStringList>
#include <QThread>
#include <QtGlobal>
#include <QFile>
#include <QTimerEvent>
#include <QDir>
#include <QFileInfo>
#include <stdio.h>

void FileLogger::refreshSettings()
{
    mutex.lock();
    QString oldFileName=fileName;
    settings->sync();
    fileName=settings->value("logging/fileName").toString();
#ifdef Q_OS_WIN32
    if (QDir::isRelativePath(fileName) && settings->format()!=QSettings::NativeFormat)
#else
    if (QDir::isRelativePath(fileName))
#endif
    {
        QFileInfo configFile(settings->fileName());
        fileName=QFileInfo(configFile.absolutePath(),fileName).absoluteFilePath();
    }
    maxSize=settings->value("logging/maxSize",0).toLongLong();
    maxBackups=settings->value("logging/maxBackups",0).toInt();
    msgFormat=settings->value("logging/msgFormat","{timestamp} {type} {msg}").toString();
    timestampFormat=settings->value("logging/timestampFormat","yyyy-MM-dd hh:mm:ss.zzz").toString();
    minLevel=static_cast<QtMsgType>(settings->value("logging/minLevel",0).toInt());
#ifdef QT_DEBUG
    bufferSize= 0;
#else
    bufferSize=settings->value("bufferSize",0).toInt();
#endif

    if (oldFileName!=fileName)
    {
        fprintf(stderr,"Logging to %s\n",qPrintable(fileName));
        close();
        open();
    }
    mutex.unlock();
}


FileLogger::FileLogger(QSettings* settings, const int refreshInterval, QObject* parent)
    : Logger(parent)
{
    Q_ASSERT(settings!=0);
    Q_ASSERT(refreshInterval>=0);
    this->settings=settings;
    file=0;
    if (refreshInterval>0)
    {
        refreshTimer.start(refreshInterval,this);
    }
    flushTimer.start(1000,this);
    refreshSettings();
}


FileLogger::~FileLogger()
{
    close();
}


void FileLogger::write(const LogMessage* logMessage)
{
    if (file)
    {

        file->write(qPrintable(logMessage->toString(msgFormat,timestampFormat)));
        if (logMessage->getType()>=QtCriticalMsg)
        {
            file->flush();
        }

        if (file->error())
        {
            close();
            qWarning("Cannot write to log file %s: %s",qPrintable(fileName),qPrintable(file->errorString()));
        }

    }

    if (!file)
    {
        Logger::write(logMessage);
    }

}

void FileLogger::open()
{
    if (fileName.isEmpty())
    {
        qWarning("Name of logFile is empty");
    }
    else {
        file=new QFile(fileName);
        if (!file->open(QIODevice::WriteOnly | QIODevice::Append | QIODevice::Text))
        {
            qWarning("Cannot open log file %s: %s",qPrintable(fileName),qPrintable(file->errorString()));
            file=0;
        }
    }
}


void FileLogger::close()
{
    if (file)
    {
        file->close();
        delete file;
        file=0;
    }
}

void FileLogger::rotate() {
    int count=0;
    forever
    {
        QFile bakFile(QString("%1.%2").arg(fileName).arg(count+1));
        if (bakFile.exists())
        {
            ++count;
        }
        else
        {
            break;
        }
    }

    while (maxBackups>0 && count>=maxBackups)
    {
        QFile::remove(QString("%1.%2").arg(fileName).arg(count));
        --count;
    }

    for (int i=count; i>0; --i) {
        QFile::rename(QString("%1.%2").arg(fileName).arg(i),QString("%1.%2").arg(fileName).arg(i+1));
    }

    QFile::rename(fileName,fileName+".1");
}


void FileLogger::timerEvent(QTimerEvent* event)
{
    if (!event)
    {
        return;
    }
    else if (event->timerId()==refreshTimer.timerId())
    {
        refreshSettings();
    }
    else if (event->timerId()==flushTimer.timerId() && file)
    {
        mutex.lock();

        file->flush();

        if (maxSize>0 && file->size()>=maxSize)
        {
            close();
            rotate();
            open();
        }

        mutex.unlock();
    }
}
