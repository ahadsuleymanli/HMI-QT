#include "mediaplayercontroller.h"
#include <QMediaMetaData>
#include <QBuffer>
#include <iostream>
#include <QThread>
#include <QGuiApplication>

MediaPlayerController::MediaPlayerController(QObject *parent) : QMediaPlayer(parent)
{
    p_mediaPlayer = this;
    p_mediaPlayer->setMuted(true);
    trackList = new TrackList(this,this);

}
void MediaPlayerController::preventAudioBug(){
    setMuted(true);
    QTimer::singleShot(250,p_mediaPlayer,[=]{ p_mediaPlayer->setMuted(false); });
}
void MediaPlayerController::process(){
    connect(trackList,&TrackList::loadingList,this,&MediaPlayerController::preventAudioBug);
    connect(trackList, &TrackList::listCleared,[=](){
            emit playingMediaChanged(0,playingTitle(),playingYear(),playingArtist(),playingCover());
    });
    connect(p_mediaPlayer, &QMediaPlayer::mediaStatusChanged,[=](){
        if(p_mediaPlayer->mediaStatus() == QMediaPlayer::BufferedMedia || p_mediaPlayer->mediaStatus() == QMediaPlayer::LoadedMedia || p_mediaPlayer->mediaStatus() == QMediaPlayer::EndOfMedia){
            qDebug()<<"mediastatus: "<<mediaStatus();
            emit playingMediaChanged(playlist()->currentIndex(),playingTitle(),playingYear(),playingArtist(),playingCover());
        }
    });
    delayedFunctions=new DelayedFunctions(this);
}
void MediaPlayerController::init(){
    if (trackList){
        trackList->connectUsbMounter();
    }
    else{
        QTimer::singleShot(500,this,[this]{ qDebug()<<"m_trackList was not ready trying again..."; init(); });
    }
}

QString MediaPlayerController::playingTitle()
{
    if(!p_mediaPlayer->playlist()) return QString();
    return p_mediaPlayer->metaData(QMediaMetaData::Title).toString();
}

QString MediaPlayerController::playingYear()
{
    if(!p_mediaPlayer->playlist()) return QString();
    return p_mediaPlayer->metaData(QMediaMetaData::Year).toString();
}

QString MediaPlayerController::playingArtist()
{
    if(!p_mediaPlayer->playlist()) return QString();
    return p_mediaPlayer->metaData(QMediaMetaData::ContributingArtist).toString();
}

QString MediaPlayerController::playingCover()
{
    if(!p_mediaPlayer->playlist()) return QString();
    QImage image = p_mediaPlayer->metaData(QMediaMetaData::CoverArtImage).value<QImage>();
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

void MediaPlayerController::playTrack(int index) {
    qDebug()<<"play called in: "<<QThread::currentThreadId();
    if (!p_mediaPlayer->playlist()) return;
    if (index == playlist()->currentIndex())
        playPause();
    else{
        delayedFunctions->delayedPlayTrack(index);
    }

}
void MediaPlayerController::playPause(){
    qDebug()<<"playpause called from: "<<QThread::currentThreadId();
    if (!p_mediaPlayer->playlist()) return;
    if (p_mediaPlayer->state() == QMediaPlayer::PlayingState){
        delayedFunctions->delayedPause();
        emit stateChanged(QMediaPlayer::PausedState);
    }
    else{
        emit stateChanged(QMediaPlayer::PlayingState);
        p_mediaPlayer->QMediaPlayer::play();
    }
}
void MediaPlayerController::pause(){
    if (!p_mediaPlayer->playlist()) return;
    delayedFunctions->delayedPause();
}
void MediaPlayerController::setVolume(int volume){
    p_mediaPlayer->setVolume(volume);
}
void MediaPlayerController::next()
{
    if (!p_mediaPlayer->playlist()) return;
    delayedFunctions->delayedNext();
}

void MediaPlayerController::previous()
{
   if (!p_mediaPlayer->playlist()) return;
   delayedFunctions->delayedPrevious();
}

void MediaPlayerController::setLoopHelper(){
    if (loopState==2){
        p_mediaPlayer->playlist()->setPlaybackMode(QMediaPlaylist::CurrentItemInLoop);
    }
    else if (shuffleEnabled){
        p_mediaPlayer->playlist()->setPlaybackMode(QMediaPlaylist::Random);
    }
    else if (loopState==0){
        p_mediaPlayer->playlist()->setPlaybackMode(QMediaPlaylist::Sequential);
    }
    else if (loopState==1){
        p_mediaPlayer->playlist()->setPlaybackMode(QMediaPlaylist::Loop);
    }
}

void MediaPlayerController::setShuffle(){
    if(!p_mediaPlayer->playlist()) return;
    shuffleEnabled = !shuffleEnabled;
    setLoopHelper();
    emit playModeChanged(getShuffle(),getLoop());
}
void MediaPlayerController::setLoop(){
    if(!p_mediaPlayer->playlist()) return;
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


