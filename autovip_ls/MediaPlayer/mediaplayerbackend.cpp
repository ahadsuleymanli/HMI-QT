#include "mediaplayerbackend.h"
#include <QMediaMetaData>
#include <QBuffer>

MediaPlayerBackend::MediaPlayerBackend(QObject *parent)
    : QMediaPlayer(parent)
{
    m_playList = new QMediaPlaylist(this);
    setPlaylist(m_playList);
    m_trackList = new TrackList(m_playList);

    connect(m_trackList, &TrackList::listReady, [=](){
        m_playList->setCurrentIndex(0);
        qDebug() << "listReady";
        emit playingMediaChanged();
    });
    connect(this, &QMediaPlayer::mediaStatusChanged,[=](){
        qDebug() << mediaStatus() << m_playList->currentIndex() << m_playList->mediaCount();
        if(mediaStatus() == QMediaPlayer::BufferedMedia){
            emit playingMediaChanged();
        }
    });
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


void MediaPlayerBackend::next()
{
    if(playlist()->currentIndex() == playlist()->mediaCount() -1 )
        playlist()->setCurrentIndex(0);
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


