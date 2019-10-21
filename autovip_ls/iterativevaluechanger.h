#ifndef ITERATIVEVALUECHANGER_H
#define ITERATIVEVALUECHANGER_H

#include <QObject>
#include <QTimer>
#include <functional>
class IterativeValueChanger : public QObject
{
    Q_OBJECT
    QTimer delayTimer;
//    using voidCallback = void(*)();
    using voidCallback = std::function<int(int current, int target)>;
    voidCallback callback_ptr;
    voidCallback endCallback_ptr;
    int current;
    int target;

public:
    IterativeValueChanger(int increment_delay_ms, voidCallback callback_ptr, voidCallback endCallback_ptr = nullptr);
    void start(int start, int target);

signals:
    void singleIncrementFinished();

private slots:
    void doSingleIncrement();

};

#endif // ITERATIVEVALUECHANGER_H
