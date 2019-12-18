#ifndef FACADE_H
#define FACADE_H
#include <QObject>
#include <QThread>
#include "mpdclient.h"
#include "settingsmanager.h"
#include "tracklist.h"
#include "libmpdclient-0.13.0/libmpdclient.h"
class MediaPlayerFacade: public QObject
{
    Q_OBJECT


    Q_PROPERTY(QString playingTitle MEMBER playingTitle NOTIFY playingMediaChanged)
    Q_PROPERTY(QString playingYear MEMBER playingYear NOTIFY playingMediaChanged)
    Q_PROPERTY(QString playingArtist MEMBER playingArtist NOTIFY playingMediaChanged)
    Q_PROPERTY(QString playingCover MEMBER playingCover NOTIFY playingMediaChanged)
    Q_PROPERTY(bool shuffle MEMBER shuffle NOTIFY playModeChanged)
    Q_PROPERTY(int loop MEMBER loop NOTIFY playModeChanged)
    Q_PROPERTY(int state MEMBER state NOTIFY stateChanged)
    Q_PROPERTY(qint64 duration MEMBER duration NOTIFY durationChanged)
    Q_PROPERTY(qint64 position MEMBER position WRITE setPosition NOTIFY positionChanged)

    QString playingTitle;
    QString playingYear;
    QString playingArtist;
    QString playingCover;
    bool shuffle = false;
    int loop = 0;
    int state = 0;
    qint64 duration = 0;
    qint64 position = 0;
    SettingsManager *sm = &SettingsManager::instance();
    TrackListModel *trackListModel;
    MpdClient *mpdClient;

    int volume;

public:
    MediaPlayerFacade(QObject *parent = nullptr): QObject(parent){
        trackListModel = new TrackListModel(this);
        connect(this, &MediaPlayerFacade::trackListLayoutChanged,this,[=](){emit trackListModel->layoutChanged();});
    }
    void mpdConnections(MpdClient *mpdClient){
        connect(mpdClient, &MpdClient::playingSong, [=](const mpd_Song* currentSong,const mpd_Status* status){
            if (currentSong->title)
                playingTitle=currentSong->title;
            else
                playingTitle=currentSong->file;
            playingYear=currentSong->date;
            playingArtist=currentSong->artist;
            duration=status->totalTime;
            position=status->elapsedTime;
            state=status->state;
            shuffle=bool(status->random);
            loop = status->repeat?(status->single?2:1):0;
            emit playModeChanged();
            emit stateChanged();
            emit durationChanged();
            emit positionChanged();
            emit playingMediaChanged();
        });
//        connect(mpdClient, &MpdClient::changedSong, [=](const mpd_Song* new_song){
//            if (new_song){
//                TrackContent tc;
//                if (new_song->title)
//                    tc.trackName=new_song->title;
//                else
//                    tc.trackName=new_song->file;
//                tc.artistName=new_song->artist;
//                trackListModel->pushBackToTrackContents(&tc);
//            }
//            emit trackListModel->layoutChanged();
//        });
        connect(mpdClient, &MpdClient::changedPlaylist, [=](const QList<mpd_Song*> *playlist){
            qDebug()<<"rebuilding tracklist";
            trackListModel->clear();
            foreach(auto &x,*playlist){
                TrackContent tc;
                if (x->title)
                    tc.trackName=x->title;
                else
                    tc.trackName=x->file;
                tc.artistName=x->artist;
                trackListModel->pushBackToTrackContents(&tc);
            }
            emit trackListLayoutChanged();
        });

        QList<mpd_Song*> lst = mpdClient->getPlaylist();
        foreach(auto &x,lst){
            TrackContent tc;
            if (x->title)
                tc.trackName=x->title;
            else
                tc.trackName=x->file;
            tc.artistName=x->artist;
            trackListModel->pushBackToTrackContents(&tc);
        }
        emit trackListLayoutChanged();
        connect(this, &MediaPlayerFacade::playPause,mpdClient,&MpdClient::playPause);
        connect(this, &MediaPlayerFacade::next,mpdClient,&MpdClient::next);
        connect(this, &MediaPlayerFacade::previous,mpdClient,&MpdClient::prev);
        connect(this, &MediaPlayerFacade::signalPlayTrack,mpdClient,&MpdClient::playIndex);
        connect(this, &MediaPlayerFacade::setPositionCalled,mpdClient,&MpdClient::seekCurrent);
        connect(this, &MediaPlayerFacade::setLoop,mpdClient,&MpdClient::toggleRepeat);
        connect(this, &MediaPlayerFacade::setShuffle,mpdClient,&MpdClient::toggleRandom);
    }
    Q_INVOKABLE TrackListModel* getTrackListModel() {
        return trackListModel; }
    Q_INVOKABLE void playTrack(int index) {
        emit signalPlayTrack(index);
    }
    void setPosition(qint64 position){this->position=position; emit setPositionCalled(position);}

public slots:
signals:
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
    void trackListLayoutChanged();
};

//void facadeConnections(MediaPlayerController*mediaPlayerController){
//    this->mediaPlayerController=mediaPlayerController;
//    mediaPlayerController->setVolume(volume);
//    connect(mediaPlayerController, &MediaPlayerController::playingMediaChanged,this,&MediaPlayerFacade::getPlayingMediaChanged);
//    connect(mediaPlayerController, &MediaPlayerController::playModeChanged,this,&MediaPlayerFacade::getPlayModeChanged);
//    connect(mediaPlayerController, &MediaPlayerController::stateChanged,this,&MediaPlayerFacade::getStateChanged);
//    connect(mediaPlayerController, &MediaPlayerController::durationChanged,this,&MediaPlayerFacade::getDurationChanged);
//    connect(mediaPlayerController, &MediaPlayerController::positionChanged,this,&MediaPlayerFacade::getPositionChanged);
//    connect(mediaPlayerController->getTrackList(), &TrackList::trackListUpdated,this,&MediaPlayerFacade::trackListModelUpdated);
//    connect(this, &MediaPlayerFacade::initCalled,mediaPlayerController,&MediaPlayerController::init);
//    connect(this, &MediaPlayerFacade::playPause,mediaPlayerController,&MediaPlayerController::playPause);
//    connect(this, &MediaPlayerFacade::setShuffle,mediaPlayerController,&MediaPlayerController::setShuffle);
//    connect(this, &MediaPlayerFacade::setLoop,mediaPlayerController,&MediaPlayerController::setLoop);
//    connect(this, &MediaPlayerFacade::next,mediaPlayerController,&MediaPlayerController::next);
//    connect(this, &MediaPlayerFacade::previous,mediaPlayerController,&MediaPlayerController::previous);
//    connect(this, &MediaPlayerFacade::setPositionCalled,mediaPlayerController,&MediaPlayerController::setPosition);
//    connect(this, &MediaPlayerFacade::signalPlayTrack,mediaPlayerController,&MediaPlayerController::playTrack);
//    connect(this, &MediaPlayerFacade::pause,mediaPlayerController,&MediaPlayerController::pause);
//}

#endif // FACADE_H
