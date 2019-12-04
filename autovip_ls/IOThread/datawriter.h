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
    QTimer * ioTimer;
    QSettings * datafile = nullptr;
    QString lastPowerofftime;
    QString datafilePath;
    void deleteLockFile(QString path){
        QProcess *removeProcess = new QProcess();
        connect(removeProcess, SIGNAL(finished(int,QProcess::ExitStatus)), removeProcess, SLOT(deleteLater()));
        removeProcess->start("sudo rm "+path+".lock");
        removeProcess->waitForFinished(1000);
    }
//    void costlyDummyProcess() {
//        qDebug() << "Costly process started";
//        double b = 1;
//        for (int i = 0 ; i < 1000000000 ; i++){
//            b = b * (1000000.34332324 * 99999.05323235);
//            b = exp(b);
//            }
//        qDebug() << "Costly process finished";
//    }
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
            ioTimer->start();}
        void process(){
            deleteLockFile(datafilePath);
            this->datafile = new QSettings(datafilePath,QSettings::IniFormat);
            ioTimer = new QTimer();
            ioTimer->setInterval(30000);
            ioTimer->stop();
//            qDebug()<<"thread stuff called from: "<<QThread::currentThreadId();
            connect(ioTimer,&QTimer::timeout,this,[=](){
                datafile->setValue("timedate/powerofftime",QDateTime::currentDateTimeUtc().toString());
            });
        }

};

#endif // DATAWRITER_H
