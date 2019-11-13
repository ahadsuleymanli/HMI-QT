#ifndef MYCLASS_H
#define MYCLASS_H

#include <QObject>
#include <QtDebug>
#include <QDir>
#include <QFileSystemWatcher>
#include <QProcess>
#include <QTimer>
class UsbMounter: public QObject
{
     Q_OBJECT
    QFileSystemWatcher devWatcher;
    QProcess* chkproc = new QProcess();
    QProcess* mountProcess = new QProcess();
    QTimer devChangeTimer;
    QStringList mountedPaths = {};
    QString prev_blkid = "";
    bool canListen = false;
public:
    UsbMounter(QObject* parent=0);
    ~UsbMounter(){
        mountProcess->deleteLater();
        chkproc->deleteLater();}

public slots:
    void reactToDevChange(const QString& str);
    void checkForUsbDevices(bool directory_change = true);

signals:
    void usbMounted(QStringList newlyAddedList);
    void usbUnMounted();
    void readyToCheck(bool directory_change);
};

#endif // MYCLASS_H
