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
    Q_PROPERTY(qint64 position READ position WRITE setPosition NOTIFY positionChanged)

public:
    MediaPlayerBackend(QObject *parent = nullptr);
    Q_INVOKABLE TrackList* trackList() { qDebug()<<"invoking tracklist";
        return m_trackList; }

    QString playingTitle();
    QString playingYear();
    QString playingArtist();
    QString playingCover();
    qint64 position();

public slots:

    void pause();
    void play();
    void next();
    void previous();
    void shuffle(bool enabled = true);
    void setPosition(qint64 position){QMediaPlayer::setPosition(position);}

private slots:
    void pauseHelper(){setPlaylist(m_playList);
                       playlist()->setCurrentIndex(mediaIndex);
                      QMediaPlayer::setPosition(pausePos);
                      };

signals:
    void playingMediaChanged();
    void positionChanged(qint64 position);
    void pausePressed();

private:
    qint64 pausePos = 0;
    int mediaIndex = 0;
    TrackList *m_trackList;
    QMediaPlaylist *m_playList;
};

#endif // MEDIAPLAYERBACKEND_H
