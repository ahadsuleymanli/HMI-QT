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
    QTimer loggerTimer;

    class MyDateTime{
        public:
        int sec,min,hour,day,month,year;
        MyDateTime(){}
        MyDateTime(int sec, int min, int hour, int day, int month, int year){
            this->sec = sec; this->min = min; this->hour = hour; this->day = day; this->month = month; this->year = year;}
        MyDateTime operator-(MyDateTime x){return MyDateTime(sec-x.sec,min-x.min,hour-x.hour,day-x.day,month-x.month,year-x.year);}
        void operator=(MyDateTime x){sec=x.sec; min=x.min; hour=x.hour; day=x.day; month=x.month; year=x.year;}
        bool isZero(){return (sec==0 && min==0 && hour==0 && day==0 && month==0 && year==0); }
    };



//    bool useAutoNtp = true;

//    struct DateTimeStruct
//    {
//        int sec;
//        int min;
//        int hour;
//        int day;
//        int month;
//        int year;

//    };
    QString activeTimezone = "UTC";
    MyDateTime hwTimeOffset;
    MyDateTime last_hwTimeOffset;
    QDateTime systemStartTimeWithLag;
    QDateTime lastPoweroffTime;
//    bool dateTimeStructIsZero(DateTimeStruct *dateTime);
//    void diffBetweenDateTimeStructs(DateTimeStruct *time1, DateTimeStruct *time2, DateTimeStruct *diff);
    void updateHwClockOffset(bool measureTimeLag=false);
    void setLocalTimeFromOffset();
    void parseSystemTimes(QString queryString, MyDateTime *sysTime , MyDateTime *rtc, MyDateTime *offset);
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
