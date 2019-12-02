#include "clocksetter.h"
#include <QProcess>
#include <QDebug>

ClockSetter::ClockSetter(QObject *parent) :
    QObject (parent)
{
    this->minDiff = sm->value("timedate/mindiff").toInt();
    this->hourDiff = sm->value("timedate/hourdiff").toInt();
    this->dayDiff = sm->value("timedate/daydiff").toInt();
    this->monthDiff = sm->value("timedate/monthdiff").toInt();
    this->yearDiff = sm->value("timedate/yeardiff").toInt();

    this->hwTimeOffset.sec = sm->value("timedate/hw_offset_sec").toInt();
    this->hwTimeOffset.min = sm->value("timedate/hw_offset_min").toInt();
    this->hwTimeOffset.hour = sm->value("timedate/hw_offset_hour").toInt();
    this->hwTimeOffset.day = sm->value("timedate/hw_offset_day").toInt();
    this->hwTimeOffset.month = sm->value("timedate/hw_offset_month").toInt();
    this->hwTimeOffset.year = sm->value("timedate/hw_offset_year").toInt();
    QString timezone = sm->value("timedate/timezone").toString();
    if (timezone == "")
        qDebug ()<<"timezone empty";
    else
        this->activeTimezone = timezone;

    if (!hwTimeOffset.isZero()){
        qDebug()<<"hwTimeOffsetIsZero, setting offsets using current time";
        setLocalTimeFromOffset();
    }
    else{
        updateHwClockOffset();
    }
    this->loggerTimer.setInterval(60000);
    connect(&loggerTimer,&QTimer::timeout,this,[=](){
        sm->getSettings()->setValue("timedate/powerofftime",QDateTime::currentDateTimeUtc().toString());
    });
    loggerTimer.start();

}

//bool ClockSetter::dateTimeStructIsZero(DateTimeStruct *dateTime){
//    return (dateTime->sec==0 && dateTime->min==0 && dateTime->hour==0 && dateTime->day==0 && dateTime->month==0 && dateTime->year==0);
//}
//void ClockSetter::diffBetweenDateTimeStructs(DateTimeStruct *time1, DateTimeStruct *time2, DateTimeStruct *diff){
//    diff->year = time2->year - time1->year;
//    diff->month = time2->month - time1->month;
//    diff->day = time2->day - time1->day;
//    diff->hour = time2->hour - time1->hour;
//    diff->min = time2->min - time1->min;
//    diff->sec = time2->sec - time1->sec;
//}

void ClockSetter::parseSystemTimes(QString queryString, MyDateTime *sysTime, MyDateTime *rtc, MyDateTime *offset){
    QString name_universaltime = "Universal time: ";
    QString name_rtctime = "RTC time: ";
    QString name_timezone = "Time zone: ";
    QStringList utcDateParts;
    QStringList utcTimeParts;
    QStringList rtcDateParts;
    QStringList rtcTimeParts;
    QString timezone;
    QTextStream textstream(&queryString);
    try {
        while (!textstream.atEnd())
        {
            QString line = textstream.readLine().trimmed();
            if(line.startsWith(name_universaltime, Qt::CaseInsensitive)){
                line.remove(0,name_universaltime.length());
                QStringList parts = line.split(" ");
                if (parts.length()>=3){
                    utcDateParts = parts[1].split("-");
                    utcTimeParts = parts[2].split(":");
                }
            }
            else if(line.startsWith(name_rtctime)){
                line.remove(0,name_rtctime.length());
                QStringList parts = line.split(" ");
                if (parts.length()>=3){
                    rtcDateParts = parts[1].split("-");
                    rtcTimeParts = parts[2].split(":");
                }
            }
            else if(line.startsWith(name_timezone)){
                line.remove(0,name_timezone.length());
                QStringList parts = line.split(" ");
                timezone = parts[0];
            }
        }
        if (sysTime){
            sysTime->year = utcDateParts[0].toInt();
            sysTime->month = utcDateParts[1].toInt();
            sysTime->day = utcDateParts[2].toInt();
            sysTime->hour = utcTimeParts[0].toInt();
            sysTime->min = utcTimeParts[1].toInt();
            sysTime->sec = utcTimeParts[2].toInt();
            activeTimezone = timezone;
        }
        if (rtc){
            rtc->year = rtcDateParts[0].toInt();
            rtc->month = rtcDateParts[1].toInt();
            rtc->day = rtcDateParts[2].toInt();
            rtc->hour = rtcTimeParts[0].toInt();
            rtc->min = rtcTimeParts[1].toInt();
            rtc->sec = rtcTimeParts[2].toInt();
            activeTimezone = timezone;
        }
        if (offset && rtc && sysTime){
            *offset = *sysTime - *rtc;
//            diffBetweenDateTimeStructs(rtc,sysTime,offset);
//            offset->year = sysTime->year - rtc->year;
//            offset->month = sysTime->month - rtc->month;
//            offset->day = sysTime->day - rtc->day;
//            offset->hour = sysTime->hour - rtc->hour;
//            offset->min = sysTime->min - rtc->min;
//            offset->sec = sysTime->sec - rtc->sec;
        }
    } catch (...) {
        qDebug()<<"Failed to parse timedatectl";
    }
}

