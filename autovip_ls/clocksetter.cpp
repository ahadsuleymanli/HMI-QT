#include "clocksetter.h"

ClockSetter::ClockSetter(QObject *parent) :
    QObject (parent)
{
}

void ClockSetter::setTheClock()
{
emit sendKey("media/back_monitor");
}
