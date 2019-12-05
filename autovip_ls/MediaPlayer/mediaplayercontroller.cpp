#include "mediaplayercontroller.h"
#include <QMediaMetaData>
#include <QBuffer>
#include <iostream>

MediaPlayerController::MediaPlayerController(QObject *parent)
    : QMediaPlayer(parent)
{
    setMuted(true);
    QTimer::singleShot(250,this,[this]{ setMuted(false); });
    m_trackList = new TrackList(this);
    connect(this, &QMediaPlayer::mediaStatusChanged,[=](){
        if(mediaStatus() == QMediaPlayer::BufferedMedia || mediaStatus() == QMediaPlayer::LoadedMedia){
            emit playingMediaChanged();
        }
    });

}

void MediaPlayerController::init(){
    m_trackList->connectUsbMounter();
}

QString MediaPlayerController::playingTitle()
{
    if(!playlist()) return QString();
    return metaData(QMediaMetaData::Title).toString();
}

QString MediaPlayerController::playingYear()
{
    if(!playlist()) return QString();
    return metaData(QMediaMetaData::Year).toString();
}

QString MediaPlayerController::playingArtist()
{
    if(!playlist()) return QString();
    return metaData(QMediaMetaData::ContributingArtist).toString();
}

QString MediaPlayerController::playingCover()
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


void MediaPlayerController::playPause(){
    if (!playlist()) return;
    if (state() == 1 && !paused){
        setMuted(true);
        QTimer::singleShot(250,this,[this]{ this->QMediaPlayer::pause(); setMuted(false); });
    }
    else{
        this->QMediaPlayer::play();
    }
}
void MediaPlayerController::next()
{
    if (!playlist()) return;
    if(playlist()->currentIndex() == playlist()->mediaCount() -1 )
        playlist()->setCurrentIndex(0);
    else
        playlist()->next();
}

void MediaPlayerController::previous()
{
   if (!playlist()) return;
   playlist()->previous();
}

void MediaPlayerController::setLoopHelper(){
    if (loopState==2){
        playlist()->setPlaybackMode(QMediaPlaylist::CurrentItemInLoop);
    }
    else if (shuffleEnabled){
        playlist()->setPlaybackMode(QMediaPlaylist::Random);
    }
    else if (loopState==0){
        playlist()->setPlaybackMode(QMediaPlaylist::Sequential);
    }
    else if (loopState==1){
        playlist()->setPlaybackMode(QMediaPlaylist::Loop);
    }
}

void MediaPlayerController::setShuffle(){
    if(!playlist()) return;
    shuffleEnabled = !shuffleEnabled;
    setLoopHelper();
    emit playModeChanged();
}
void MediaPlayerController::setLoop(){
    if(!playlist()) return;
    if (loopState == 0)
        loopState = 1;
    else if (loopState == 1)
        loopState = 2;
    else if (loopState == 2)
        loopState = 0;
    setLoopHelper();
    emit playModeChanged();
}
bool MediaPlayerController::getShuffle(){
    return shuffleEnabled;
}
int MediaPlayerController::getLoop(){
    return loopState;
}


