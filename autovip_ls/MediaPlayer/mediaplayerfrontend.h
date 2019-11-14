#ifndef MEDIAPLAYERFRONTEND_H
#define MEDIAPLAYERFRONTEND_H

#include <QObject>

class MediaPlayerFrontend : public QObject
{
    Q_OBJECT
public:
    MediaPlayerFrontend(QObject *parent = nullptr){}
public slots:

    void playPause(){emit playPauseSignal();}
    void next(){emit nextSignal();}
    void previous(){emit previousSignal();}
signals:
    void playPauseSignal();
    void nextSignal();
    void previousSignal();
//    void shuffle(bool enabled = true);

};

#endif // MEDIAPLAYERFRONTEND_H
