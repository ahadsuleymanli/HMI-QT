#ifndef SECONDTHREAD_H
#define SECONDTHREAD_H

#include <QThread>
#include "mediaplayerbackend.h"

class SecondThread : public QThread
{
signals:
 void aSignal();

public slots:
    void play() {
        emit mPlayerBackend->play();
    }
    void pause() {
        emit mPlayerBackend->pause();
    }
    void playPause() {
        emit mPlayerBackend->playPause();
    }
    void next() {
        emit mPlayerBackend->next();
    }
    void previous() {
        emit mPlayerBackend->previous();
    }

private:
 MediaPlayerBackend *mPlayerBackend;
protected:
    void run() {
        mPlayerBackend = new MediaPlayerBackend(this);
        QThread::exec();
    }
};

#endif // SECONDTHREAD_H
