#ifndef TRACKLIST_H
#define TRACKLIST_H

#include <QMediaPlayer>
#include <QMediaPlaylist>
#include <QAbstractListModel>
#include <QImage>
#include <QTime>
#include "usbmounter.h"


struct TrackContent{
    int index;
    QVariant path;
    QVariant trackName;
    QVariant artistName;
    QString image;
};
class TrackListModel : public QAbstractListModel{
    Q_OBJECT

    Q_INVOKABLE QVariant count() { return m_mediaList->mediaCount(); }
    Q_INVOKABLE QVariant titleAt(int index) { return m_trackContents[index].trackName; }
    Q_INVOKABLE QVariant artistAt(int index) { return m_trackContents[index].artistName; }
    Q_INVOKABLE QString imageAt(int index) { return m_trackContents[index].image; }
    Q_INVOKABLE QVariant pathAt(int index) { return m_trackContents[index].path; }

    QVector<TrackContent> m_trackContents;
    QMediaPlaylist *m_mediaList;
    QVariant data(const QModelIndex &index, int role) const;
    int rowCount(const QModelIndex &parent) const;
    QHash<int, QByteArray> roleNames() const;
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
//    explicit TrackListModel(QMediaPlaylist *m_mediaList, QObject *parent = Q_NULLPTR);
    TrackListModel(QMediaPlaylist *m_mediaList, QObject *parent):QAbstractListModel(parent){
        this->m_mediaList=m_mediaList;
    }
    void clearTrackContents(){
        m_trackContents.clear();
    }
    QVector<TrackContent>* getTrackContents(){
        return &m_trackContents;
    }
    void pushBackToTrackContents(TrackContent *tc){
        m_trackContents.push_back(*tc);
    }

};
class TrackList : public QObject
{
    Q_OBJECT
    UsbMounter *usbmounter;
    TrackListModel *trackListModel;
    QTime tic;
    QMediaPlayer *m_mediaPlayer;
    QMediaPlayer *parentMediaplayer;
    QMediaPlaylist *m_mediaList;
public:
    explicit TrackList(QMediaPlayer *m_player, QObject *parent = Q_NULLPTR);
    TrackListModel* getTrackListModel(){return trackListModel;}
    void connectUsbMounter();
signals:
    void listReady();

private slots:
    void createTracklist(QStringList newlyAddedList);
    void emptyTracklist();

};

#endif // TRACKLIST_H
