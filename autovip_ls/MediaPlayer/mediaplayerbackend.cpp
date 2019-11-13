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
//    connect(this, SIGNAL(QMediaPlayer::positionChanged(qint64)), SIGNAL(MediaPlayerBackend::setPosition_(qint64)));
    connect(this,&QMediaPlayer::positionChanged,this,&MediaPlayerBackend::positionChanged);
    connect(this,&MediaPlayerBackend::pausePressed,this,&MediaPlayerBackend::pauseHelper);
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

qint64 MediaPlayerBackend::position(){
    if ((state()==1 && pausePos == 0) || (state()!=1 && pausePos != 0)){
        return  QMediaPlayer::position();
//        return 5;
    }
    else {
        qint64 ret = pausePos;
        return ret;
    }
}

void MediaPlayerBackend::pause(){
    pausePos = QMediaPlayer::position();
    mediaIndex = playlist()->currentIndex();
    setMedia(nullptr);
//    emit pausePressed();


}

void MediaPlayerBackend::play(){
    pauseHelper();
    pausePos = 0;
    QMediaPlayer::play();

}
void MediaPlayerBackend::next()
{
    pausePos = 0;
    pauseHelper();
    if(playlist()->currentIndex() == playlist()->mediaCount() -1 )
        playlist()->setCurrentIndex(0);
    else
        playlist()->next();
}

void MediaPlayerBackend::previous()
{
   pausePos = 0;
   pauseHelper();
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
