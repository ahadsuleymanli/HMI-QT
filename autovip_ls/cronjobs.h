#ifndef CRONJOBS_H
#define CRONJOBS_H

#include <QObject>
#include <QProcess>
#include <QTimer>
#include <QDebug>
#include <QThread>
class CronJobs : public QObject
{
    Q_OBJECT
    QTimer * timer = nullptr;
    //int timeout = 300000;
    int timeout = 3000;
    QProcess *enable_dpms=nullptr;
    QProcess *disable_dpms=nullptr;
public:
    explicit CronJobs(QObject *parent = nullptr);

signals:

public slots:
    void run_jobs();
};


class CronJobsWorker : public QObject {
    Q_OBJECT
        QProcess *enable_dpms=nullptr;
        QProcess *disable_dpms=nullptr;
public:
    CronJobsWorker();
    ~CronJobsWorker();

public slots:
    void process();
    void costlyDummyProcess();

signals:
    void finished();
    void error(QString err);

private:
    // add your variables here
};

class CronJobsMgr : public QObject {
    Q_OBJECT
    QThread* thread1;
    CronJobsWorker* cronJobsWorker;
    QTimer * timer = nullptr;
    int timeout = 3000;
public: CronJobsMgr();
};

std::string exec(const char* cmd);

#endif // CRONJOBS_H
