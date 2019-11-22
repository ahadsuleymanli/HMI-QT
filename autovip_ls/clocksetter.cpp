#include "clocksetter.h"
#include <QProcess>
#include <QDebug>

ClockSetter::ClockSetter(QObject *parent) :
    QObject (parent)
{
    hourDiff = sm->value("main/hourdiff").toInt();
    minDiff = sm->value("main/mindiff").toInt();
}

void ClockSetter::setTimeDiff(int minDiff, int hourDiff, int daydiff,  int monthdiff, int yeardiff)
{
    sm->setTimeDiff(minDiff,hourDiff);
    this->hourDiff = hourDiff;
    this->minDiff = minDiff;
    emit timeDiffChanged(minDiff,hourDiff);
}

QDateTime ClockSetter::getAdjustedTime(){
//    QString hours = QString::number(QTime::currentTime().hour() + hourDiff).rightJustified(2, '0');
//    QString mins = QString::number(QTime::currentTime().minute() + minDiff).rightJustified(2, '0');
//    QString string = "01 Jan 2005 "+hours+":"+mins;
    QDateTime adjustedDateTime = QDateTime::currentDateTime();
    QTime tempTime = QTime::currentTime();
    tempTime = tempTime.addSecs(hourDiff*3600+minDiff*60);
    adjustedDateTime.setTime(tempTime);
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
        hourDiff = 0;
        minDiff = 0;
        sm->setTimeDiff(0,0);
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
