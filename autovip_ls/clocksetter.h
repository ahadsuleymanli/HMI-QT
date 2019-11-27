#ifndef CLOCKSETTER_H
#define CLOCKSETTER_H


#include <QObject>
#include "settingsmanager.h"
#include <QDateTime>

class ClockSetter : public QObject
{
    Q_OBJECT
    SettingsManager *sm = &SettingsManager::instance();
    int minDiff;
    int hourDiff;
    int dayDiff;
    int monthDiff;
    int yearDiff;

    struct DateTimeStruct
    {
        int sec;
        int min;
        int hour;
        int day;
        int month;
        int year;
        QString activeTimezone = "";
    };
    DateTimeStruct hwTimeOffset;
    bool hwTimeOffsetIsZero();
    void updateHwClockOffset(bool measureTimeLag=false);
    void setLocalTimeFromOffset();
    void parseSystemTimes(QString queryString, DateTimeStruct *sysTime , DateTimeStruct *rtc, DateTimeStruct *offset);
    Q_PROPERTY(QDateTime adjustedDateTime READ getAdjustedTime() NOTIFY timeDiffChanged)
public:
    explicit ClockSetter(QObject *parent = nullptr);
    Q_INVOKABLE void setTimeDiff(int minDIff, int hourDiff, int dayDiff,  int monthDiff, int yearDiff);
    Q_INVOKABLE void setSystemClock(QString time);
    Q_INVOKABLE void setRegion(QString region);
    Q_INVOKABLE QDateTime getAdjustedTime();

signals:
    void sendKey(QString);
    void timeDiffChanged();
    void regionChanged(QString region);
public slots:
};

#endif // CLOCKSETTER_H
