#ifndef THREAD_H
#define THREAD_H

#include <QDateTime>
#include <QObject>
#include <QThread>
#include <clocksetter.h>
#include <QDebug>
#include <IOThread/datawriter.h>
#include <MediaPlayer/mediaplayercontroller.h>
class IOThread : public QThread
{

    DataWriterWorker *dataWriterWorker;

public:
    IOThread(ClockSetter *clockSetter,MediaPlayerController *mPlayer, QObject* parent = nullptr) : QThread(parent) {
        dataWriterWorker = new DataWriterWorker();
        clockSetter->setLastPowerOffTime(dataWriterWorker->getLastPowerOffTime());
        dataWriterWorker->moveToThread(this);
        connect(clockSetter,&ClockSetter::timeIsSet,dataWriterWorker,&DataWriterWorker::startTimeLogging);
        connect(this, SIGNAL(started()), dataWriterWorker, SLOT(process()));
        connect(this, SIGNAL(finished()), this, SLOT(deleteLater()));
        this->start();
    }
};
#endif // THREAD_H


