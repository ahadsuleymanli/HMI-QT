#ifndef MEDIAPLAYERCONTROLLER_H
#define MEDIAPLAYERCONTROLLER_H

#include <QObject>
#include <QMediaPlayer>
#include <QMutex>
#include "tracklist.h"


class MediaPlayerController: public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString playingTitle READ playingTitle NOTIFY playingMediaChanged)
    Q_PROPERTY(QString playingYear READ playingYear NOTIFY playingMediaChanged)
    Q_PROPERTY(QString playingArtist READ playingArtist NOTIFY playingMediaChanged)
    Q_PROPERTY(QString playingCover READ playingCover NOTIFY playingMediaChanged)
    Q_PROPERTY(bool shuffle READ getShuffle NOTIFY playModeChanged)
    Q_PROPERTY(int loop READ getLoop NOTIFY playModeChanged)
//    QMutex metadataMutex;
public:
    MediaPlayerController(QObject *parent = nullptr);
    void process();
    void init();
    Q_INVOKABLE TrackList* trackList() {return m_trackList; }
    void setLoopHelper();
    QString playingTitle();
    QString playingYear();
    QString playingArtist();
    QString playingCover();
    bool getShuffle();
    int getLoop();
//    QVariant metaData(const QString &key) {metadataMutex.lock();return QMediaPlayer::metaData(key);metadataMutex.unlock();}

public slots:
    void setShuffle();
    void setLoop();
    void playPause();
    void next();
    void previous();

signals:
    void playingMediaChanged();
    void playModeChanged();

private:
    int loopState = 0;
    bool shuffleEnabled = false;
    TrackList *m_trackList;
    QMediaPlayer *m_player;
    QMediaPlaylist *m_playList;
};

#endif // MEDIAPLAYERCONTROLLER_H
