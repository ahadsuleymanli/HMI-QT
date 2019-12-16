#ifndef CRONJOBS_H
#define CRONJOBS_H
#include <QObject>
#include <QProcess>
#include <QTimer>
#include <QDebug>
#include <QThread>
//#include <stdlib.h>
//    QProcess *toggle_dpms=nullptr;
//toggle_dpms->start("/bin/sh", QStringList()<< "-c"<<"xset -dpms && xset dpms 4");
//std::system("xset -dpms && xset dpms 4");
class CronJobs : public QObject
{
    Q_OBJECT
    QTimer * timer = nullptr;
    int timeout = 3000;

    QProcess *enable_dpms=nullptr;
    QProcess *disable_dpms=nullptr;
public:
    explicit CronJobs(QObject *parent=nullptr) : QObject(parent){

    }
public slots:
    // TODO: check if this prevents the hangups. if it does move this functionality to pure C++
    void process(){
        #if !(defined(__arm__) or defined(__aarch64__))
            return;
        #endif
        this->disable_dpms = new QProcess(this);
//        this->enable_dpms = new QProcess(this);
        this->timer = new QTimer(this);
        this->timer->setInterval(timeout);
        connect(timer,&QTimer::timeout,this,[=](){
            disable_dpms->start("xset -dpms && xset dpms 4",QIODevice::NotOpen);
        });
//        connect(disable_dpms, qOverload<int, QProcess::ExitStatus >(&QProcess::finished),this,
//                [=](){
//            enable_dpms->start("xset dpms 4");
//        });
        this->timer->start();
    }

};

#endif // CRONJOBS_H
