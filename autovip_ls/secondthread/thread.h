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
class SecondThread : public QThread
{
    DataWriterWorker *dataWriterWorker;
    MediaPlayerController *mediaPlayerController;
public:
    SecondThread(ClockSetter *clockSetter,MediaPlayerFacade *mPlayerFacade, QObject* parent = nullptr) : QThread(parent) {
        dataWriterWorker = new DataWriterWorker();
        clockSetter->setLastPowerOffTime(dataWriterWorker->getLastPowerOffTime());
        dataWriterWorker->moveToThread(this);

        mediaPlayerController = new MediaPlayerController();
        mediaPlayerController->moveToThread(this);
        mPlayerFacade->facadeConnections(mediaPlayerController);
        connect(clockSetter,&ClockSetter::timeIsSet,dataWriterWorker,&DataWriterWorker::startTimeLogging);
        connect(this, SIGNAL(started()), dataWriterWorker, SLOT(process()));
        connect(this, &QThread::started, mediaPlayerController, &MediaPlayerController::process);
        connect(this, SIGNAL(finished()), this, SLOT(deleteLater()));
        this->start();
//        mPlayerFacade->init();
    }
    void run(){
        ThreadUtils::stick_this_thread_to_core(3);
        QThread::exec();
    }

};
#endif // THREAD_H


