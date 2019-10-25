#include "updatecheck.h"
#include <QFileInfo>
#include <QDir>
#include <settingsmanager.h>
#include <restarter.h>
#include <iostream>

UpdateCheck::UpdateCheck(QObject *parent) : QObject(parent)
{
    QObject::connect(&overlaytimer,&QTimer::timeout,this,&UpdateCheck::overlayFunction);
    m_rpro = new QProcess(this);
    connect(m_rpro, &QProcess::readyRead, this, &UpdateCheck::handleReadyRead);
    connect(m_rpro, &QProcess::started, this, &UpdateCheck::sendArguments);
    setCurrentVersion(smng.version());
}

void UpdateCheck::setCurrentVersion(QString version)
{
    if(m_currentVersion == version) return;
    m_currentVersion = version;
    emit currentVersionChanged(m_currentVersion);
}

void UpdateCheck::setUpdateVersion(QString version)
{
    if(m_updateVersion == version) return;
    m_updateVersion = version;
    emit updateVersionChanged(m_updateVersion);
}

bool UpdateCheck::checkExecutable()
{
    m_programPath = QString("%1/AutoUpdater2").arg(QDir::currentPath());
    return QFileInfo::exists(m_programPath);
}

bool UpdateCheck::checkUnzipped()
{
    QString lastversion = m_updateVersion;
    QStringList templast = lastversion.split(".");
    int major = templast[0].toInt();
    int minor = templast[1].toInt();
    unzippedPath = QString("%1/update_%2_%3/update.sh").arg(QDir::currentPath()).arg(major).arg(minor);

    return QFileInfo::exists(unzippedPath);
}

void UpdateCheck::run()
{
    if(!checkExecutable() || m_rpro->state() != QProcess::NotRunning){
        return;
    }
    m_rpro->start(m_programPath);
//    QString version = smng.version();
//    QString lastversion = smng.lastversion();
    // Ahadin notlari: text dosyasinin icinde yeni lastversion verisini tutmak iyi fikir degil.
    // ardindan su an download yarida biterse lastversion yeni versiona update olmus oluyor,
    // ve bundan sonra sistem yeni bir update asla yapmaz
//    if(version==lastversion)
//    {
//        qDebug()<<"starting AutoUpdater";
//        m_rpro->startDetached(m_programPath);
//    }else
//    {
//        overlaytimer.setInterval(7000);
//        overlaytimer.setSingleShot(true);
//        overlaytimer.start();
//    }
}

void UpdateCheck::handleReadyRead()
{
    QStringList lines = QString(m_rpro->readAll()).split('\n');
    for(auto &str: lines){
        std::cout <<"update check  "<< str.toStdString() << std::endl;
        if(str.startsWith("info")){
            QStringList parts = str.split('/');
            if(parts.size() != 2) return;
            if(parts[1] == "noupdatefound")
                emit updateStateChanged(uptodate);
            else
                emit updateStateChanged(failed);
        }
        else if(str.startsWith("success")){
            QStringList parts = str.split('/');
            if(parts.size() == 2)
            {
                QString major = parts[1].mid(7,parts[1].indexOf("_", 7) - 7);
                QString minor = parts[1].mid(parts[1].indexOf("_",7) + 1, parts[1].indexOf(".zip") -
                                        parts[1].indexOf("_",7) - 1);
                setUpdateVersion(major +"." + minor);
                emit updateStateChanged(updateReady);
            }
        }
    }
}

void UpdateCheck::sendArguments()
{

}

QString UpdateCheck::dirPath()
{
    QString lastdownloadedversion = m_updateVersion;
    QStringList templast = lastdownloadedversion.split(".");
    int major = templast[0].toInt();
    int minor = templast[1].toInt();
    return QString("%1/update_%2_%3").arg(QDir::currentPath()).arg(major).arg(minor);
}

QString UpdateCheck::changeLog()
{
    QString filename="/changelog";
    QFile file(dirPath()+filename);
    if(!file.exists()){
        return "Changelog file does not exist.";
    }
    QString whole;
    QString line;
    if (file.open(QIODevice::ReadOnly | QIODevice::Text)){
        QTextStream stream(&file);
        while (!stream.atEnd()){
            line = stream.readLine();
            whole = whole + line + "\n";
        }
    }
    file.close();
    return whole;
}

void UpdateCheck::makeUpdate()
{
    QString version = smng.version();
    QString lastversion = m_updateVersion;
    QStringList templast = lastversion.split(".");
    int major = templast[0].toInt();
    int minor = templast[1].toInt();
    QStringList tempver = lastversion.split(".");
    int majorver = tempver[0].toInt();
    int minorver = tempver[1].toInt();
    QString foldername = QString("update_%1_%2").arg(major).arg(minor);
    QString filepath = ("sudo ./"+foldername+"/update.sh");
    if(checkUnzipped()){
        QDir olddir(QString("%1/update_%1_%2").arg(QDir::currentPath()).arg(majorver).arg(minorver));
        olddir.removeRecursively();
        smng.setVersion(major,minor);
        m_rpro->startDetached(filepath);
    }else{
//        smng.setVersion(major,minor);
        rstrtr.makeRestart();
    }
}
void UpdateCheck::checkUpdate()
{
    m_state = checking;
    run();
}

void UpdateCheck::overlayFunction()
{
    emit doUpdateOverlay();
}
