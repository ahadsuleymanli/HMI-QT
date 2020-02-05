#include "usbmounter.h"

UsbMounter::UsbMounter(QObject* parent):QObject(parent){
    devWatcher.addPath("/dev");
    chkproc = new QProcess(this);
    mountProcess = new QProcess(this);
    devChangeTimer.stop();
    devChangeTimer.setInterval(150);
    connect(&devWatcher, SIGNAL(directoryChanged(QString)), this,SLOT(reactToDevChange(QString)));
    connect(&devChangeTimer, &QTimer::timeout, this,[this](){checkForUsbDevices(true);});
    connect(this,SIGNAL(readyToCheck(bool)),this,SLOT(checkForUsbDevices(bool)));
    qDebug()<<"usbmounter";
    #if (defined(__arm__) || defined(__aarch64__))
        this->mountAllAllowed = true;
    #endif
}

void UsbMounter::reactToDevChange(const QString& str)
{
    devChangeTimer.stop();
    devChangeTimer.start();
}

void UsbMounter::checkForUsbDevices(bool directory_change){
    devChangeTimer.stop();

    if (directory_change == true)
        qDebug("dev directory changed!");
    QString devPath;
    QString mountPath;
    int mountIdx = 0;
    if (!QDir("/media/usb").exists())
        QDir().mkdir("/media/usb");
    chkproc->start("blkid");
    chkproc->waitForFinished();
    QString temp = chkproc->readAllStandardOutput();
    QTextStream textstream(&temp);


}
