#ifndef CLOCKSETTER_H
#define CLOCKSETTER_H


#include <QObject>
#include "settingsmanager.h"
#include <QDateTime>

class ClockSetter : public QObject
{
    Q_OBJECT
    SettingsManager *sm = &SettingsManager::instance();
    int minDiff;
    int hourDiff;
    Q_PROPERTY(int minDiff READ getMinDiff() NOTIFY timeDiffChanged)
    Q_PROPERTY(int hourDiff READ getHourDiff() NOTIFY timeDiffChanged)
    int getMinDiff(){return sm->value("main/mindiff").toInt();}
    int getHourDiff(){return sm->value("main/hourdiff").toInt();}
public:
    explicit ClockSetter(QObject *parent = nullptr);
    Q_INVOKABLE void setTimeDiff(int minDIff, int hourDiff, int daydiff=0,  int monthdiff=0, int yeardiff=0);
    Q_INVOKABLE void setTheClock(QString time);
    Q_INVOKABLE void setRegion(QString region);
    Q_INVOKABLE QDateTime getAdjustedTime();

signals:
    void sendKey(QString);
    void timeDiffChanged(int minDiff, int hourDiff);
    void regionChanged(QString region);
public slots:
};

#endif // CLOCKSETTER_H
