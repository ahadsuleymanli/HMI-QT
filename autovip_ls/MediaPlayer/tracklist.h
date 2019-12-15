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
    QVariant trackName="";
    QVariant artistName="";
    QString image;
    TrackContent(){}
    TrackContent(int index, QVariant path,QVariant trackName,QVariant artistName,QString image){
        this->index=index; this->path=path; this->trackName=trackName; this->artistName=artistName; this->image=image;
    }
    TrackContent(TrackContent *tc){
        this->index=tc->index; this->path=tc->path; this->trackName=tc->trackName; this->artistName=tc->artistName; this->image=tc->image;
    }
};
class TrackListModel : public QAbstractListModel{
    Q_OBJECT

    Q_INVOKABLE QVariant count() {
        if (m_mediaList)
            return m_mediaList->mediaCount();
        else
            return _mediaCount;
    }
    Q_INVOKABLE QVariant titleAt(int index) { return m_trackContents[index].trackName; }
    Q_INVOKABLE QVariant artistAt(int index) { return m_trackContents[index].artistName; }
    Q_INVOKABLE QString imageAt(int index) { return m_trackContents[index].image; }
    Q_INVOKABLE QVariant pathAt(int index) { return m_trackContents[index].path; }

    QVector<TrackContent> m_trackContents;
    QMediaPlaylist *m_mediaList = nullptr;
    int _mediaCount=0;
    QVariant data(const QModelIndex &index, int role) const;
    int rowCount(const QModelIndex &parent) const;
    QHash<int, QByteArray> roleNames() const;
public:
    enum Role {
        TrackRole = Qt::UserRole,ArtistsRole,AlbumRole,IsLoadedRole,IsValidRole,NameRole,ArtistNamesRole,AlbumNameRole,DurationRole,PopularityRole,
        DiscRole,AlbumIndexRole,IsStarred,IsPlaceholder,IsLocal,IsAutoLinked,Availability,CollectionIndexRole,ImageRole,PathRole,LastTrackCollectionModelRole
    };
    TrackListModel(QObject *parent = Q_NULLPTR):QAbstractListModel(parent){}
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
        _mediaCount++;
    }
    void clear(){
        m_trackContents.clear();
        _mediaCount=0;
    }
    void copyObject(TrackListModel *x){
        this->_mediaCount=x->m_mediaList->mediaCount();
        this->m_trackContents.clear();
        try {
            QVectorIterator<TrackContent> tcIterator(x->m_trackContents);
            while (tcIterator.hasNext()) {
                this->m_trackContents.push_back(TrackContent(tcIterator.next()));
            }
        } catch (...) {qDebug()<<"exception in TrackListModel copyObject";}

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
    void connections();

signals:
    void loadingList();
    void listCleared();
    void listReady();
    void trackListUpdated(TrackListModel *TrackListModel);

private slots:
    void createTracklist(QStringList newlyAddedList);
    void emptyTracklist();

};

#endif // TRACKLIST_H
