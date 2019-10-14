#ifndef SERVICEMANAGER_H
#define SERVICEMANAGER_H

#include <QObject>

class ServiceManager : public QObject
{
    Q_OBJECT
public:
    explicit ServiceManager(QObject *parent = nullptr);
    bool startService();
    bool stopService();
    bool restartService();
    bool moveFiles();
    void simulate();

signals:

public slots:
};

#endif // SERVICEMANAGER_H
