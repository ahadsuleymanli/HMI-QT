#include "mediaplayerbackend.h"
#include <QMediaMetaData>

MediaPlayerBackend::MediaPlayerBackend(QObject *parent)
    : QMediaPlayer(parent)
{
    m_playList = new QMediaPlaylist(this);
    setPlaylist(m_playList);
    m_trackList = new TrackList(m_playList);
    m_playList->setCurrentIndex(0);
    connect(this, &QMediaPlayer::mediaStatusChanged,[=](){
        qDebug() << mediaStatus() << m_playList->currentIndex() << m_playList->mediaCount();
        if(mediaStatus() == QMediaPlayer::BufferedMedia){
            qDebug() << "loaded";
            emit playingMediaChanged();
        }
    });
}

QString MediaPlayerBackend::playingTitle()
{
    qDebug() << "title";
    if(!playlist()) return QString();
    qDebug() << metaData(QMediaMetaData::Title).toString();
    return metaData(QMediaMetaData::Title).toString();
}


void MediaPlayerBackend::next()
{
    playlist()->next();
}

void MediaPlayerBackend::previous()
{
   playlist()->previous();
}

void MediaPlayerBackend::shuffle(bool enabled)
{
    if(enabled)
        playlist()->shuffle();
}


