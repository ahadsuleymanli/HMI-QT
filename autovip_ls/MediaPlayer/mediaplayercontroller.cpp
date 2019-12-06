#include "mediaplayercontroller.h"
#include <QMediaMetaData>
#include <QBuffer>
#include <iostream>
#include <QThread>
#include <QGuiApplication>

MediaPlayerController::MediaPlayerController(QObject *parent) : QMediaPlayer(parent)
{
    m_player = this;
    setMuted(true);
    m_trackList = new TrackList(this,this);
}
void MediaPlayerController::process(){

    QTimer::singleShot(250,m_player,[=]{ m_player->setMuted(false); });
    connect(m_player, &QMediaPlayer::mediaStatusChanged,[=](){
        if(m_player->mediaStatus() == QMediaPlayer::BufferedMedia || m_player->mediaStatus() == QMediaPlayer::LoadedMedia){
            emit playingMediaChanged(playingTitle(),playingYear(),playingArtist(),playingCover());
        }
    });
}
void MediaPlayerController::init(){
    if (m_trackList){
        m_trackList->connectUsbMounter();
    }
    else{
        QTimer::singleShot(500,this,[this]{ qDebug()<<"m_trackList was not ready trying again..."; init(); });
    }
}

QString MediaPlayerController::playingTitle()
{
    if(!m_player->playlist()) return QString();
    return m_player->metaData(QMediaMetaData::Title).toString();
}

QString MediaPlayerController::playingYear()
{
    if(!m_player->playlist()) return QString();
    return m_player->metaData(QMediaMetaData::Year).toString();
}

QString MediaPlayerController::playingArtist()
{
    if(!m_player->playlist()) return QString();
    return m_player->metaData(QMediaMetaData::ContributingArtist).toString();
}

QString MediaPlayerController::playingCover()
{
    if(!m_player->playlist()) return QString();
    QImage image = m_player->metaData(QMediaMetaData::CoverArtImage).value<QImage>();
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
    qDebug()<<"playpause called from: "<<QThread::currentThreadId();
    if (!m_player->playlist()) return;
    if (m_player->state() == 1){
        m_player->setMuted(true);
        QTimer::singleShot(250,m_player,[=]{ m_player->QMediaPlayer::pause(); m_player->setMuted(false); });
    }
    else{
        m_player->QMediaPlayer::play();
    }
}
void MediaPlayerController::next()
{
    if (!m_player->playlist()) return;
    if(m_player->playlist()->currentIndex() == m_player->playlist()->mediaCount() -1 )
        m_player->playlist()->setCurrentIndex(0);
    else
        m_player->playlist()->next();
}

void MediaPlayerController::previous()
{
   if (!m_player->playlist()) return;
   m_player->playlist()->previous();
}

void MediaPlayerController::setLoopHelper(){
    if (loopState==2){
        m_player->playlist()->setPlaybackMode(QMediaPlaylist::CurrentItemInLoop);
    }
    else if (shuffleEnabled){
        m_player->playlist()->setPlaybackMode(QMediaPlaylist::Random);
    }
    else if (loopState==0){
        m_player->playlist()->setPlaybackMode(QMediaPlaylist::Sequential);
    }
    else if (loopState==1){
        m_player->playlist()->setPlaybackMode(QMediaPlaylist::Loop);
    }
}

void MediaPlayerController::setShuffle(){
    if(!m_player->playlist()) return;
    shuffleEnabled = !shuffleEnabled;
    setLoopHelper();
    emit playModeChanged(getShuffle(),getLoop());
}
void MediaPlayerController::setLoop(){
    if(!m_player->playlist()) return;
    if (loopState == 0)
        loopState = 1;
    else if (loopState == 1)
        loopState = 2;
    else if (loopState == 2)
        loopState = 0;
    setLoopHelper();
    emit playModeChanged(getShuffle(),getLoop());
}
bool MediaPlayerController::getShuffle(){
    return shuffleEnabled;
}
int MediaPlayerController::getLoop(){
    return loopState;
}


