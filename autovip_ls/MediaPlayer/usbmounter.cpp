#include "usbmounter.h"

UsbMounter::UsbMounter(QObject* parent){
    devWatcher.addPath("/dev");

    devChangeTimer.stop();
    devChangeTimer.setInterval(150);
    connect(&devWatcher, SIGNAL(directoryChanged(QString)), this,SLOT(reactToDevChange(QString)));
    connect(&devChangeTimer, &QTimer::timeout, this,[this](){checkForUsbDevices(true);});
    connect(this,SIGNAL(readyToCheck(bool)),this,SLOT(checkForUsbDevices(bool)));
    #if (defined(__arm__) || defined(__aarch64__))
        this->mountAllowed = true;
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

    if (!mountAllowed){
        qDebug("mounting devices not allowed on non-target platform. (you're running the program on a PC)");
    }
    else if (temp != prev_blkid){
        prev_blkid = temp;
        QStringList newlyAddedList = {};
        while (!textstream.atEnd())
           {
              QString line = textstream.readLine();
              if (line.contains("TYPE=\"", Qt::CaseInsensitive) && line.contains("dev/sd", Qt::CaseInsensitive)){
                  devPath = line.split(":")[0];
                  mountPath = "/media/usb/music" + QString::number(mountIdx);
                  if (!QDir(mountPath).exists())
                      QDir().mkdir(mountPath);
                  if (!mountedPaths.contains(mountPath)){
                      mountProcess->start("sudo umount " + devPath);
                      mountProcess->waitForFinished(1000);
                      qDebug()<<"mounting "<<devPath;
                      mountProcess->start("sudo mount " + devPath + " " + mountPath);
                      mountProcess->waitForFinished(1000);
                      if (mountProcess->exitStatus() == 0){
                          qDebug() << devPath << " mounted!";
                          newlyAddedList.append(mountPath);
                          mountedPaths.append(mountPath);
                      }
                  }

                  mountIdx ++;
              }

           }
        if (mountIdx)
            emit usbMounted(newlyAddedList);
        else {
            if (directory_change==true)
                emit usbUnMounted();
            mountedPaths.clear();
        }
    }


}
