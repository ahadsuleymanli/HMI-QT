#include "clocksetter.h"
#include <QProcess>
#include <QDebug>

ClockSetter::ClockSetter(QObject *parent) :
    QObject (parent)
{
    this->minDiff = sm->value("main/mindiff").toInt();
    this->hourDiff = sm->value("main/hourdiff").toInt();
    this->dayDiff = sm->value("main/daydiff").toInt();
    this->monthDiff = sm->value("main/monthdiff").toInt();
    this->yearDiff = sm->value("main/yeardiff").toInt();
}

void ClockSetter::setTimeDiff(int minDiff, int hourDiff, int dayDiff,  int monthDiff, int yearDiff)
{
    sm->setTimeDiff(minDiff,hourDiff,dayDiff,monthDiff,yearDiff);
    this->hourDiff = hourDiff;
    this->minDiff = minDiff;
    this->dayDiff = dayDiff;
    this->monthDiff = monthDiff;
    this->yearDiff = yearDiff;
    emit timeDiffChanged(minDiff,hourDiff);
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

void ClockSetter::setTheClock(QString time)
{
    QProcess *ntpSetter = new QProcess();
    QProcess *timeSetter = new QProcess();

    connect(timeSetter, SIGNAL(finished(int, QProcess::ExitStatus)),
            timeSetter, SLOT(deleteLater()));

    ntpSetter->start("/bin/sh", QStringList() << "-c" << "timedatectl set-ntp false");
    connect(ntpSetter, qOverload<int, QProcess::ExitStatus >(&QProcess::finished),
            [=](){
        timeSetter->start("/bin/sh", QStringList() << "-c" << "timedatectl set-time '"+time
                          +"'");
        ntpSetter->deleteLater();
    });
    emit sendKey("media/back_monitor");
}

void ClockSetter::setRegion(QString region)
{
    QProcess *ntpSetter = new QProcess();
    QProcess *regionSetter = new QProcess();

    connect(regionSetter, qOverload<int, QProcess::ExitStatus >(&QProcess::finished),
            [=](){
        this->setTimeDiff(0,0,0,0,0);
        emit regionChanged(region);
        regionSetter->deleteLater();
    });

    QString timeZone;
    if(region == "Turkey")
        timeZone = "Europe/Istanbul";
    else if(region == "China")
        timeZone = "Asia/Shanghai";
    ntpSetter->start("/bin/sh", QStringList() << "-c" << "timedatectl set-ntp true");
    connect(ntpSetter, qOverload<int, QProcess::ExitStatus >(&QProcess::finished),
            [=](){
        regionSetter->start("/bin/sh", QStringList() << "-c" << "timedatectl set-timezone '" +
                            timeZone + "'");
        ntpSetter->deleteLater();
    });
}
