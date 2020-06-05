#include "serialmessagescheduler.h"

DelayedMessage::DelayedMessage(QString message, int delay, SerialMng *smng, DelayedMessage **head, QObject *parent): QObject(parent){
    this->smng = smng;
    this->message = message;
    this->head = head;
    postSendWaitTimer = new QTimer(this);
    postSendWaitTimer->setInterval(delay);
    postSendWaitTimer->setSingleShot(true);
    postSendWaitTimer->stop();
    connect(postSendWaitTimer, &QTimer::timeout, this, &DelayedMessage::timerAction);
}

void DelayedMessage::timerAction(){
    *head = next;
    if (next!=nullptr)
        next->sendMessageAndStartTimer();
    postSendWaitTimer->deleteLater();
    deleteLater();
}

void DelayedMessage::sendMessageAndStartTimer(){
    // redundancy, making sure same object does't send its message twice
    if (message!=""){
        this->smng->write(this->message.toUtf8());
        message="";
    }
    if (!postSendWaitTimer->isActive())
        postSendWaitTimer->start();
}

void SerialScheduler::enqueueMessage(QString message, int delay){
    DelayedMessage * iterator = delayedMessageHead;

    // find last element in queue
    int i=0;
    if (delayedMessageHead!=nullptr){
        while(iterator->next!=nullptr){
            i++;
            iterator=iterator->next;
        }
    }
    if (iterator==nullptr){
        delayedMessageHead = new DelayedMessage(message, delay, smng, &delayedMessageHead,this);
        delayedMessageHead->sendMessageAndStartTimer();
    }else{
        iterator->next = new DelayedMessage(message, delay, smng, &delayedMessageHead,this);
    }
}

bool SerialScheduler::messageQueueEmpty(){
    if (delayedMessageHead==nullptr)
        return true;
    else
        return false;
}


SerialScheduler::SerialScheduler(QSerialPort* serialConn, SerialMng *parent): QObject(parent){
    this->sm = &SettingsManager::instance();
    portname = this->sm->value("serial/port_name").toString();
    smng = parent;
    this->serialConn = serialConn;
    waitTimer = new QTimer(this);
    waitTimer->setInterval(51);
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
    connect(continiousSerialCheckTimer, &QTimer::timeout, this, [this](){
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
//        qDebug()<<"trying to reopen serial port";
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
