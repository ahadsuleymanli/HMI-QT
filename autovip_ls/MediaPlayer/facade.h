#ifndef FACADE_H
#define FACADE_H
#include "mediaplayercontroller.h"
#include <QObject>
//class WorkerObject: public QObject
//{
//    Q_OBJECT
//public:
//    MediaPlayerController *mediaPlayerController;
//    WorkerObject(QObject *parent = nullptr){
//    }
//    void process(){
//        mediaPlayerController = new MediaPlayerController();

//    }
//};
class MediaPlayerFacade: public QObject
{
    Q_OBJECT


    Q_PROPERTY(QString playingTitle READ playingTitle NOTIFY playingMediaChanged)
    Q_PROPERTY(QString playingYear READ playingYear NOTIFY playingMediaChanged)
    Q_PROPERTY(QString playingArtist READ playingArtist NOTIFY playingMediaChanged)
    Q_PROPERTY(QString playingCover READ playingCover NOTIFY playingMediaChanged)
    Q_PROPERTY(bool shuffle READ getShuffle NOTIFY playModeChanged)
    Q_PROPERTY(int loop READ getLoop NOTIFY playModeChanged)
    QString _playingTitle;
    QString _playingYear;
    QString _playingArtist;
    QString _playingCover;
    bool _shuffle;
    int _loop;
    QString playingTitle(){return _playingTitle;}
    QString playingYear(){return _playingYear;}
    QString playingArtist(){return _playingArtist;}
    QString playingCover(){return _playingCover;}
    bool getShuffle(){return _shuffle;}
    int getLoop(){return _loop;}
public:
    MediaPlayerController *mediaPlayerController;
    MediaPlayerFacade(QObject *parent = nullptr){

    }
    void facadeConnections(MediaPlayerController*mediaPlayerController){
//        mediaPlayerController = new MediaPlayerController(this);
        connect(this, &MediaPlayerFacade::playPause,mediaPlayerController,&MediaPlayerController::playPause);
        connect(this, &MediaPlayerFacade::initCalled,mediaPlayerController,&MediaPlayerController::init);
    }
//    void makeConnections(){
//        connect(this, &MediaPlayerFacade::playPause,worker->mediaPlayerController,&MediaPlayerController::playPause);
//    }

    void init(){emit initCalled(); }
signals:
    void initCalled();
    void setShuffle();
    void setLoop();
    void playPause();
    void next();
    void previous();
    void playModeChanged();
    void playingMediaChanged();
};


#endif // FACADE_H
