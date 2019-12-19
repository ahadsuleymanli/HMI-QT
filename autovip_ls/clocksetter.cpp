#include "clocksetter.h"
#include <QProcess>
#include <QDebug>
#include <QtMath>
#include <QtGlobal>

const int LAG_CHECK_TIME = 60;

ClockSetter::ClockSetter(QObject *parent) :
    QObject (parent)
{
    timeLagDetectorTimer = new QTimer(this);
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
    this->last_hwTimeOffset = hwTimeOffset;
    this->lastRtcLagMulti = sm->value("timedate/lagmulti").toFloat();
    this->lastLagMeasuredTimeInSecs = sm->value("timedate/lagmeasuredtime").toInt();
    QString timezone = sm->value("timedate/timezone").toString();
    if (timezone == "")
        qDebug ()<<"timezone empty";
    else
        this->activeTimezone = timezone;
}

void ClockSetter::setLastPowerOffTime(QString lastPowerOffTimeString){
    this->lastPoweroffTime = QDateTime::fromString(lastPowerOffTimeString);
    this->lastPoweroffTime.setTimeSpec(Qt::UTC);
    qDebug()<<"last poweroff time " << lastPoweroffTime;
}

void ClockSetter::start(){
    if (!hwTimeOffset.isZero()){
        setLocalTimeFromOffset();
    }
    else{
        qDebug()<<"hwTimeOffsetIsZero, setting offsets using current time";
        updateHwClockOffset();
    }
    this->timeLagDetectorTimer->setInterval(LAG_CHECK_TIME*1000);
    connect(timeLagDetectorTimer,&QTimer::timeout,this,[=](){
        QDateTime current = QDateTime::currentDateTimeUtc();
        qint64 lag = lastCheckedTime.secsTo(current);
        lastCheckedTime = current;
        if ( lag > LAG_CHECK_TIME+20){
            qDebug()<<"time lag detected: " << lag-LAG_CHECK_TIME;
            updateHwClockOffset(true);
        }
    });
    timeLagDetectorTimer->stop();
}

void ClockSetter::parseSystemTimes(QString queryString, DateTime *sysTime, DateTime *rtc, DateTime *offset){
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
        activeTimezone = timezone;
        if (sysTime){
            sysTime->set(utcTimeParts[2].toInt(), utcTimeParts[1].toInt(), utcTimeParts[0].toInt(), utcDateParts[2].toInt(), utcDateParts[1].toInt(), utcDateParts[0].toInt());
        }
        if (rtc){
            rtc->set(rtcTimeParts[2].toInt(), rtcTimeParts[1].toInt(), rtcTimeParts[0].toInt(), rtcDateParts[2].toInt(), rtcDateParts[1].toInt(), rtcDateParts[0].toInt());
        }
        if (offset && rtc && sysTime){
            *offset = *sysTime - *rtc;
        }
    } catch (...) {
        qDebug()<<"Failed to parse timedatectl";
    }
}

void ClockSetter::updateRtcLagMuli(DateTime rtcLag){
    if (currentLagMeasuredTimeInSecs>0 && (qFabs(rtcLag.toRoughSecs())>30)){
        float rtcLagMulti = float((currentLagMeasuredTimeInSecs + rtcLag.toRoughSecs()))/currentLagMeasuredTimeInSecs - 1;
        if (currentLagMeasuredTimeInSecs<10*24*60*60&&(currentLagMeasuredTimeInSecs>lastLagMeasuredTimeInSecs || currentLagMeasuredTimeInSecs>3*24*60*60)){
            lastRtcLagMulti = rtcLagMulti;
            qDebug()<<"lag multi updated to "<<rtcLagMulti;
            sm->getSettings()->setValue("timedate/lagmulti",QString::number(rtcLagMulti));
            sm->getSettings()->setValue("timedate/lagmeasuredtime",currentLagMeasuredTimeInSecs);
        }
        else{
            qDebug()<<"calculated lag multi: "<<rtcLagMulti<<". This multi is not being set since a higher priority one exists.";
        }
    }
    if (lastRtcLagMulti==0){
        qDebug()<<"rtc lag compensation has not been calibrated yet. "
                  <<"Please keep the device connected to the internet, turn it off for ~1 hours and turn it back on.";
    }
}

