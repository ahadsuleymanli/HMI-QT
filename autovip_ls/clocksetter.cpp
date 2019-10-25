#include "clocksetter.h"
#include <QProcess>

ClockSetter::ClockSetter(QObject *parent) :
    QObject (parent)
{
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
