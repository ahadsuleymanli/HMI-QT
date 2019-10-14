#include "updater.h"

#include <QDir>
#include <QFileInfo>
#include <QProcess>
#include <QSettings>
#include <QTimer>

Updater::Updater(QObject *parent) : QObject(parent)
{
    listingDoneTimer.setInterval(500);
    listingDoneTimer.stop();
    ftpOperationsGracePeriod.setInterval(5500);
    ftpOperationsGracePeriod.stop();
    QString setfileLocation = QString("%1/%2").arg(QDir::currentPath()).arg("settings.ini");
    assert(QFileInfo::exists(setfileLocation));
    QSettings setting_ini(setfileLocation,QSettings::IniFormat);
    update_server = setting_ini.value("update/update_server","").toString();
    password = setting_ini.value("update/password","").toString();
    username = setting_ini.value("update/username","").toString();
    QStringList version = (setting_ini.value("update/version","").toString()).split(".");
    major_version = version[0].toInt();
    minor_version = version[1].toInt();
    //when enough time passed since the last QFtp::list() do the download
    connect(&listingDoneTimer,&QTimer::timeout,this,&Updater::download);

    //if the listing event doesn't start for one second, means empty directory
    connect(&ftpOperationsGracePeriod,&QTimer::timeout,this,[this](){this->closeApp("while ftp operations: " + ftpCurrentState);});
    connect(&qftpController,&QFtp::dataTransferProgress,this,&Updater::downloadProgress);

    connect(&qftpController,&QFtp::commandFinished,[this](int id, bool err){
                if (current_action_name=="login" && !err) {
                    current_action_name = "";
                    this->loginDone();} });
    connect(&qftpController, SIGNAL(listInfo(QUrlInfo)), this, SLOT(doListing(QUrlInfo)));
    connect(&qftpController, &QFtp::done, [this](bool err){
        if (current_action_name == "downloading"){
           qDebug()<<"downloading done";
           this->downloadDone();
        }
         });

    connect(this, SIGNAL(signalClose(QString)), this, SLOT(closeApp(QString)));
    //shell process finished signal
    connect(&unzipProcess, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished),this,&Updater::unzipFinished);

    ftpCurrentState = "connect and login failed";
    ftpOperationsGracePeriod.stop();
    ftpOperationsGracePeriod.start();
    qftpController.connectToHost(update_server);
    current_action_name="login";
    qftpController.login(username,password);
}


void Updater::loginDone(){
    qDebug()<<"login"<<"done";
    ftpCurrentState = "list couldn't be acquired or the ftp directory is empty";
    ftpOperationsGracePeriod.stop();
    ftpOperationsGracePeriod.start();
    qftpController.list();

}
//TODO: server'da hiç update yoksa freeze
void Updater::doListing(const QUrlInfo& inf){
    ftpCurrentState = "listing timed out or no valid update file found";
    ftpOperationsGracePeriod.stop();
    ftpOperationsGracePeriod.start();
    QString setfileLocation = QString("%1/%2").arg(QDir::currentPath()).arg("settings.ini");
    assert(QFileInfo::exists(setfileLocation));
    QSettings setting_ini(setfileLocation,QSettings::IniFormat);
    QString filename = inf.name();
    QString listingString = "listing: " + filename;
    QStringList parts = filename.split("_");
    if (parts.length() == 3 && parts[0] == "update"){
        QStringList temp = parts[2].split(".");
        bool ok = true;
        if (temp.length() == 2 && temp[1] == "zip"){
            parts[2] = temp[0];
            int temp_major = parts[1].toInt(&ok);
            int temp_minor = parts[2].toInt(&ok);
            if (ok && temp_major >= major_version){
                if (temp_major > major_version || temp_minor > minor_version){
                    listingString += " - Potential Update: " + parts[1] + "." + parts[2];
                    major_version = temp_major;
                    minor_version = temp_minor;
                    downloadFileName = parts[0] + "_" + parts[1] + "_" + parts[2] + ".zip";
                    setting_ini.setValue("update/lastversion",parts[1]+"."+parts[2]);
                }else {
                }
            }else {
            }
        }else{
        }
    }else {
        listingString += " - Not an \"update\". file";
    }
    qDebug()<< listingString ;
    if ((not qftpController.hasPendingCommands()) && downloadFileName != ""){
        listingDoneTimer.stop();
        listingDoneTimer.start();
    }

}

void Updater::download(){
    ftpCurrentState = "downloading";
    ftpOperationsGracePeriod.stop();
    ftpOperationsGracePeriod.start();
    listingDoneTimer.stop();
    if (downloadFileName == ""){
        emit signalClose("no update found, exiting.");
        return;
    }
    current_action_name = "downloading";
    downloadFile.setFileName(QString("%1/%2").arg(QDir::currentPath()).arg(downloadFileName));
    if(!downloadFile.open(QIODevice::ReadWrite))
    {
      emit signalClose("write target" + downloadFileName + "file couldnt be opened");
      return;
    }
    qftpController.get(downloadFileName,&downloadFile);
}


void Updater::downloadProgress(qint64 p1, qint64 p2){
    ftpOperationsGracePeriod.stop();
    ftpOperationsGracePeriod.start();
    qDebug()<<"Progress : "<<p1<<" "<<p2;
}


// Uunzip:
void Updater::downloadDone(){
    ftpCurrentState = "ftp operations done. no ftp issues should arise at this point";
    downloadFile.close();
    ftpOperationsGracePeriod.stop();
    QString path;
    try{
        QStringList args;
        path = QString("%1/%2").arg(QDir::currentPath()).arg(downloadFileName);

        if(QFileInfo::exists(path))
        {
            deleteFile((downloadFileName.split('.'))[0]);                           //deleting any existing previous download
            qDebug()<<"unzipping"<<path;
            args<<"unzip"<<path<<"-d"<<QDir::currentPath();
            unzipProcess.start("sudo",args);
            qDebug()<<"unzipping"<< downloadFileName;


            bool waitResult = unzipProcess.waitForFinished(15000);
            if (!waitResult){
                qDebug()<<"unzipping could not complete, killing the process.";
                unzipProcess.kill();
            }
            else {
                qDebug()<<"unzipping successful.";
            }
            return;
        }else{
            closeApp("wrong file path");
            return;
        }
    }catch(...)
    {
        closeApp("exception in this command block");
        return;
    }

}

void Updater::deleteFile(QString filename){
    QString path = QString("%1/%2").arg(QDir::currentPath()).arg(filename);
    if(QFileInfo::exists(path)){
        QProcess deleteProcess;
        QStringList args;
        qDebug()<<filename<<"named file already exists, being deleted before update..";
        args<<"rm"<<"-rf"<<path;
        deleteProcess.start("sudo",args);
        bool waitResult = deleteProcess.waitForFinished(5000);
        if (!waitResult){
            deleteProcess.kill();
            closeApp("deletion process failed. exiting.");
            return;
        }
        else {
            qDebug()<<"deleted successfully.";
        }
    }


}

void Updater::unzipFinished(){
    closeApp("--- after the unzipping process ---");
}

void Updater::closeApp(QString closeReason){
    qDebug()<<closeReason;
    qDebug()<<"closing up";
    qftpController.close();
    qDebug()<<"closing up is done. quitting...";
    qApp->quit();
}

