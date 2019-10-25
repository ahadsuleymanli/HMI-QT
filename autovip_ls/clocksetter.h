#ifndef CLOCKSETTER_H
#define CLOCKSETTER_H


#include <QObject>


class ClockSetter : public QObject
{
    Q_OBJECT

public:
    explicit ClockSetter(QObject *parent = nullptr);
    Q_INVOKABLE void setTheClock(QString time);
    Q_INVOKABLE void setRegion(QString region);

signals:
    void sendKey(QString);
    void regionChanged(QString region);
public slots:
};

#endif // CLOCKSETTER_H
