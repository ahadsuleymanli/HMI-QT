#ifndef MEDIAPLAYERBACKEND_H
#define MEDIAPLAYERBACKEND_H

#include <QObject>
#include <QMediaPlayer>
#include "tracklist.h"

class MediaPlayerBackend: public QMediaPlayer
{
    Q_OBJECT
    Q_PROPERTY(QString playingTitle READ playingTitle NOTIFY playingMediaChanged)
public:
    MediaPlayerBackend(QObject *parent = nullptr);
    Q_INVOKABLE TrackList* trackList() { return m_trackList; }

    QString playingTitle();

public slots:

    void next();
    void previous();

    void shuffle(bool enabled = true);

signals:
    void playingMediaChanged();

private:
    TrackList *m_trackList;
    QMediaPlaylist *m_playList;
};

#endif // MEDIAPLAYERBACKEND_H
