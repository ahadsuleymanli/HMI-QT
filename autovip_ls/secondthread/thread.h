#ifndef THREAD_H
#define THREAD_H

#include <QDateTime>
#include <QObject>
#include <QThread>
#include <clocksetter.h>
#include <QDebug>
#include <secondthread/datawriter.h>
#include <MediaPlayer/facade.h>
#include <secondthread/threadutils.h>
#include <secondthread/cronjobs.h>

class SecondThread : public QThread
{
    DataWriterWorker *dataWriterWorker;
    MediaPlayerFacade *mPlayerFacade;
    MpdClient *mpdClient;
public:
    SecondThread(ClockSetter *clockSetter,MediaPlayerFacade *mPlayerFacade, QObject* parent = nullptr) : QThread(parent) {
        dataWriterWorker = new DataWriterWorker();
        clockSetter->setLastPowerOffTime(dataWriterWorker->getLastPowerOffTime());
        dataWriterWorker->moveToThread(this);
        this->mPlayerFacade=mPlayerFacade;


//        cronjobs->moveToThread(this);
//        connect(this, SIGNAL(started()), cronjobs, SLOT(process()));

        connect(clockSetter,&ClockSetter::timeIsSet,dataWriterWorker,&DataWriterWorker::startTimeLogging);
        connect(this, SIGNAL(started()), dataWriterWorker, SLOT(process()));
        connect(this, SIGNAL(finished()), this, SLOT(deleteLater()));
        this->start();
    }
    void run(){
        ThreadUtils::stick_this_thread_to_core(3);
        mpdClient = new MpdClient;
        bool mpdStarted = mpdClient->start();
        if (mpdStarted){
            qDebug()<<"mpd started";
            mPlayerFacade->mpdConnections(mpdClient);
        }
        QThread::exec();
    }

};
#endif // THREAD_H


