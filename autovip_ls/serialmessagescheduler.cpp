#include "serialmessagescheduler.h"

SerialScheduler::SerialScheduler(SerialMng *parent): QObject(parent){
    smng = parent;
    waitTimer = new QTimer(this);
    waitTimer->setInterval(105);
    waitTimer->setSingleShot(true);
    waitTimer->stop();
    connect(waitTimer, &QTimer::timeout, this, [this](){
        if (lastKey!=""){
            sendKey(this->lastKey,this->lastKeyParameter);

        }
    });
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
