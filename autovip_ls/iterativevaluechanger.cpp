#include "iterativevaluechanger.h"

IterativeValueChanger::IterativeValueChanger(int increment_delay_ms, voidCallback callback_ptr, voidCallback endCallback_ptr)
{
    this->callback_ptr = callback_ptr;
    this->endCallback_ptr = endCallback_ptr;
    connect(this,&IterativeValueChanger::singleIncrementFinished,this,&IterativeValueChanger::doSingleIncrement);
    connect(&delayTimer,&QTimer::timeout,this,&IterativeValueChanger::doSingleIncrement);
    delayTimer.setInterval(increment_delay_ms);
    delayTimer.stop();
}

void IterativeValueChanger::start(int current, int target){
    delayTimer.stop();
    this->current = current;
    this->target = target;
    doSingleIncrement();
}

void IterativeValueChanger::doSingleIncrement(){
    delayTimer.stop();
    current = callback_ptr(current,target);
    if (current!=target)
        delayTimer.start();
}
