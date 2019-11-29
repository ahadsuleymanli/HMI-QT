#ifndef TRACKLIST_H
#define TRACKLIST_H

#include <QMediaPlayer>
#include <QMediaPlaylist>
#include <QAbstractListModel>
#include <QImage>
#include "usbmounter.h"


struct TrackContent{
    int index;
    QVariant path;
    QVariant trackName;
    QVariant artistName;
    QString image;
};

class TrackList : public QAbstractListModel
{
    Q_OBJECT
    UsbMounter *usbmounter;
public:
    enum Role {
        TrackRole = Qt::UserRole,
        ArtistsRole,
        AlbumRole,
        IsLoadedRole,
        IsValidRole,
        NameRole,
        ArtistNamesRole,
        AlbumNameRole,
        DurationRole,
        PopularityRole,
        DiscRole,
        AlbumIndexRole,
        IsStarred,
        IsPlaceholder,
        IsLocal,
        IsAutoLinked,
        Availability,
        CollectionIndexRole,
        ImageRole,
        PathRole,

        // Used in subclasses
        LastTrackCollectionModelRole
    };
    explicit TrackList(QMediaPlaylist *list = nullptr, QObject *parent = Q_NULLPTR);

    QVariant data(const QModelIndex &index, int role) const;
    int rowCount(const QModelIndex &parent) const;
    QHash<int, QByteArray> roleNames() const;


    Q_INVOKABLE QVariant count() { return m_mediaList->mediaCount(); }

    Q_INVOKABLE QVariant titleAt(int index) { return m_trackContents[index].trackName; }
    Q_INVOKABLE QVariant artistAt(int index) { return m_trackContents[index].artistName; }
    Q_INVOKABLE QString imageAt(int index) { return m_trackContents[index].image; }
    Q_INVOKABLE QVariant pathAt(int index) { return m_trackContents[index].path; }
    Q_INVOKABLE void playTrack(int index) { m_mediaList->setCurrentIndex(index); parentMediaplayer->play(); }

    void connectUsbMounter();

signals:
    void listReady();

private slots:
    void createTracklist(QStringList newlyAddedList);
    void emptyTracklist();
private:
    QMediaPlaylist *m_mediaList;
    QMediaPlayer *m_mediaPlayer;
    QMediaPlayer *parentMediaplayer;
    QVector<TrackContent> m_trackContents;

};

#endif // TRACKLIST_H
