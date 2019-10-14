#ifndef CLOCKSETTER_H
#define CLOCKSETTER_H


#include <QObject>


class ClockSetter : public QObject
{
    Q_OBJECT

public:
    explicit ClockSetter(QObject *parent = nullptr);
    Q_INVOKABLE void setTheClock();

signals:
    void sendKey(QString);

public slots:
};

#endif // CLOCKSETTER_H
