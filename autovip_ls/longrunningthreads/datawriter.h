#ifndef DATAWRITER_H
#define DATAWRITER_H

#include <QDir>
#include <QObject>
#include <QProcess>
#include <QSettings>
#include <QTime>
#include <QTimer>
#include <QDebug>
#include <QtMath>
#include <QThread>
class DataWriterWorker : public QObject
{
    Q_OBJECT
    QSettings * datafile = nullptr;
    QString lastPowerofftime;
    QString datafilePath;
    bool timeIsSet = false;
    void deleteLockFile(QString path){
        QProcess *removeProcess = new QProcess();
        connect(removeProcess, SIGNAL(finished(int,QProcess::ExitStatus)), removeProcess, SLOT(deleteLater()));
        removeProcess->start("sudo rm "+path+".lock");
        removeProcess->waitForFinished(1000);
    }
public:
    explicit DataWriterWorker(QObject *parent = nullptr){
        this->datafilePath = QString("%1/%2").arg(QDir::currentPath()).arg("data.ini");
        deleteLockFile(datafilePath);
        lastPowerofftime = QSettings(datafilePath,QSettings::IniFormat).value("timedate/powerofftime").toString();
    }
    QString getLastPowerOffTime(){
        return  lastPowerofftime;
    }

public slots:
    void startTimeLogging(){
        qDebug()<<"starting powerofftime logging";
        timeIsSet = true;
    }
    void connections(){
        deleteLockFile(datafilePath);
        this->datafile = new QSettings(datafilePath,QSettings::IniFormat,this);
        connect(this,&DataWriterWorker::heartBeat,this,&DataWriterWorker::writeCurrentTime);
    }
    void writeCurrentTime(){
        if (timeIsSet)
            datafile->setValue("timedate/powerofftime",QDateTime::currentDateTimeUtc().toString());
    }

signals:
    void heartBeat();

};

#endif // DATAWRITER_H
