#ifndef DUALFILELOGGER_H
#define DUALFILELOGGER_H

#include <QString>
#include <QSettings>
#include <QtGlobal>
#include "logglobal.h"
#include "logger.h"
#include "filelogger.h"
class DECLSPEC DualFileLogger : public Logger {
    Q_OBJECT
    Q_DISABLE_COPY(DualFileLogger)
public:
    DualFileLogger(QSettings* firstSettings, QSettings* secondSettings, const int refreshInterval=10000, QObject *parent = 0);
    virtual void log(const QtMsgType type, const QString& message, const QString &file="", const QString &function="", const int line=0);
    virtual void clear(const bool buffer=true, const bool variables=true);

private:
    FileLogger* firstLogger;
    FileLogger* secondLogger;

};

#endif // DUALFILELOGGER_H
