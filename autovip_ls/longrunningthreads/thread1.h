#ifndef THREAD1_H
#define THREAD1_H

#include <QDateTime>
#include <QObject>
#include <QThread>
#include <clocksetter.h>
#include <QDebug>
#include <longrunningthreads/datawriter.h>
#include <MediaPlayer/facade.h>
#include <longrunningthreads/threadutils.h>
#include <longrunningthreads/cronjobs.h>

class LongRunningThread : public QThread
{
    DataWriterWorker *dataWriterWorker;
    MediaPlayerFacade *mPlayerFacade;
    MpdClient *mpdClient;
    QTimer *heartbeatTimer;
public:
    LongRunningThread(ClockSetter *clockSetter,MediaPlayerFacade *mPlayerFacade, QObject* parent = nullptr) : QThread(parent) {
        dataWriterWorker = new DataWriterWorker();
        this->mPlayerFacade=mPlayerFacade;
        clockSetter->setLastPowerOffTime(dataWriterWorker->getLastPowerOffTime());
        dataWriterWorker->moveToThread(this);

        heartbeatTimer = new QTimer(nullptr);
        heartbeatTimer->start(2000);
        connect(heartbeatTimer,&QTimer::timeout,dataWriterWorker,&DataWriterWorker::heartBeat,Qt::QueuedConnection);
        connect(clockSetter,&ClockSetter::timeIsSet,dataWriterWorker,&DataWriterWorker::startTimeLogging);
        connect(this, SIGNAL(started()), dataWriterWorker, SLOT(connections()));
        connect(this, SIGNAL(finished()), this, SLOT(deleteLater()));
        this->start();
    }
    void run(){
        ThreadUtils::stick_this_thread_to_core(3);
        mpdClient = new MpdClient(this);
        bool mpdStarted = mpdClient->start();
        if (mpdStarted){
            qDebug()<<"mpdc started";
            mPlayerFacade->mpdConnections(mpdClient);
        }
        QThread::exec();
    }

};
#endif // THREAD1_H


