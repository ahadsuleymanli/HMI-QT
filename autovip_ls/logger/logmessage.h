#ifndef LOGMESSAGE_H
#define LOGMESSAGE_H

#include <QtGlobal>
#include <QDateTime>
#include <QHash>
#include "logglobal.h"


class DECLSPEC LogMessage
{
    Q_DISABLE_COPY(LogMessage)
public:
    LogMessage(const QtMsgType type,
               const QString& message,
               QHash<QString,QString>* logVars,
               const QString &file,
               const QString &function,
               const int line);
    QString toString(const QString& msgFormat, const QString& timestampFormat) const;
    QtMsgType getType() const;

private:
    QHash<QString,QString> logVars;
    QDateTime timestamp;
    QtMsgType type;
    Qt::HANDLE threadId;
    QString message;
    QString file;
    QString function;
    int line;

};

#endif // LOGMESSAGE_H
