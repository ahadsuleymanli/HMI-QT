#ifndef CRONJOBS_H
#define CRONJOBS_H
#include <QObject>
#include <QProcess>
#include <QTimer>
#include <QDebug>
#include <QThread>
#include <stdlib.h>

class CronJobs : public QObject
{
    Q_OBJECT
    QTimer * timer = nullptr;
    int timeout = 3000;
    QProcess *disable_dpms=nullptr;
//  QProcess *enable_dpms=nullptr;
public:
    explicit CronJobs(QObject *parent=nullptr) : QObject(parent){}
public slots:
    // TODO: check if this prevents the hangups. if it does, move this functionality to a boost thread with a system() call
    void process(){
        #if !(defined(__arm__) or defined(__aarch64__))
            return;
        #endif
        this->disable_dpms = new QProcess(this);
        this->timer = new QTimer(this);
        this->timer->setInterval(timeout);
        connect(timer,&QTimer::timeout,this,[=](){
            disable_dpms->startDetached("/bin/sh", QStringList()<< "-c"<<"xset -dpms && xset dpms 4");
        });
        this->timer->start();
    }

};

#endif // CRONJOBS_H
