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
    void playingMediaChanged(QString playingTitle,QString playingYear,QString playingArtist,QString playingCover);
    void playModeChanged(bool shuffle,int loop);

private:
    int loopState = 0;
    bool shuffleEnabled = false;
    TrackList *trackList;
    QMediaPlayer *p_mediaPlayer;
    QMediaPlaylist *playList;
};

#endif // MEDIAPLAYERCONTROLLER_H
