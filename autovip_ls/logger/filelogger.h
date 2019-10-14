#ifndef FILELOGGER_H
#define FILELOGGER_H

#include <QtGlobal>
#include <QSettings>
#include <QFile>
#include <QMutex>
#include <QBasicTimer>
#include "logglobal.h"
#include "logger.h"

class DECLSPEC FileLogger : public Logger {
    Q_OBJECT
    Q_DISABLE_COPY(FileLogger)
public:
    FileLogger(QSettings* settings, const int refreshInterval=10000, QObject* parent = 0);
    virtual ~FileLogger();
    virtual void write(const LogMessage* logMessage);

protected:
    void timerEvent(QTimerEvent* event);

private:
    QString fileName;
    long maxSize;
    int maxBackups;
    QSettings* settings;
    QFile* file;
    QBasicTimer refreshTimer;
    QBasicTimer flushTimer;
    void open();
    void close();
    void rotate();
    void refreshSettings();

};

#endif // FILELOGGER_H
