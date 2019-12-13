#include "mpdclient.h"

#include <stdlib.h> /* for getenv, atoi */
#include <assert.h>
#include <QTimer>
#include <QDebug>
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
    conn = NULL;
    status = NULL;
}

bool MpdClient::start()
{   qDebug()<<"starting mdpclient";
    char *host = getenv("MPD_HOST");
    char *port = getenv("MPD_PORT");

    if (host == NULL)
        host = "localhost";
    if (port == NULL)
        port = "6600";

    conn = mpd_newConnection(host, atoi(port), 10);

    if (conn->error) {
        error(conn->errorStr);

        return false;
    }

    update();

    QTimer *timer = new QTimer(this);
    connect(timer, SIGNAL(timeout()), this, SLOT(update()));
    timer->start(1000);

    return true;
}

void MpdClient::update()
{
    mpd_Status *old = status;

    mpd_sendStatusCommand(conn);

    status = mpd_getStatus(conn);
    assert(status);
    mpd_finishCommand(conn);

    if (!(old && old->playlist == status->playlist)) {
        if (old)
            updatePlaylist(old->playlist);
        else
            updatePlaylist(-1);

        if (currentSong())
            emit(playingSong(currentSong()));
    }
    else if (old->song == status->song && currentSong())
        emit(playingSong(currentSong()));

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

        assert(song->pos <= playlist.size());

        if (song->pos == playlist.size())
            playlist += song;
        else {
            mpd_freeSong(playlist[song->pos]);
            playlist[song->pos] = song;
        }

        emit(changedSong(song));
    }

    mpd_finishCommand(conn);

    /* remove extra songs if the playlist was shortened */
    for (int i = playlist.size() - 1; i >= status->playlistLength; i--) {
        mpd_freeSong(playlist[i]);
        playlist.removeAt(i);
        emit(changedSong(NULL));
    }

}

const mpd_Song* MpdClient::currentSong() const
{
    assert(status);
    if (status->song >= playlist.size())
        return NULL_SONG;
    else
        return playlist[status->song];
}
