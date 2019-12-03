#ifndef CLOCKSETTER_H
#define CLOCKSETTER_H


#include <QObject>
#include "settingsmanager.h"
#include <QDateTime>
#include <QTimer>

class ClockSetter : public QObject
{
    Q_OBJECT
    SettingsManager *sm = &SettingsManager::instance();
    int minDiff;
    int hourDiff;
    int dayDiff;
    int monthDiff;
    int yearDiff;
    QTimer timeLagDetectorTimer;

    class DateTime{
        public:
        int sec,min,hour,day,month,year;
        DateTime(){}
        DateTime(int sec, int min, int hour, int day, int month, int year){
            this->sec = sec; this->min = min; this->hour = hour; this->day = day; this->month = month; this->year = year;}
        void set(int sec, int min, int hour, int day, int month, int year){
            this->sec = sec; this->min = min; this->hour = hour; this->day = day; this->month = month; this->year = year;}
        DateTime operator-(DateTime x){return DateTime(sec-x.sec,min-x.min,hour-x.hour,day-x.day,month-x.month,year-x.year);}
        void operator=(DateTime x){sec=x.sec; min=x.min; hour=x.hour; day=x.day; month=x.month; year=x.year;}
        bool operator==(DateTime x){return (sec==x.sec && min==x.min && hour==x.hour && day==x.day && month==x.month && year==x.year);}
        bool operator!=(DateTime x){return !(*this==x);}
        bool isZero(){return (sec==0 && min==0 && hour==0 && day==0 && month==0 && year==0); }
        QStringList toQStringList(){return QStringList()<<QString::number(year)<<QString::number(month)
                                                   <<QString::number(day)<<QString::number(hour)<<QString::number(min)<<QString::number(sec);}
        qint64 toRoughSecs(){return sec + min*60 + hour*3600 + day*24*3600 + month*30*24*3600 + year*12*30*24*3600;}
    };

    QString activeTimezone = "UTC";
    DateTime hwTimeOffset;
    DateTime last_hwTimeOffset;
    QDateTime systemStartTimeWithLag;
    QDateTime lastPoweroffTime;
    float lastRtcLagMulti;
    qint64 lastLagMeasuredTimeInSecs;
    qint64 currentLagMeasuredTimeInSecs;
    QDateTime lastCheckedTime;
    void updateRtcLagMuli(DateTime rtcLag);
    void mitigateRtcLag(QDateTime *rtcTimeOffsetApplied);
    void updateHwClockOffset(bool measureTimeLag=false);
    void setLocalTimeFromOffset();
    void parseSystemTimes(QString queryString, DateTime *sysTime , DateTime *rtc, DateTime *offset);
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
};

#endif // CLOCKSETTER_H
