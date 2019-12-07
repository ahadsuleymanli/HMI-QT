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
    MediaPlayerFacade *mPlayerFacade;
public:
    SecondThread(ClockSetter *clockSetter,MediaPlayerFacade *mPlayerFacade, QObject* parent = nullptr) : QThread(parent) {
        dataWriterWorker = new DataWriterWorker();
        clockSetter->setLastPowerOffTime(dataWriterWorker->getLastPowerOffTime());
        dataWriterWorker->moveToThread(this);
        this->mPlayerFacade=mPlayerFacade;

        connect(clockSetter,&ClockSetter::timeIsSet,dataWriterWorker,&DataWriterWorker::startTimeLogging);
        connect(this, SIGNAL(started()), dataWriterWorker, SLOT(process()));
        connect(this, SIGNAL(finished()), this, SLOT(deleteLater()));
        this->start();
    }
    void run(){
        ThreadUtils::stick_this_thread_to_core(0);
        mediaPlayerController = new MediaPlayerController(this);
        mPlayerFacade->facadeConnections(mediaPlayerController);
        mediaPlayerController->process();

        QThread::exec();
    }

};
#endif // THREAD_H


