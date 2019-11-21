#include "mediaplayerbackend.h"
#include <QMediaMetaData>
#include <QBuffer>
#include <iostream>

MediaPlayerBackend::MediaPlayerBackend(QObject *parent)
    : QMediaPlayer(parent)
{
    m_playList = new QMediaPlaylist(this);
    setPlaylist(m_playList);
    m_trackList = new TrackList(m_playList, this);
    setMuted(true);
    connect(this, &QMediaPlayer::mediaStatusChanged,[=](){
        if(mediaStatus() == QMediaPlayer::BufferedMedia || mediaStatus() == QMediaPlayer::LoadedMedia){
            emit playingMediaChanged();
        }
    });
    QTimer::singleShot(250,this,[this]{ setMuted(false); });
}

void MediaPlayerBackend::init(){
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



void MediaPlayerBackend::playPause(){
    if (state() == 1 && !paused){
        setMuted(true);
        QTimer::singleShot(250,this,[this]{ this->QMediaPlayer::pause(); setMuted(false); });
    }
    else{
        this->QMediaPlayer::play();
//        QTimer::singleShot(100,this,[this]{  });
    }




}
void MediaPlayerBackend::next()
{
    if(playlist()->currentIndex() == playlist()->mediaCount() -1 )
        playlist()->setCurrentIndex(0);
    else
        playlist()->next();
}

void MediaPlayerBackend::previous()
{
   playlist()->previous();
}


void MediaPlayerBackend::setLoopHelper(){
    if (loopState==0){
        playlist()->setPlaybackMode(QMediaPlaylist::Sequential);
    }
    else if (loopState==1){
        playlist()->setPlaybackMode(QMediaPlaylist::CurrentItemInLoop);
    }
    else if (loopState==2){
        playlist()->setPlaybackMode(QMediaPlaylist::Loop);
    }
}

void MediaPlayerBackend::setShuffle(){
    shuffleEnabled = !shuffleEnabled;
    if (shuffleEnabled){
        playlist()->setPlaybackMode(QMediaPlaylist::Random);
    }
    else {
        setLoopHelper();
    }
    emit playModeChanged();
}
void MediaPlayerBackend::setLoop(){
    if (shuffleEnabled)
        shuffleEnabled = false;
    else if (loopState == 0)
        loopState = 1;
    else if (loopState == 1)
        loopState = 2;
    else if (loopState == 2)
        loopState = 0;
    setLoopHelper();
    emit playModeChanged();
}
bool MediaPlayerBackend::getShuffle(){
    return shuffleEnabled;
}
int MediaPlayerBackend::getLoop(){
    if (shuffleEnabled)
        return 0;
    else
        return loopState;
}