void ClockSetter::updateHwClockOffset(bool measureTimeLag){
    QProcess *readtimedatectl = new QProcess();
    connect(readtimedatectl, qOverload<int, QProcess::ExitStatus >(&QProcess::finished),[=]()
    {
        DateTime sysTime;
        DateTime rtc;
        DateTime offset;
        parseSystemTimes(QString(readtimedatectl->readAllStandardOutput()),&sysTime,&rtc,&offset);
        if (measureTimeLag && lastPoweroffTime.isValid() && last_hwTimeOffset!=offset){
            DateTime rtcLag = offset - last_hwTimeOffset;
            qDebug()<<"time updated through network and rtc lag was "<<QString::number(rtcLag.toRoughSecs())<<" in " <<currentLagMeasuredTimeInSecs << "seconds (rtc lagged time)";
            updateRtcLagMuli(rtcLag);
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
        lastCheckedTime=QDateTime::currentDateTimeUtc();
        timeLagDetectorTimer->start();
        emit timeIsSet();
        timeSetter->deleteLater();
    });
    connect(ntpReSetter, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished),
        [=](int exitCode, QProcess::ExitStatus exitStatus){
        ntpReSetter->deleteLater();
    });
    connect(readtimedatectl, qOverload<int, QProcess::ExitStatus >(&QProcess::finished),[=]()
    {
        DateTime sysTime;
        DateTime rtc;
        DateTime offset;
        parseSystemTimes(QString(readtimedatectl->readAllStandardOutput()),&sysTime,&rtc,&offset);
        QString dateFormat = "yyyy-M-d h:m:s";
        QString dateString = QString::number(rtc.year) +"-"+QString::number(rtc.month)+"-"
                +QString::number(rtc.day ) + " " + QString::number(rtc.hour )+":"
                +QString::number(rtc.min )+":"+QString::number(rtc.sec);
        QDateTime rtcTimeOffsetApplied = QDateTime::fromString(dateString,dateFormat);
        rtcTimeOffsetApplied.setTimeSpec(Qt::UTC);
        qDebug()<<"hwtimeoffset: "<<hwTimeOffset.toQStringList();
        qDebug()<<"rtc: "<<rtcTimeOffsetApplied;
        rtcTimeOffsetApplied = rtcTimeOffsetApplied.addSecs(hwTimeOffset.hour*3600+hwTimeOffset.min*60+hwTimeOffset.sec);
        qDebug()<<"rtc secs applied: "<<rtcTimeOffsetApplied;
        rtcTimeOffsetApplied = rtcTimeOffsetApplied.addDays(hwTimeOffset.day).addMonths(hwTimeOffset.month).addYears(hwTimeOffset.year);
        qDebug()<<"rtc years applied: "<<rtcTimeOffsetApplied;
        systemStartTimeWithLag = rtcTimeOffsetApplied;
        mitigateRtcLag(&rtcTimeOffsetApplied);
        QStringList timesetCmd = QStringList() << "-c" << "timedatectl set-timezone UTC && timedatectl set-time '"+rtcTimeOffsetApplied.toString(dateFormat)+"' && timedatectl set-timezone " + activeTimezone;
        qDebug()<<"setting time with "<<timesetCmd;
        timeSetter->start("/bin/sh", timesetCmd);

        readtimedatectl->deleteLater();
    });
    ntpSetter->start("/bin/sh", QStringList() << "-c" << "timedatectl set-ntp false");
}
void ClockSetter::mitigateRtcLag(QDateTime *rtcTimeOffsetApplied){
    qint64 secsdiff = lastPoweroffTime.secsTo(*rtcTimeOffsetApplied);
    currentLagMeasuredTimeInSecs = secsdiff;
    qDebug()<<"datebefore lag mitigation: "<<rtcTimeOffsetApplied->toString()<<" secsdiff: "<<secsdiff<<" multi: "<<lastRtcLagMulti;
    if (secsdiff<-120){
        qDebug()<<"negative time advance, probably rtc got reset.";
    }
    secsdiff = qMax(secsdiff-120,qint64(0));
    *rtcTimeOffsetApplied = rtcTimeOffsetApplied->addSecs(int(float(secsdiff)*lastRtcLagMulti));
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
    adjustedDateTime = adjustedDateTime.addSecs(hourDiff*3600+minDiff*60).addDays(dayDiff).addMonths(monthDiff).addYears(yearDiff);
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
