#include "updatecheck.h"
#include <QFileInfo>
#include <QDir>
#include <settingsmanager.h>
#include <restarter.h>

bool UpdateCheck::checkExecutable()
{
    m_programPath = QString("%1/AutoUpdater2").arg(QDir::currentPath());
    return QFileInfo::exists(m_programPath);
}

bool UpdateCheck::checkUnzipped()
{
    QString version = smng.version();
    QString lastversion = smng.lastversion();
    QStringList templast = lastversion.split(".");
    int major = templast[0].toInt();
    int minor = templast[1].toInt();
    unzippedPath = QString("%1/update_%2_%3/update.sh").arg(QDir::currentPath()).arg(major).arg(minor);
    if(smng.version()!=smng.lastversion()){
        return QFileInfo::exists(unzippedPath);
    }else{
        return false;
    }
}

//bool UpdateCheck::createProcess()
//{
//    m_rpro = new QProcess(this);
//    m_rpro = nullptr;
//    return true;
//}

UpdateCheck::UpdateCheck(QObject *parent) : QObject(parent)
{
    QObject::connect(&overlaytimer,&QTimer::timeout,this,&UpdateCheck::overlayFunction);
    m_rpro = new QProcess(this);
    run();
}

void UpdateCheck::run()
{
    if(!checkExecutable()){
        return;
    }
    if(m_rpro->state() == QProcess::NotRunning)
    {
//        createProcess();
        QString version = smng.version();
        QString lastversion = smng.lastversion();
        // Ahadin notlari: text dosyasinin icinde yeni lastversion verisini tutmak iyi fikir degil.
        // ardindan su an download yarida biterse lastversion yeni versiona update olmus oluyor,
        // ve bundan sonra sistem yeni bir update asla yapmaz
        if(version==lastversion)
        {
            qDebug()<<"starting AutoUpdater";
            m_rpro->startDetached(m_programPath);
        }else
        {
            overlaytimer.setInterval(7000);
            overlaytimer.setSingleShot(true);
            overlaytimer.start();
        }
    }
}

QString UpdateCheck::dirPath()
{
    QString lastversion = smng.lastversion();
    QStringList templast = lastversion.split(".");
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
    QString lastversion = smng.lastversion();
    QStringList templast = lastversion.split(".");
    int major = templast[0].toInt();
    int minor = templast[1].toInt();
    QStringList tempver = version.split(".");
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
        smng.setVersion(major,minor);
        rstrtr.makeRestart();
    }
}
void UpdateCheck::checkUpdate()
{
    run();
}

void UpdateCheck::overlayFunction()
{
    emit doUpdateOverlay();
}
