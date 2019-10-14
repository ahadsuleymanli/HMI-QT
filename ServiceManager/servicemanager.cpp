#include "servicemanager.h"
#include <QProcess>
#include <QTimer>
#include <QDebug>

ServiceManager::ServiceManager(QObject *parent) : QObject(parent)
{

}

bool ServiceManager::startService()
{

    QProcess start;
    QStringList args;
    args<<"service"<<"dizaynvip"<<"start";
    qDebug()<<"starting v3";
    start.start("sudo",args);
    start.waitForFinished(3000);
    start.kill();
    return true;
}

bool ServiceManager::stopService()
{
    QProcess stop;
    QStringList args;
    args<<"service"<<"dizaynvip"<<"stop";
    qDebug()<<"ending v3";
    stop.start("sudo",args);
    stop.waitForFinished(3000);
    stop.kill();
    return true;
}

bool ServiceManager::moveFiles()
{
    QProcess mv;
    QStringList args;
    args<<"rm"<<"-f"<<"autovip_ls";
    qDebug()<<"rm v3";
    mv.start("sudo",args);
    mv.waitForFinished(1000);
    args.clear();
    args<<"mv"<<"./update_1_1/autovip_ls"<<".";
    qDebug()<<"mv v3";
    mv.start("sudo",args);
    mv.waitForFinished(1000);
    args.clear();
    args<<"chmod"<<"+x"<<"autovip_ls"<<".";
    qDebug()<<"chmod v3";
    mv.start("sudo",args);
    mv.waitForFinished(1000);
    args.clear();
    args<<"chown"<<"linaro"<<"autovip_ls"<<".";
    qDebug()<<"chown v3";
    mv.start("sudo",args);
    mv.waitForFinished(1000);
    args.clear();
    args<<"chgrp"<<"linaro"<<"autovip_ls"<<".";
    qDebug()<<"chgrp v3";
    mv.start("sudo",args);
    mv.waitForFinished(1000);
    
    return true;
}

bool ServiceManager::restartService()
{
    return true;
}

void ServiceManager::simulate()
{
    QTimer::singleShot(3000,this,&ServiceManager::stopService);
    QTimer::singleShot(6000,this,&ServiceManager::moveFiles);
    QTimer::singleShot(10000,this,&ServiceManager::startService);

}
