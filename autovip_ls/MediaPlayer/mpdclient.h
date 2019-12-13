#ifndef MPDCLIENT_H
#define MPDCLIENT_H

#include <QObject>

class MpdClient : public QObject
{
    Q_OBJECT
public:
    explicit MpdClient(QObject *parent = nullptr);

signals:

public slots:
};

#endif // MPDCLIENT_H
