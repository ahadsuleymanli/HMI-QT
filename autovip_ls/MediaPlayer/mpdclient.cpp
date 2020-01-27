#include "mpdclient.h"

#include <stdlib.h> /* for getenv, atoi */
#include <assert.h>
#include <QTimer>
#include <QDebug>
#include <QThread>
#define error(str) \
    std::cerr << __FILE__ ":" << __LINE__ << ": " << str << std::endl
static const mpd_Song _NULL_SONG = {
    /*.file =	*/ "",
    /*.artist =	*/ "",
    /*.title = 	*/ "",
    /*.album = 	*/ "",
    /*.track = 	*/ "",
    /*.name = 	*/ "",
    /*.date = 	*/ "",
    /*.genre = 	*/ "",
    /*.composer = 	*/ "",
    /*.performer =	*/ "",
    /*.disc = 	*/ "",
    /*.comment = 	*/ "",
    /*.time =	*/ 0,
    /*.pos = 	*/ 0,
    /*.id = 	*/ 0,
};
static const mpd_Song *NULL_SONG = &_NULL_SONG;

MpdClient::MpdClient(QObject *parent) : QObject(parent)
{
    conn = nullptr;
    status = nullptr;
}

bool MpdClient::start()
{
    if (usbMounter == nullptr)
        usbMounter = new UsbMounter(this);
    char *host = getenv("MPD_HOST");
    char *port = getenv("MPD_PORT");
    this->playlistAddScritp = new QProcess();
    connect(playlistAddScritp, qOverload<int, QProcess::ExitStatus >(&QProcess::finished),
            [=](){
        update();
    });
    qDebug()<<"getenv finished";
    if (host == nullptr)
        host = "localhost";
    if (port == nullptr)
        port = "6600";
    conn = mpd_newConnection(host, atoi(port), 10);
    qDebug()<<"conn created";
    if (!conn){
        qDebug()<<"conn is null";
        return false;
    }
    if (conn->error) {
        error(conn->errorStr);
        qDebug()<<"mpdc connection error";
        return false;
    }
    mpd_finishCommand(conn);

    updateTimer = new QTimer(this);
    updateTimer->setInterval(1000);
    connect(updateTimer, SIGNAL(timeout()), this, SLOT(update()));
    updateTimer->start();
    update();
    connect(usbMounter, &UsbMounter::usbMounted,this,&MpdClient::addFilesToPlaylist);
    connect(usbMounter, &UsbMounter::usbUnMounted,this,&MpdClient::deletePlaylist);

    emit usbMounter->readyToCheck(false);
    return true;
}
void MpdClient::playIndex(int idx){
    if (idx >= playlist.size()){
        return;
    }
    if (idx==status->song)
        playPause();
    else{
        mpd_sendPlayCommand(conn,idx);
        update();
    }
}
void MpdClient::next(){
    if (status->state==1){
        mpd_sendPlayCommand2(conn);
        mpd_finishCommand(conn);
    }
    mpd_sendNextCommand(conn);
    mpd_finishCommand(conn);
    if (status->state!=2){
        mpd_sendPauseCommand(conn,1);
        mpd_finishCommand(conn);
        mpd_sendSeekCurCommand(conn,0);
        mpd_finishCommand(conn);
    }
    update();
}
void MpdClient::prev(){
    if (status->state==1){
        mpd_sendPlayCommand2(conn);
        mpd_finishCommand(conn);
    }
    mpd_sendPrevCommand(conn);
    mpd_finishCommand(conn);
    if (status->state!=2){
        mpd_sendPauseCommand(conn,1);
        mpd_finishCommand(conn);
        mpd_sendSeekCurCommand(conn,0);
        mpd_finishCommand(conn);
    }
    update();
}
void MpdClient::playPause(){
    if (status->state==2)
        mpd_sendPauseCommand(conn,1);
    else
        mpd_sendPlayCommand2(conn);
    update();

}
void MpdClient::pause(){
    if (status->state==2){
        mpd_sendPauseCommand(conn,1);
        update();
        mpd_finishCommand(conn);
        if (status->state==2){
            mpd_sendPauseCommand(conn,1);
        }
    }
}
void MpdClient::seekCurrent(int time){
    if (status->state!=2 && status->state!=3){
        mpd_sendPauseCommand(conn,1);
        mpd_finishCommand(conn);
    }
    mpd_sendSeekCurCommand(conn,time);
    update();
}
void MpdClient::update()
{
    if (updateTimer)
        updateTimer->stop();
    mpd_Status *old = status;
    mpd_sendStatusCommand(conn);

    status = mpd_getStatus(conn);

    if (!status) {
        status = old;
        if (updateTimer){
            updateTimer->setInterval(10);
            updateTimer->start();
        }
        return;
    }else{
        if (updateTimer){
            updateTimer->setInterval(1000);
            updateTimer->start();
        }
    }
    mpd_finishCommand(conn);

    if (!(old && old->playlist == status->playlist)) {
        if (old)
            updatePlaylist(old->playlist);
        else
            updatePlaylist(-1);

//        if (currentSong())
//            emit(playingSong(currentSong(),status));
    }
//    else if (old->song == status->song && currentSong())
//        emit(playingSong(currentSong(),status));
    if (old)
        mpd_freeStatus(old);
    if (currentSong())
        emit(playingSong(currentSong(),status));

}

void MpdClient::updatePlaylist(long long version)
{
    if (version < 0)
        mpd_sendPlChangesCommand(conn, version);
    else
        mpd_sendPlaylistInfoCommand(conn, -1);

    mpd_InfoEntity *entity;
    while ((entity = mpd_getNextInfoEntity(conn))) {
        assert(entity->type == MPD_INFO_ENTITY_TYPE_SONG);

        mpd_Song *song = mpd_songDup(entity->info.song);
        mpd_freeInfoEntity(entity);

        if (!(song->pos <= playlist.size())){
            qDebug()<<"err: song->pos <= playlist.size()";
            return;
        }

        if (song->pos == playlist.size())
            playlist += song;
        else {
            mpd_freeSong(playlist[song->pos]);
            playlist[song->pos] = song;
        }

        emit changedSong(song);
    }

    mpd_finishCommand(conn);

    /* remove extra songs if the playlist was shortened */
    for (int i = playlist.size() - 1; i >= status->playlistLength; i--) {
        mpd_freeSong(playlist[i]);
        playlist.removeAt(i);
//        emit changedSong(NULL);
    }
    if (status->state!=2 && status->state!=3){
        mpd_sendPlayCommand2(conn);
        mpd_finishCommand(conn);
        mpd_sendPauseCommand(conn,1);
        mpd_finishCommand(conn);
        mpd_sendSeekCurCommand(conn,0);
    }
    emit changedPlaylist(&playlist);

}

const mpd_Song* MpdClient::currentSong() const
{
    if (!status) return NULL_SONG;
    if (status->song >= playlist.size())
        return NULL_SONG;
    else
        return playlist[status->song];
}
