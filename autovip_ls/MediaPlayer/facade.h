#ifndef FACADE_H
#define FACADE_H
#include <QObject>
#include <QThread>
#include "mediaplayercontroller.h"
#include "settingsmanager.h"
class MediaPlayerFacade: public QObject
{
    Q_OBJECT


    Q_PROPERTY(QString playingTitle MEMBER playingTitle NOTIFY playingMediaChanged)
    Q_PROPERTY(QString playingYear MEMBER playingYear NOTIFY playingMediaChanged)
    Q_PROPERTY(QString playingArtist MEMBER playingArtist NOTIFY playingMediaChanged)
    Q_PROPERTY(QString playingCover MEMBER playingCover NOTIFY playingMediaChanged)
    Q_PROPERTY(bool shuffle MEMBER shuffle NOTIFY playModeChanged)
    Q_PROPERTY(int loop MEMBER loop NOTIFY playModeChanged)
    Q_PROPERTY(QMediaPlayer::State state MEMBER state NOTIFY stateChanged)
    Q_PROPERTY(qint64 duration MEMBER duration NOTIFY durationChanged)
    Q_PROPERTY(qint64 position MEMBER position WRITE setPosition NOTIFY positionChanged)

    QString playingTitle;
    QString playingYear;
    QString playingArtist;
    QString playingCover;
    bool shuffle = false;
    int loop = 0;
    QMediaPlayer::State state = QMediaPlayer::StoppedState;
    qint64 duration = 0;
    qint64 position = 0;
    MediaPlayerController *mediaPlayerController;
    SettingsManager *sm = &SettingsManager::instance();
    TrackListModel *trackListModel;
    int volume;

public:

    MediaPlayerFacade(QObject *parent = nullptr){
        trackListModel = new TrackListModel(this);
        QVariant sm_volume=sm->value("media/volume");
        if (!sm_volume.isValid()){
            sm->getSettings()->setValue("media/volume",70);
            volume = 70;
        }
        else
            volume = sm_volume.toInt();
    }
    void applyUserSettings(){
        setUserSettings(shuffle,loop);
    }
    void facadeConnections(MediaPlayerController*mediaPlayerController){
        this->mediaPlayerController=mediaPlayerController;
        mediaPlayerController->setVolume(volume);
//        qDebug()<<"facade connection called from: "<<QThread::currentThreadId();
        connect(mediaPlayerController, &MediaPlayerController::playingMediaChanged,this,&MediaPlayerFacade::getPlayingMediaChanged);
        connect(mediaPlayerController, &MediaPlayerController::playModeChanged,this,&MediaPlayerFacade::getPlayModeChanged);
        connect(mediaPlayerController, &MediaPlayerController::stateChanged,this,&MediaPlayerFacade::getStateChanged);
        connect(mediaPlayerController, &MediaPlayerController::durationChanged,this,&MediaPlayerFacade::getDurationChanged);
        connect(mediaPlayerController, &MediaPlayerController::positionChanged,this,&MediaPlayerFacade::getPositionChanged);
        connect(mediaPlayerController->getTrackList(), &TrackList::trackListUpdated,this,&MediaPlayerFacade::trackListModelUpdated);
        connect(this, &MediaPlayerFacade::initCalled,mediaPlayerController,&MediaPlayerController::init);
        connect(this, &MediaPlayerFacade::playPause,mediaPlayerController,&MediaPlayerController::playPause);
        connect(this, &MediaPlayerFacade::setShuffle,mediaPlayerController,&MediaPlayerController::setShuffle);
        connect(this, &MediaPlayerFacade::setLoop,mediaPlayerController,&MediaPlayerController::setLoop);
        connect(this, &MediaPlayerFacade::next,mediaPlayerController,&MediaPlayerController::next);
        connect(this, &MediaPlayerFacade::previous,mediaPlayerController,&MediaPlayerController::previous);
        connect(this, &MediaPlayerFacade::setPositionCalled,mediaPlayerController,&MediaPlayerController::setPosition);
        connect(this, &MediaPlayerFacade::signalPlayTrack,mediaPlayerController,&MediaPlayerController::playTrack);
        connect(this, &MediaPlayerFacade::pause,mediaPlayerController,&MediaPlayerController::pause);
        connect(this, &MediaPlayerFacade::setUserSettings,mediaPlayerController,&MediaPlayerController::setUserSettings);
    }
    Q_INVOKABLE TrackListModel* trackList() {
        return trackListModel; }
    Q_INVOKABLE void playTrack(int index) {
        qDebug()<<"play emitted from: "<<QThread::currentThreadId();
        emit signalPlayTrack(index);
    }
    void setPosition(qint64 position){this->position=position; emit setPositionCalled(position);}

    void init(){emit initCalled(); }
public slots:
    void getPlayingMediaChanged(int index, QString playingTitle,QString playingYear,QString playingArtist,QString playingCover){
        if (playingTitle=="" && trackListModel->getTrackContents()->length()>index){
            this->playingTitle= (trackListModel->getTrackContents()->at(index)).trackName.toString();
        }
        else
            this->playingTitle=playingTitle;
        this->playingYear=playingYear;
        this->playingArtist=playingArtist;
        this->playingCover=playingCover;
        emit playingMediaChanged();
    }
    void getPlayModeChanged(bool shuffle,int loop){
        this->shuffle=shuffle;
        this->loop=loop;
        emit playModeChanged();
    }
    void getStateChanged(QMediaPlayer::State state){
        this->state=state;
        emit stateChanged();
    }
    void getDurationChanged(qint64 duration){
        this->duration=duration;
        emit durationChanged();
    }
    void getPositionChanged(qint64 position){
        this->position=position;
        emit positionChanged();
    }
    void trackListModelUpdated(TrackListModel *p){
        trackListModel->copyObject(p);
//        this->trackListModel=p;
//        qDebug()<<"tracklist copy is "<<trackListModel;
        emit trackListModel->layoutChanged();
    }


signals:
    void initCalled();
    void setShuffle();
    void setLoop();
    void playPause();
    void next();
    void previous();
    void playModeChanged();
    void playingMediaChanged();
    void stateChanged();void durationChanged();void positionChanged();
    void setPositionCalled(qint64 position);
    void signalPlayTrack(int index);
    void pause();
    void setUserSettings(bool shuffleEnabled, int loopState);
};


#endif // FACADE_H
