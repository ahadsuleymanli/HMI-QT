#include "iterativevaluechanger.h"


IterativeValueChanger::IterativeValueChanger(QString name, int increment_delay_ms, singleIterationCallback callback1_ptr, toggleKeyCallback toggleKeyCallback_ptr)
{
    this->name = name;
    this->callback1_ptr = callback1_ptr;
    this->toggleKeyCallback_ptr = toggleKeyCallback_ptr;
    connect(this,&IterativeValueChanger::singleIncrementFinished,this,&IterativeValueChanger::doSingleIncrement);
    connect(&delayTimer,&QTimer::timeout,this,&IterativeValueChanger::doSingleIncrement);
    delayTimer.setInterval(increment_delay_ms);
    delayTimer.stop();
}

void IterativeValueChanger::setMinMax(int min, int max, int turnOnDefault){
    this->min = min;
    this->max = max;
    this->turnOnDefault = turnOnDefault;
}

void IterativeValueChanger::setOffFunction(int turnOnDefault, singleIterationCallback turnOffCallback_ptr){
    this->turnOffCallback_ptr = turnOffCallback_ptr;
    this->turnOnDefault = turnOnDefault;
}

void IterativeValueChanger::turnOn(int current){
    if (current == -1){
        changeVal(current,turnOnDefault);
    }
}

void IterativeValueChanger::turnOff(int current){
    if (current != -1 && turnOffCallback_ptr == nullptr){
        this->turnOnDefault = current;
        changeVal(current,-1,-1);
    }
}

void IterativeValueChanger::changeVal(int current, int target, int min_, int max_){
    if (min_!=max_)
        target = (target > max_) ? max_ : (target < min_)? min_: target;
    else if (min != max)
        target = (target > max) ? max : (target < min)? min: target;

    delayTimer.stop();
    this->current = current;
    this->target = target;
    doSingleIncrement();
    delayTimer.start();
}

void IterativeValueChanger::toggleKey(QString onKey, QString offKey, int durationMs){
    toggleKeyCallback_ptr(onKey);
    QTimer::singleShot(durationMs,this,[this,offKey]{ this->toggleKeyCallback_ptr(offKey); });
}

void IterativeValueChanger::doSingleIncrement(){
    if (current==target){
        delayTimer.stop();
    }
    else {
//        QTextStream(stdout) << "ValueChanger:" << name << " value:" << current <<"\n";
        current = callback1_ptr(current,target);
    }
    if (current==target){
        delayTimer.stop();
    }

}
