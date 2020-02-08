#include "serialmessagescheduler.h"

SerialScheduler::SerialScheduler(QSerialPort* serialConn, SerialMng *parent): QObject(parent){
    this->sm = &SettingsManager::instance();
    portname = this->sm->value("serial/port_name").toString();
    smng = parent;
    this->serialConn = serialConn;
    waitTimer = new QTimer(this);
    waitTimer->setInterval(105);
    waitTimer->setSingleShot(true);
    waitTimer->stop();
    connect(waitTimer, &QTimer::timeout, this, [this](){
        if (lastKey!=""){
            sendKey(this->lastKey,this->lastKeyParameter);

        }
    });
    reopenSerialTimer = new QTimer(this);
    reopenSerialTimer->setInterval(3000);
    reopenSerialTimer->setSingleShot(true);
    reopenSerialTimer->stop();
    continiousSerialCheckTimer = new QTimer(this);
    continiousSerialCheckTimer->setInterval(300000);
//    continiousSerialCheckTimer->setInterval(200);
    connect(continiousSerialCheckTimer, &QTimer::timeout, this, [this](){
        qDebug()<<"scheduled serial check";
        if (not this->serialConn->isOpen()){
            qDebug()<<"serial appears to be closed";
            reopenSerial(true);
        }
    });
    continiousSerialCheckTimer->start();
}
void SerialScheduler::reopenSerial(bool wait){
    if (!reopenSerialTimer->isActive()){
        reopenSerialTimer->start();
        qDebug()<<"trying to reopen serial port";
        serialConn->close();
        QProcess *removeProcess = new QProcess();
        connect(removeProcess, SIGNAL(finished(int,QProcess::ExitStatus)), removeProcess, SLOT(deleteLater()));
        removeProcess->start("sudo rm /var/lock/LCK.."+portname);
        removeProcess->waitForFinished(1000);
        smng->openSerialPort();
    }
}
void SerialScheduler::sendKey(QString key,QString param){
    if (waitTimer->isActive()){
        lastKey = key;
        lastKeyParameter=param;
    }
    else{
        this->lastKey = "";
        this->lastKeyParameter = "";
        smng->sendKey(key, false, -1,param);
        waitTimer->start();
    }
}
bool SerialScheduler::queueHasntEnded(){
    return (waitTimer->isActive()||lastKey!="");
}
