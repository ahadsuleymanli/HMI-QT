#include "tracklist.h"
#include <QDir>
#include <QMediaMetaData>
#include <QBuffer>
#include <qdiriterator.h>
#include <QThread>

QHash<int, QByteArray> createRoles() {
    QHash<int, QByteArray> r;
    r.insert(TrackListModel::TrackRole, "track");
    r.insert(TrackListModel::ArtistsRole, "artists");
    r.insert(TrackListModel::AlbumRole, "album");
    r.insert(TrackListModel::IsLoadedRole, "loaded");
    r.insert(TrackListModel::IsValidRole, "valid");
    r.insert(TrackListModel::NameRole, "name");
    r.insert(TrackListModel::ArtistNamesRole, "artistNames");
    r.insert(TrackListModel::AlbumNameRole, "albumName");
    r.insert(TrackListModel::DurationRole, "duration");
    r.insert(TrackListModel::PopularityRole, "popularity");
    r.insert(TrackListModel::DiscRole, "disc");
    r.insert(TrackListModel::CollectionIndexRole, "collectionIndex");
    r.insert(TrackListModel::AlbumIndexRole, "albumIndex");
    r.insert(TrackListModel::IsStarred, "starred");
    r.insert(TrackListModel::IsPlaceholder, "placeholder");
    r.insert(TrackListModel::IsLocal, "local");
    r.insert(TrackListModel::IsAutoLinked, "autolinked");
    r.insert(TrackListModel::Availability, "availability");
    r.insert(TrackListModel::ImageRole, "image");
    r.insert(TrackListModel::PathRole, "path");
    return r;
}

QVector<int> createTrackRoleVector() {
    QVector<int> v;
    v.append(TrackListModel::TrackRole);
    v.append(TrackListModel::IsLoadedRole);
    v.append(TrackListModel::IsValidRole);
    v.append(TrackListModel::NameRole);
    v.append(TrackListModel::DurationRole);
    v.append(TrackListModel::PopularityRole);
    return v;
}
QVector<int> createAlbumRoleVector() {
    QVector<int> v;
    v.append(TrackListModel::AlbumRole);
    v.append(TrackListModel::AlbumNameRole);
    return v;
}

QVector<int> createArtistRoleVector() {
    QVector<int> v;
    v.append(TrackListModel::ArtistsRole);
    v.append(TrackListModel::ArtistNamesRole);
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
QVariant TrackListModel::data(const QModelIndex &index, int role) const
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

int TrackListModel::rowCount(const QModelIndex &parent) const
{
    if (m_mediaList)
        return parent.isValid() ? 0 : m_mediaList->mediaCount();
    else{
        return parent.isValid() ? 0 : _mediaCount;
    }
}

QHash<int, QByteArray> TrackListModel::roleNames() const
{
    return g_roleNames;
}


TrackList::TrackList(QMediaPlayer *m_player, QObject *parent)
    :QObject(parent)
{
    qDebug()<<"creating tracklist";
    usbmounter = new UsbMounter(this);
    m_mediaPlayer = new QMediaPlayer(this);
    m_mediaPlayer->setVolume(0);
    m_mediaPlayer->setMuted(true);
    parentMediaplayer = m_player;
    parentMediaplayer->setPlaylist(nullptr);
    m_mediaList = new QMediaPlaylist(this);
    this->trackListModel = new TrackListModel(m_mediaList,this);
    qDebug()<<"tracklistmodel when created "<< trackListModel;
}

void TrackList::connectUsbMounter(){
    connect(usbmounter,&UsbMounter::usbMounted,this,&TrackList::createTracklist);
    connect(usbmounter,&UsbMounter::usbUnMounted,this,&TrackList::emptyTracklist);
    emit usbmounter->readyToCheck(false);
}

void TrackList::emptyTracklist(){
    qDebug()<<"clearing media_list";
    m_mediaList->clear();
    parentMediaplayer->setPlaylist(nullptr);
    trackListModel->clearTrackContents();
    emit trackListUpdated(trackListModel);
    emit trackListModel->layoutChanged();
    emit listCleared();
}

void TrackList::createTracklist(QStringList newlyAddedList){
    QStringList filters;
    filters << "*.flac" << "*.mp3" << "*.wav" ;
    qDebug()<<"adding tracks from "<< newlyAddedList.join(", ");
    qDebug()<<"tracklist called from: "<<QThread::currentThreadId();
    emit loadingList();
    tic = QTime::currentTime();
    for (QString path : newlyAddedList) {
        QDirIterator it(path, filters, QDir::Files, QDirIterator::Subdirectories);
        QString tempPath;
        while (it.hasNext())
        {
            tempPath = "file:" + it.next();
            m_mediaList->addMedia(QUrl( tempPath));
            TrackContent tc;
            tc.path = tempPath;
            trackListModel->pushBackToTrackContents(&tc);
        }
    }
    qDebug()<<"media loaded in "<<tic.msecsTo(QTime::currentTime())<<"ms";
    tic = QTime::currentTime();

    m_mediaPlayer->setPlaylist(m_mediaList);
    m_mediaList->setCurrentIndex(0);
    connect(m_mediaPlayer, &QMediaPlayer::mediaStatusChanged, [=](){

        if(m_mediaPlayer->mediaStatus() == QMediaPlayer::LoadingMedia) return;
//        if(!m_mediaPlayer->metaData(QMediaMetaData::Title).isValid()) {return};
        TrackContent* p_tc = trackListModel->getTrackContents()->begin() + m_mediaList->currentIndex();
        p_tc->index = m_mediaList->currentIndex();
        auto temp = m_mediaPlayer->metaData(QMediaMetaData::Title);
        if (temp.isValid())
            p_tc->trackName = temp;
        temp = m_mediaPlayer->metaData(QMediaMetaData::Title);
        if (temp.isValid())
            p_tc->artistName = m_mediaPlayer->metaData(QMediaMetaData::ContributingArtist);
        QImage image = m_mediaPlayer->metaData(QMediaMetaData::CoverArtImage).value<QImage>();
        QByteArray bArray;
        QBuffer buffer(&bArray);
        buffer.open(QIODevice::WriteOnly);
        image.save(&buffer, "JPEG");
        p_tc->image = "data:image/jpg;base64,";
        p_tc->image.append(QString::fromLatin1(bArray.toBase64().data()));

        if(m_mediaList->currentIndex() < m_mediaList->mediaCount() - 1)
            m_mediaList->setCurrentIndex(m_mediaList->currentIndex() + 1);
        else{
            m_mediaPlayer->setPlaylist(nullptr);
            parentMediaplayer->setPlaylist(m_mediaList);
            qDebug()<<"tracks added.";
            qDebug()<<"metadata loaded in "<<tic.msecsTo(QTime::currentTime())<<"ms";
            qDebug()<<"tracklist, metadata, thread: "<<QThread::currentThreadId();
            emit listReady();
            qDebug()<<"tracklistmodel when ready "<< trackListModel;
            emit trackListUpdated(trackListModel);
//            emit trackListModel->layoutChanged();
        }
    });

//    connect(this, &TrackList::listReady, [=](){m_mediaPlayer->deleteLater();});
}


