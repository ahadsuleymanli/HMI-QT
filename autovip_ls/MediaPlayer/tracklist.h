#ifndef TRACKLIST_H
#define TRACKLIST_H

#include <QMediaPlayer>
#include <QMediaPlaylist>
#include <QAbstractListModel>
#include <QImage>

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

public:
    enum AnimalRoles {
        TypeRole = Qt::UserRole + 1,
        SizeRole
    };
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


signals:
    void listReady();

private:
    QMediaPlaylist *m_mediaList;
    QMediaPlayer *m_mediaPlayer;
    QVector<TrackContent> m_trackContents;
};

#endif // TRACKLIST_H
