#ifndef MPDCLIENT_H
#define MPDCLIENT_H

#include <QObject>
#include <QList>
#include <QMediaObject>
#include "libmpdclient-0.13.0/libmpdclient.h"
#include "usbmounter.h"
#include <iostream>
#include <QDebug>
typedef QList<mpd_Song*> mpd_Song_List;

class MpdClient : public QObject
{
    Q_OBJECT
public:
    explicit MpdClient(QObject *parent = nullptr);
    bool start();
    const mpd_Song* currentSong() const;
    QList<mpd_Song*> getPlaylist(){return playlist;}
    void getMediaMetadata(){

    }
public slots:
    void playIndex(int idx);
    void playPause();
    void next();
    void prev();
    void seekCurrent(int time);
    void toggleRandom(){
        if (status->random)
            mpd_sendRandomCommand(conn,0);
        else
            mpd_sendRandomCommand(conn,1);
        update();
    }
    void toggleRepeat(){
        if (status->repeat)
            mpd_sendRepeatCommand(conn,0);
        else
            mpd_sendRepeatCommand(conn,1);
        update();
    }
    void update();
    void addFilesToPlaylist(){
        qDebug()<<"add to playlist";
        mpd_sendUpdateCommand(conn,"");
        mpd_finishCommand(conn);
        mpd_sendClearCommand(conn);
        mpd_finishCommand(conn);
        QTimer::singleShot(150,this,[=]{
            mpd_sendAddCommand(conn,"/");
            mpd_finishCommand(conn);
            update(); });

    }
    void deletePlaylist(){
        qDebug()<<"delete playlist";
        mpd_sendStopCommand(conn);
        mpd_finishCommand(conn);
        mpd_sendUpdateCommand(conn,"");
        mpd_finishCommand(conn);
        mpd_sendClearCommand(conn);
        mpd_finishCommand(conn);
    }
signals:
    void playingSong(const mpd_Song *new_song, const mpd_Status *status);
    void changedSong(const mpd_Song *new_song);
    void changedPlaylist(const QList<mpd_Song*> *playlist);

private:
    void updatePlaylist(long long version);

    mpd_Connection *conn;
    mpd_Status *status;
    QTimer *updateTimer;
    QList<mpd_Song*> playlist;
    UsbMounter *usbMounter;
};

//extern MpdClient *mpdclient;

#endif // MPDCLIENT_H