void ClockSetter::updateHwClockOffset(bool measureTimeLag){
    QProcess *readtimedatectl = new QProcess();
    connect(readtimedatectl, qOverload<int, QProcess::ExitStatus >(&QProcess::finished),[=]()
    {
        MyDateTime sysTime;
        MyDateTime rtc;
        MyDateTime offset;
        parseSystemTimes(QString(readtimedatectl->readAllStandardOutput()),&sysTime,&rtc,&offset);
        if (measureTimeLag && lastPoweroffTime.isValid() /*&& last_hwTimeOffset!=offset*/){


            QString prevDTString = sm->value("timedate/powerofftime").toString();
            if (prevDTString!=""){
                QDateTime prevDT = QDateTime::fromString(prevDTString);
                qint64 msecsDiff = prevDT.msecsTo(QDateTime::currentDateTime());
                qDebug()<<"clocksetter: time passed since last time sync: "<< msecsDiff<<"ms ("<<msecsDiff/1000/60/60<<"mins)";
                qDebug()<<"clocksetter: difference in offsets "<<(offset.day-hwTimeOffset.day)<<" days,"<<(offset.hour-hwTimeOffset.hour)
                       <<" hours,"<<(offset.min-hwTimeOffset.min)<<" mins,"<<(offset.sec-hwTimeOffset.sec)<<" secs.";
            }
            sm->getSettings()->setValue("timedate/powerofftime",QDateTime::currentDateTime().toString());
        }
        this->hwTimeOffset = offset;
        sm->setHwTimeOffset(offset.sec, offset.min, offset.hour, offset.day, offset.month, offset.year, activeTimezone);
        readtimedatectl->deleteLater();
    });
    readtimedatectl->start("/bin/sh", QStringList() << "-c" << "timedatectl");
}

void ClockSetter::setLocalTimeFromOffset(){
    #if !(defined(__arm__) or defined(__aarch64__))
        return;
    #endif
    QProcess *ntpSetter = new QProcess();
    QProcess *ntpReSetter = new QProcess();
    QProcess *timeSetter = new QProcess();
    QProcess *readtimedatectl = new QProcess();
    connect(ntpSetter, qOverload<int, QProcess::ExitStatus >(&QProcess::finished),
            [=](){
        readtimedatectl->start("/bin/sh", QStringList() << "-c" << "timedatectl");
        ntpSetter->deleteLater();
    });
    connect(timeSetter, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished),
        [=](int exitCode, QProcess::ExitStatus exitStatus){
        ntpReSetter->start("/bin/sh", QStringList() << "-c" << "timedatectl set-ntp true");
        timeSetter->deleteLater();
    });
    connect(ntpReSetter, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished),
        [=](int exitCode, QProcess::ExitStatus exitStatus){
        updateHwClockOffset(true);
        ntpReSetter->deleteLater();
    });
    connect(readtimedatectl, qOverload<int, QProcess::ExitStatus >(&QProcess::finished),[=]()
    {
        MyDateTime sysTime;
        MyDateTime rtc;
        MyDateTime offset;
        parseSystemTimes(QString(readtimedatectl->readAllStandardOutput()),&sysTime,&rtc,&offset);
        QString dateFormat = "yyyy-M-d h:m:s";
        QString dateString = QString::number(rtc.year) +"-"+QString::number(rtc.month)+"-"
                +QString::number(rtc.day ) + " " + QString::number(rtc.hour )+":"
                +QString::number(rtc.min )+":"+QString::number(rtc.sec);
        QDateTime timeToAdvance = QDateTime::fromString(dateString,dateFormat );
        timeToAdvance.setTime(timeToAdvance.time().addSecs(hwTimeOffset.hour*3600+hwTimeOffset.min*60+hwTimeOffset.sec));
        timeToAdvance.setDate(timeToAdvance.date().addYears(hwTimeOffset.year).addMonths(hwTimeOffset.month).addDays(hwTimeOffset.day));
        QStringList timesetCmd = QStringList() << "-c" << "timedatectl set-timezone UTC && timedatectl set-time '"+timeToAdvance.toString(dateFormat)+"' && timedatectl set-timezone " + activeTimezone;
        qDebug()<<"setting time with "<<timesetCmd;
        timeSetter->start("/bin/sh", timesetCmd);
        systemStartTimeWithLag = QDateTime::currentDateTimeUtc();
        lastPoweroffTime = QDateTime::fromString(sm->value("timedate/powerofftime").toString());
        last_hwTimeOffset = hwTimeOffset;
//        qDebug()<<"times: "<< systemStartTimeWithLag <<", "<<lastPoweroffTime;
        readtimedatectl->deleteLater();
    });
    ntpSetter->start("/bin/sh", QStringList() << "-c" << "timedatectl set-ntp false");
}


