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
    int dayDiff;
    int monthDiff;
    int yearDiff;
    Q_PROPERTY(QDateTime adjustedDateTime READ getAdjustedTime() NOTIFY timeDiffChanged)
//    Q_PROPERTY(int minDiff READ getMinDiff() NOTIFY timeDiffChanged)
//    Q_PROPERTY(int hourDiff READ getHourDiff() NOTIFY timeDiffChanged)
    int getMinDiff(){return sm->value("main/mindiff").toInt();}
    int getHourDiff(){return sm->value("main/hourdiff").toInt();}
public:
    explicit ClockSetter(QObject *parent = nullptr);
    Q_INVOKABLE void setTimeDiff(int minDIff, int hourDiff, int dayDiff=0,  int monthDiff=0, int yearDiff=0);
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
