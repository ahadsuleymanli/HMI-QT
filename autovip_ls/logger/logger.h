#ifndef LOGGER_H
#define LOGGER_H

#include <QtGlobal>
#include <QThreadStorage>
#include <QHash>
#include <QStringList>
#include <QMutex>
#include <QObject>
#include "logglobal.h"
#include "logmessage.h"


class DECLSPEC Logger : public QObject {
    Q_OBJECT
    Q_DISABLE_COPY(Logger)
public:
    Logger(QObject* parent);
    Logger(const QString msgFormat="{timestamp} {type} {msg}",
           const QString timestampFormat="dd.MM.yyyy hh:mm:ss.zzz",
           const QtMsgType minLevel=QtDebugMsg,
           const int bufferSize=0,
           QObject* parent = 0);
    virtual ~Logger();
    virtual void log(const QtMsgType type,
                     const QString& message,
                     const QString &file="",
                     const QString &function="",
                     const int line=0);
    void installMsgHandler();
    static void set(const QString& name, const QString& value);
    virtual void clear(const bool buffer=true, const bool variables=true);

protected:
    QString msgFormat;
    QString timestampFormat;
    QtMsgType minLevel;
    int bufferSize;
    static QMutex mutex;
    virtual void write(const LogMessage* logMessage);

private:
    static Logger* defaultLogger;
    static void msgHandler(const QtMsgType type, const QString &message, const QString &file="", const QString &function="", const int line=0);


#if QT_VERSION >= 0x050000

    static void msgHandler5(const QtMsgType type, const QMessageLogContext& context, const QString &message);

#else

    static void msgHandler4(const QtMsgType type, const char * message);

#endif

    static QThreadStorage<QHash<QString,QString>*> logVars;

    QThreadStorage<QList<LogMessage*>*> buffers;

};

#endif // LOGGER_H
