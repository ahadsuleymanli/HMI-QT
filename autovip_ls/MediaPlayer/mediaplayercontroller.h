#ifndef MEDIAPLAYERCONTROLLER_H
#define MEDIAPLAYERCONTROLLER_H

#include <QObject>
#include <QMediaPlayer>
#include <QMutex>
#include <QThread>
#include "tracklist.h"


class MediaPlayerController: public QMediaPlayer
{

    Q_OBJECT
//    Q_PROPERTY(QString playingTitle READ playingTitle NOTIFY playingMediaChanged)
//    Q_PROPERTY(QString playingYear READ playingYear NOTIFY playingMediaChanged)
//    Q_PROPERTY(QString playingArtist READ playingArtist NOTIFY playingMediaChanged)
//    Q_PROPERTY(QString playingCover READ playingCover NOTIFY playingMediaChanged)
//    Q_PROPERTY(bool shuffle READ getShuffle NOTIFY playModeChanged)
//    Q_PROPERTY(int loop READ getLoop NOTIFY playModeChanged)
public:
    MediaPlayerController(QObject *parent = nullptr);
    void process();
    void init();
    void setLoopHelper();
    QString playingTitle();
    QString playingYear();
    QString playingArtist();
    QString playingCover();
    bool getShuffle();
    int getLoop();
    void preventAudioBug();

public slots:
    void setShuffle();
    void setLoop();
    void playPause();
    void pause();
    void next();
    void previous();
    void playTrack(int index);
    void setVolume(int volume);
    TrackList* getTrackList(){return trackList;}
signals:
    void playingMediaChanged(int index, QString playingTitle,QString playingYear,QString playingArtist,QString playingCover);
    void playModeChanged(bool shuffle,int loop);

private:
    class DelayedFunctions: public QObject
    {
        QTimer pauseTimer;
        QTimer delayedPlayTimer;
        QTimer delayedPreviousTimer;
        QTimer delayedNextTimer;
        QTimer unmuteTimer;
        MediaPlayerController *parentMPC;
        int scheduledTrack = 0;
        bool playScheduled = false;
    public:
        DelayedFunctions(QObject *parent) : QObject(parent){
            this->parentMPC=(MediaPlayerController*)parent;
            pauseTimer.setInterval(250);
            pauseTimer.setSingleShot(true);
            pauseTimer.stop();
            delayedPlayTimer.setInterval(50);
            delayedPlayTimer.setSingleShot(true);
            delayedPlayTimer.stop();
            delayedPreviousTimer.setInterval(50);
            delayedPreviousTimer.setSingleShot(true);
            delayedPreviousTimer.stop();
            delayedNextTimer.setInterval(50);
            delayedNextTimer.setSingleShot(true);
            delayedNextTimer.stop();
            unmuteTimer.setInterval(75);
            unmuteTimer.setSingleShot(true);
            unmuteTimer.stop();
            connect(&pauseTimer,&QTimer::timeout,this,[this](){parentMPC->QMediaPlayer::pause(); parentMPC->setMuted(false);});
            connect(&delayedPreviousTimer,&QTimer::timeout,this,[this](){if(parentMPC->state()==QMediaPlayer::PlayingState) {playScheduled=true;parentMPC->stop();} parentMPC->playlist()->previous();});
            connect(&delayedNextTimer,&QTimer::timeout,this,[this](){if(parentMPC->state()==QMediaPlayer::PlayingState) {playScheduled=true;parentMPC->stop();} parentMPC->playlist()->next();});
            connect(&delayedPlayTimer,&QTimer::timeout,this,[this](){
                if(parentMPC->state()==QMediaPlayer::PlayingState)
                    parentMPC->stop();
                playScheduled=true;
                parentMPC->playlist()->setCurrentIndex(scheduledTrack);
            });
            connect(&unmuteTimer,&QTimer::timeout,this,[this](){parentMPC->setMuted(false);});
            connect(parentMPC, &QMediaPlayer::mediaStatusChanged,[=](){
                if(parentMPC->mediaStatus() == QMediaPlayer::LoadedMedia /*|| parentMPC->mediaStatus() == QMediaPlayer::LoadedMedia*/){
                    if (playScheduled){
                        parentMPC->play();
//                        unmuteTimer.start();
                    }
                }
                else if(parentMPC->mediaStatus() == QMediaPlayer::BufferedMedia){
                    if (playScheduled){
                        playScheduled=false;
                        parentMPC->play();
                        parentMPC->setMuted(false);
                    }
                }
            });
        }
        void stopTimers(){
            delayedPlayTimer.stop(); delayedPreviousTimer.stop(); delayedNextTimer.stop();
        }
        void delayedPause(){
            pauseTimer.stop();
            stopTimers();
            parentMPC->setMuted(true);
            pauseTimer.start();
        }
        void delayedPlayTrack(int track){
            stopTimers();
            parentMPC->setMuted(true);
            scheduledTrack = track;
            delayedPlayTimer.start();
            unmuteTimer.start();
        }
        void delayedPrevious(){
            stopTimers();
            parentMPC->setMuted(true);
            delayedPreviousTimer.start();
            unmuteTimer.start();
        }
        void delayedNext(){
            stopTimers();
            parentMPC->setMuted(true);
            delayedNextTimer.start();
            unmuteTimer.start();
        }

    };
    DelayedFunctions* delayedFunctions;
    int loopState = 0;
    bool shuffleEnabled = false;
    TrackList *trackList;
    QMediaPlayer *p_mediaPlayer;
};

#endif // MEDIAPLAYERCONTROLLER_H
