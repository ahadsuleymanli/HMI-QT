#ifndef TRACKLOADER_H
#define TRACKLOADER_H
#include <QObject>

class TrackLoader: public QObject
{
    Q_OBJECT
public:
    TrackLoader();
    void loadTracks();
signals:
    void trackLoaded();
};

#endif // TRACKLOADER_H
