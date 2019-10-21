#ifndef ITERATIVEVALUECHANGER_H
#define ITERATIVEVALUECHANGER_H

#include <QObject>

class IterativeValueChanger : public QObject
{
    Q_OBJECT
    int current;
    int target;
public:
    IterativeValueChanger();

signals:
    void singleIncrementFinished(int value);

public slots:
    void doSingleIncrement(int value);

};

#endif // ITERATIVEVALUECHANGER_H
