#ifndef MEDIAPLAYERBACKEND_H
#define MEDIAPLAYERBACKEND_H

#include <QObject>
#include <QMediaPlayer>
#include "tracklist.h"

class MediaPlayerBackend: public QMediaPlayer
{
    Q_OBJECT
    Q_PROPERTY(QString playingTitle READ playingTitle NOTIFY playingMediaChanged)
    Q_PROPERTY(QString playingYear READ playingYear NOTIFY playingMediaChanged)
    Q_PROPERTY(QString playingArtist READ playingArtist NOTIFY playingMediaChanged)
    Q_PROPERTY(QString playingCover READ playingCover NOTIFY playingMediaChanged)
    Q_PROPERTY(bool shuffle READ getShuffle NOTIFY playModeChanged)
    Q_PROPERTY(int loop READ getLoop NOTIFY playModeChanged)
//    Q_PROPERTY(qint64 position READ position WRITE setPosition NOTIFY positionChanged)

public:
    MediaPlayerBackend(QObject *parent = nullptr);
    void init();
    Q_INVOKABLE TrackList* trackList() {return m_trackList; }
    Q_INVOKABLE void setShuffle();
    Q_INVOKABLE void setLoop();
    void setLoopHelper();
    QString playingTitle();
    QString playingYear();
    QString playingArtist();
    QString playingCover();
//    qint64 position();

public slots:

//    void pause();
    void playPause();
    void next();
    void previous();
    bool getShuffle();
    int getLoop();
//    void setPosition(qint64 position){QMediaPlayer::setPosition(position);}

private slots:
    void pauseHelper(){
        qDebug()<<"pause helper, pauseState: "<<pauseState;
        switch(pauseState){
            case 1:
                pauseState = 2;
                setPlaylist(m_playList);
                break;
            case 2:
                pauseState = 3;
                playlist()->setCurrentIndex(mediaIndex);
                QMediaPlayer::setPosition(pausePos);
                break;
            case 3:
                pauseState = 4;
                QMediaPlayer::setPosition(pausePos);
                QMediaPlayer::play();
                break;
        }
    }
    void positionSetter(){
        qDebug()<<"positionSetter, pauseState: "<<pauseState;
        if(pauseState == 4 && paused){
            pauseState = 5;
            QMediaPlayer::setPosition(pausePos);
        }
    }
    void positionSetter2(){
        if(pauseState == 5 && paused){
        qDebug()<<"positionsetter2 "<<QMediaPlayer::position();
            if (QMediaPlayer::position() < pausePos){

                QMediaPlayer::setPosition(pausePos);

            }
            else if (QMediaPlayer::position() > pausePos) {
                pauseState = 0;
                pausePos = 0;
                paused = false;
            }
        }
    }

signals:
    void playingMediaChanged();
    void positionChanged(qint64 position);
    void pausePressed();
    void playModeChanged();

private:
    int loopState = 0;
    bool shuffleEnabled = false;
    int pauseState = 0;
    bool paused = false;
    qint64 pausePos = 0;
    int mediaIndex = 0;
    TrackList *m_trackList;
    QMediaPlaylist *m_playList;
};

#endif // MEDIAPLAYERBACKEND_H
