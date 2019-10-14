#ifndef FTPHANDLER_H
#define FTPHANDLER_H
#include <QObject>
#include <QFtp/qftp.h>
#include <QCoreApplication>
#include <QtDebug>

class QFtpController : public QFtp
{
    Q_OBJECT

public:
    QFtpController(QObject* parent = nullptr)
    {
//          connect(this, SIGNAL(listInfo(QUrlInfo)), this, SLOT(doListInfo(QUrlInfo)));
//          connect(this, SIGNAL(done(bool)), QCoreApplication::instance(), SLOT(quit()));
//          QObject::connect(this,SIGNAL(commandStarted(int)),this,SLOT(commandStarted(int)));
//          QObject::connect(this,SIGNAL(commandFinished(int,bool)),this,SLOT(commandFinished(int,bool)));
//          QObject::connect(this,SIGNAL(dataTransferProgress(qint64,qint64)),this,SLOT(dataTransferProgress(qint64,qint64)));
//          QObject::connect(this,SIGNAL(rawCommandReply(int, const QString&)),this,SLOT(rawCommandReply(int,const QString&)));
//          QObject::connect(this,SIGNAL(stateChanged(int)),this,SLOT(stateChanged(int)));

    }

protected slots:
    void doListInfo(const QUrlInfo& info)
    {
        qDebug() << info.name();
    }
    void commandStarted(int id){
        qDebug() << "command started:" << id;
    }
    void commandFinished(int id, bool error){
        qDebug() << "command finished:" << id<< "Error exists:" << error;
    }
    void dataTransferProgress(qint64 p1, qint64 p2)
    {
        qDebug()<<"Progress : "<<p1<<" "<<p2;
//        if (p1 == 0){
//            qDebug()<<"Download started...";
//            qDebug()<<"Progress : "<<p1<<" "<<p2;
//        }
//        else if (p1>p2/2 and p1<(p2/2)+10000)
//            qDebug()<<"Progress : "<<p1<<" "<<p2;
//        else if (p1 >= p2){
//            qDebug()<<"Progress : "<<p1<<" "<<p2;
//            qDebug()<<"Download finished!";
//        }
    }
    void rawCommandReply(int p, const QString & result)
    {
       qDebug()<<"reply : "<<p<<" Result: "<<result<<endl;
    }
    void stateChanged(int p_st)
    {
       qDebug()<<"state : "<<p_st<<endl;
    }

};

#endif // FTPHANDLER_H
