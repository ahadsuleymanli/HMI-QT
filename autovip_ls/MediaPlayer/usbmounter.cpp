#include "usbmounter.h"

UsbMounter::UsbMounter(QObject* parent){
    devWatcher.addPath("/dev");

    devChangeTimer.stop();
    devChangeTimer.setInterval(150);
    connect(&devWatcher, SIGNAL(directoryChanged(QString)), this,SLOT(reactToDevChange(QString)));
    connect(&devChangeTimer, &QTimer::timeout, this,[this](){checkForUsbDevices(true);});
    connect(this,SIGNAL(readyToCheck(bool)),this,SLOT(checkForUsbDevices(bool)));
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

    if (temp != prev_blkid){
        prev_blkid = temp;
        QStringList newlyAddedList = {};
        while (!textstream.atEnd())
           {
              QString line = textstream.readLine();
              if (line.contains("TYPE=\"", Qt::CaseInsensitive) && line.contains("dev/sd", Qt::CaseInsensitive)
                      && !(line.contains("Microsoft reserved partition", Qt::CaseInsensitive)||
                           line.contains("PARTUUID=\"2c417d8b", Qt::CaseInsensitive)||line.contains("8cc16bbc", Qt::CaseInsensitive)||line.contains("f0a0e50c", Qt::CaseInsensitive))){
                  devPath = line.split(":")[0];
//                  UUID="646E-0B80" TYPE="vfat" PARTLABEL="Basic data partition" PARTUUID="9a833a30-269d-01d5-189d-41cd4e93ea00"

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