void ClockSetter::setTimeDiff(int minDiff, int hourDiff, int dayDiff,  int monthDiff, int yearDiff)
{
    sm->setTimeDiff(minDiff,hourDiff,dayDiff,monthDiff,yearDiff);
    this->hourDiff = hourDiff;
    this->minDiff = minDiff;
    this->dayDiff = dayDiff;
    this->monthDiff = monthDiff;
    this->yearDiff = yearDiff;
    emit timeDiffChanged();
}

QDateTime ClockSetter::getAdjustedTime(){
    QDateTime adjustedDateTime = QDateTime::currentDateTime();
    adjustedDateTime.setTime(QTime::currentTime().addSecs(hourDiff*3600+minDiff*60));
    QDate tempDate(QDate::currentDate());
    tempDate = tempDate.addDays(dayDiff);
    tempDate = tempDate.addMonths(monthDiff);
    tempDate = tempDate.addYears(yearDiff);
    adjustedDateTime.setDate(tempDate);
    return adjustedDateTime;
}

void ClockSetter::setRegion(QString region)
{
    QProcess *ntpSetter = new QProcess();
    QProcess *regionSetter = new QProcess();
//    QProcess *ntpReSetter = new QProcess();

    connect(regionSetter, qOverload<int, QProcess::ExitStatus >(&QProcess::finished),
            [=](){
        this->setTimeDiff(0,0,0,0,0);
        emit regionChanged(region);
        updateHwClockOffset(true);
        regionSetter->deleteLater();
    });

    QString timeZone = "UTC";
    if(region == "Turkey")
        timeZone = "Europe/Istanbul";
    else if(region == "China")
        timeZone = "Asia/Shanghai";
    activeTimezone = timeZone;
    ntpSetter->start("/bin/sh", QStringList() << "-c" << "timedatectl set-ntp true");
    connect(ntpSetter, qOverload<int, QProcess::ExitStatus >(&QProcess::finished),
            [=](){
        regionSetter->start("/bin/sh", QStringList() << "-c" << "timedatectl set-timezone '" +
                            timeZone + "'");
        ntpSetter->deleteLater();
//        ntpReSetter->start("/bin/sh", QStringList() << "-c" << "timedatectl set-ntp false");
//        connect(ntpReSetter, qOverload<int, QProcess::ExitStatus >(&QProcess::finished),[=](){ntpReSetter->deleteLater();});
    });
}

// not being used rn
void ClockSetter::setSystemClock(QString time)
{
    QProcess *ntpSetter = new QProcess();
    QProcess *timeSetter = new QProcess();

    connect(timeSetter, SIGNAL(finished(int, QProcess::ExitStatus)),
            timeSetter, SLOT(deleteLater()));

    connect(ntpSetter, qOverload<int, QProcess::ExitStatus >(&QProcess::finished),
            [=](){
        timeSetter->start("/bin/sh", QStringList() << "-c" << "timedatectl set-time '"+time
                          +"'");
        ntpSetter->deleteLater();
    });

    ntpSetter->start("/bin/sh", QStringList() << "-c" << "timedatectl set-ntp false");
    this->setTimeDiff(0,0,0,0,0);
    emit timeDiffChanged();
    emit sendKey("media/back_monitor");
}
