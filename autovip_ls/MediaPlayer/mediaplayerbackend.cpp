#include "mediaplayerbackend.h"
#include <QMediaMetaData>
#include <QBuffer>
#include <iostream>

MediaPlayerBackend::MediaPlayerBackend(QObject *parent)
    : QMediaPlayer(parent)
{
    m_playList = new QMediaPlaylist(this);
    setPlaylist(m_playList);
    m_trackList = new TrackList(m_playList);

    connect(this, &QMediaPlayer::mediaStatusChanged,[=](){
        if(mediaStatus() == QMediaPlayer::BufferedMedia || mediaStatus() == QMediaPlayer::LoadedMedia){
            emit playingMediaChanged();
        }
    });
    m_trackList->connectUsbMounter();
}

QString MediaPlayerBackend::playingTitle()
{
    if(!playlist()) return QString();
    return metaData(QMediaMetaData::Title).toString();
}

QString MediaPlayerBackend::playingYear()
{
    if(!playlist()) return QString();
    return metaData(QMediaMetaData::Year).toString();
}

QString MediaPlayerBackend::playingArtist()
{
    if(!playlist()) return QString();
    return metaData(QMediaMetaData::ContributingArtist).toString();
}

QString MediaPlayerBackend::playingCover()
{
    if(!playlist()) return QString();
    QImage image = metaData(QMediaMetaData::CoverArtImage).value<QImage>();
    if(image.isNull()) return QString();
    QByteArray bArray;
    QBuffer buffer(&bArray);
    buffer.open(QIODevice::WriteOnly);
    image.save(&buffer, "JPEG");
    image.isNull();
    QString imgStr = "data:image/jpg;base64,";

    imgStr.append(QString::fromLatin1(bArray.toBase64().data()));
    return imgStr;
}

qint64 MediaPlayerBackend::position() const{
    if (pausePos)
        return pausePos;
    else {
        qint64 pos = QMediaPlayer::position();
        return pos;
    }
}

void MediaPlayerBackend::pause(){
    pausePos = QMediaPlayer::position();
    QMediaPlayer::stop();
    setMuted(true);

}
void MediaPlayerBackend::play(){
    setPosition(pausePos);
    pausePos = 0;
    QMediaPlayer::play();
    setMuted(false);
}
void MediaPlayerBackend::next()
{
    pausePos = 0;
    if(playlist()->currentIndex() == playlist()->mediaCount() -1 )
        playlist()->setCurrentIndex(0);
    else
        playlist()->next();
}

void MediaPlayerBackend::previous()
{
   pausePos = 0;
   playlist()->previous();
}

void MediaPlayerBackend::shuffle(bool enabled)
{
    if(enabled)
        playlist()->shuffle();
}

//void MediaPlayerBackend::pause()
//{

//}
