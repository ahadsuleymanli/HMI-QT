#ifndef ITERATIVEVALUECHANGER_H
#define ITERATIVEVALUECHANGER_H

#include <QObject>
#include <QTimer>
#include <functional>
#include <iostream>
#include <QTextStream>

class IterativeValueChanger : public QObject
{
    Q_OBJECT
    QTimer delayTimer;
//    using voidCallback = void(*)();
    using singleIterationCallback = std::function<int(int current, int target)>;
    using toggleKeyCallback = std::function<int(QString function)>;
    singleIterationCallback callback1_ptr = nullptr;
    toggleKeyCallback toggleKeyCallback_ptr = nullptr;
    singleIterationCallback turnOffCallback_ptr = nullptr;
    int current;
    int target;
    int min = 0;
    int max = 0;
    int turnOnDefault;
    QString name;

public:
    IterativeValueChanger(QString name, int increment_delay_ms, singleIterationCallback callback1_ptr, toggleKeyCallback toggleKeyCallback_ptr = nullptr);
    void setMinMax(int min, int max, int turnOnDefault);
    void setOffFunction(int turnOnDefault, singleIterationCallback turnOffCallback_ptr = nullptr);
    void changeVal(int changeVal, int target, int min_=0, int max_=0);
    void turnOn(int current);
    void turnOff(int current);
    void toggleKey(QString onKey, QString offKey, int durationMs);

signals:
    void singleIncrementFinished();

private slots:
    void doSingleIncrement();

};

#endif // ITERATIVEVALUECHANGER_H
