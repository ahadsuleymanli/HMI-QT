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

public:
    MediaPlayerBackend(QObject *parent = nullptr);
    Q_INVOKABLE TrackList* trackList() { qDebug()<<"invoking tracklist";
        return m_trackList; }

    QString playingTitle();
    QString playingYear();
    QString playingArtist();
    QString playingCover();
    qint64 position() const;

public slots:

    void pause();
    void play();
    void next();
    void previous();
    void shuffle(bool enabled = true);


signals:
    void playingMediaChanged();

private:
    qint64 pausePos = 0;
    TrackList *m_trackList;
    QMediaPlaylist *m_playList;
};

#endif // MEDIAPLAYERBACKEND_H
