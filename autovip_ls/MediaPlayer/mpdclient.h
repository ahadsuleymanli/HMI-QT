#ifndef MPDCLIENT_H
#define MPDCLIENT_H

#include <QObject>
#include <QList>
#include "libmpdclient-0.13.0/libmpdclient.h"
#include <iostream>


class MpdClient : public QObject
{
    Q_OBJECT
public:
    explicit MpdClient(QObject *parent = nullptr);
    bool start();
    const mpd_Song* currentSong() const;
public slots:
    void update();
signals:
    void playingSong(const mpd_Song *new_song);
    void changedSong(const mpd_Song *new_song);

private:
    void updatePlaylist(long long version);

    mpd_Connection *conn;
    mpd_Status *status;

    QList<mpd_Song*> playlist;
};

extern MpdClient *mpdclient;

#endif // MPDCLIENT_H
