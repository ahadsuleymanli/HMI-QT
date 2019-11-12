#include "tracklist.h"
#include <QDir>
#include <QMediaMetaData>
#include <QBuffer>
#include <qdiriterator.h>

QHash<int, QByteArray> createRoles() {
    QHash<int, QByteArray> r;
    r.insert(TrackList::TrackRole, "track");
    r.insert(TrackList::ArtistsRole, "artists");
    r.insert(TrackList::AlbumRole, "album");
    r.insert(TrackList::IsLoadedRole, "loaded");
    r.insert(TrackList::IsValidRole, "valid");
    r.insert(TrackList::NameRole, "name");
    r.insert(TrackList::ArtistNamesRole, "artistNames");
    r.insert(TrackList::AlbumNameRole, "albumName");
    r.insert(TrackList::DurationRole, "duration");
    r.insert(TrackList::PopularityRole, "popularity");
    r.insert(TrackList::DiscRole, "disc");
    r.insert(TrackList::CollectionIndexRole, "collectionIndex");
    r.insert(TrackList::AlbumIndexRole, "albumIndex");
    r.insert(TrackList::IsStarred, "starred");
    r.insert(TrackList::IsPlaceholder, "placeholder");
    r.insert(TrackList::IsLocal, "local");
    r.insert(TrackList::IsAutoLinked, "autolinked");
    r.insert(TrackList::Availability, "availability");
    r.insert(TrackList::ImageRole, "image");
    r.insert(TrackList::PathRole, "path");
    return r;
}

QVector<int> createTrackRoleVector() {
    QVector<int> v;
    v.append(TrackList::TrackRole);
    v.append(TrackList::IsLoadedRole);
    v.append(TrackList::IsValidRole);
    v.append(TrackList::NameRole);
    v.append(TrackList::DurationRole);
    v.append(TrackList::PopularityRole);
    return v;
}
QVector<int> createAlbumRoleVector() {
    QVector<int> v;
    v.append(TrackList::AlbumRole);
    v.append(TrackList::AlbumNameRole);
    return v;
}

QVector<int> createArtistRoleVector() {
    QVector<int> v;
    v.append(TrackList::ArtistsRole);
    v.append(TrackList::ArtistNamesRole);
    return v;
}

const QHash<int, QByteArray>    g_roleNames = createRoles();
const QVector<int>              g_trackRoles = createTrackRoleVector();
const QVector<int>              g_albumRoles = createAlbumRoleVector();
const QVector<int>              g_artistRoles = createArtistRoleVector();

void rowSort(QVector<QPersistentModelIndex> & indices)
{
    std::sort(indices.begin(), indices.end(), [] (const QPersistentModelIndex & A, const QPersistentModelIndex & B)
    {
        return A.row() < B.row();
    });
}

TrackList::TrackList(QMediaPlaylist *list, QObject *parent)
    :QAbstractListModel(parent)
{
    usbmounter = new UsbMounter(this);
    m_mediaPlayer = new QMediaPlayer();
//    m_mediaPlayer->setVolume(0);
//    m_mediaPlayer->setMuted(true);
//    QDir mediaDir("/media/usb");
//    QStringList dirs = mediaDir.entryList(QDir::Dirs | QDir::NoDotAndDotDot);

    if(list)
        m_mediaList = list;
    else
        m_mediaList = new QMediaPlaylist();
    connect(usbmounter,&UsbMounter::usbMounted,this,&TrackList::createTracklist);
    connect(usbmounter,&UsbMounter::usbUnMounted,this,&TrackList::emptyTracklist);
}

void TrackList::emptyTracklist(){
    qDebug()<<"clearing media_list";
    m_mediaList->clear();
    m_trackContents.clear();
}

void TrackList::createTracklist(QStringList newlyAddedList){
    QStringList filters;
    filters << "*.flac" << "*.mp3" << "*.wav" ;
    for (QString path : newlyAddedList) {
        QDirIterator it(path, filters, QDir::Files, QDirIterator::Subdirectories);
        qDebug()<<"adding tracks from "<< path;
        QString tempPath;
        while (it.hasNext())
        {
            tempPath = "file:" + it.next();
            m_mediaList->addMedia(QUrl( tempPath));
            TrackContent tc;
            tc.path = tempPath;
            m_trackContents.push_back(tc);
        }
    }

//    if not
    m_mediaPlayer->setPlaylist(m_mediaList);
    m_mediaList->setCurrentIndex(0);
    connect(m_mediaPlayer, &QMediaPlayer::mediaStatusChanged, [=](){

        if(m_mediaPlayer->mediaStatus() == QMediaPlayer::LoadingMedia) return;
        if(!m_mediaPlayer->metaData(QMediaMetaData::Title).isValid()) return;
        auto tc = m_trackContents.begin() + m_mediaList->currentIndex();
        tc->index = m_mediaList->currentIndex();

        tc->trackName = m_mediaPlayer->metaData(QMediaMetaData::Title);
        tc->artistName = m_mediaPlayer->metaData(QMediaMetaData::ContributingArtist);
        QImage image = m_mediaPlayer->metaData(QMediaMetaData::CoverArtImage).value<QImage>();
        QByteArray bArray;
        QBuffer buffer(&bArray);
        buffer.open(QIODevice::WriteOnly);
        image.save(&buffer, "JPEG");
        tc->image = "data:image/jpg;base64,";
        tc->image.append(QString::fromLatin1(bArray.toBase64().data()));

        if(m_mediaList->currentIndex() < m_mediaList->mediaCount() - 1)
            m_mediaList->setCurrentIndex(m_mediaList->currentIndex() + 1);
        else{
            m_mediaPlayer->setPlaylist(nullptr);
            emit listReady();
            emit layoutChanged();
        }
    });

//    connect(this, &TrackList::listReady, [=](){m_mediaPlayer->deleteLater();});
}

QVariant TrackList::data(const QModelIndex &index, int role) const
{
    int row = index.row();

    Role r = (Role) role;

    if(row >=  m_trackContents.size()) return QVariant();

//    qDebug() << row <<m_trackContents.size()<< m_trackContents[row].trackName;
    TrackContent tc = m_trackContents[row];
    switch (r) {
    case TrackRole:
        return m_trackContents[row].trackName;
    case ArtistsRole:
        return tc.artistName;
    case ImageRole:
        return tc.image;
    case PathRole:
        return tc.path;
    default:
        break;

    }
    return QVariant();
}

int TrackList::rowCount(const QModelIndex &parent) const
{
    return parent.isValid() ? 0 : m_mediaList->mediaCount();
}

QHash<int, QByteArray> TrackList::roleNames() const
{

    return g_roleNames;
}
