#include "cronjobs.h"
#include <QStringList>
#include <QDebug>

CronJobs::CronJobs(QObject *parent) : QObject(parent)
{
    this->enable_dpms = new QProcess();
    this->disable_dpms = new QProcess();
    this->timer = new QTimer();
    this->timer->setInterval(timeout);
    connect(timer,&QTimer::timeout,this,&CronJobs::run_jobs);
    this->timer->start();
}

void CronJobs::run_jobs()
{
     #ifdef LIN_ARM64
      QStringList args;
      args<<"-dpms";
      disable_dpms->start("xset",args,QIODevice::ReadWrite);
      args.clear();
      args<<"dpms"<<"4";
      enable_dpms->start("xset",args,QIODevice::ReadWrite);

     #endif
}

// --- CONSTRUCTOR ---
CronJobsWorker::CronJobsWorker() {
//    this->enable_dpms = new QProcess();
//    this->disable_dpms = new QProcess();
}

// --- DECONSTRUCTOR ---
CronJobsWorker::~CronJobsWorker() {
    // free resources
}

// --- PROCESS ---
// Start processing data.
void CronJobsWorker::process() {
//     #ifdef LIN_ARM64
//        QProcess OProcess;
//        QString Command;    //Contains the command to be executed
//        QStringList args;   //Contains arguments of the command

//        args<<"-dpms";
//        OProcess.start("xset",args,QIODevice::ReadWrite); //Starts execution of command
//        OProcess.waitForFinished();
//        args.clear();
//        args<<"dpms"<<"4";
//        OProcess.start("xset",args,QIODevice::ReadWrite); //Starts execution of command
//        OProcess.waitForFinished();
//     #endif

//    you call the dummy process here
//    this->costlyDummyProcess();
}

#include <QtMath>
void CronJobsWorker::costlyDummyProcess() {
    qDebug() << "Costly process started";
    double b = 1;
    for (int i = 0 ; i < 1000000000 ; i++){
        b = b * (1000000.34332324 * 99999.05323235);
        b = exp(b);
        }
    qDebug() << "Costly process finished";
}

CronJobsMgr::CronJobsMgr(){
    this->thread1 = new QThread;
    this->cronJobsWorker = new CronJobsWorker();
    cronJobsWorker->moveToThread(thread1);
    connect(cronJobsWorker, SIGNAL(finished()), thread1, SLOT(quit()));
    connect(cronJobsWorker, SIGNAL(finished()), cronJobsWorker, SLOT(deleteLater()));
    connect(thread1, SIGNAL(finished()), thread1, SLOT(deleteLater()));
//    connect(thread1, SIGNAL(started()), cronJobsWorker, SLOT(process()));
    thread1->start();
    this->timer = new QTimer();
//    timeout = 3000;
    this->timer->setInterval(timeout);
    connect(timer,&QTimer::timeout,cronJobsWorker,&CronJobsWorker::process);
//    connect(this->timer,SIGNAL(timeout),this->cronJobsWorker, SLOT(process()));
    this->timer->start();

}

std::string exec(const char* cmd) {
    std::array<char, 128> buffer;
    std::string result;
    std::unique_ptr<FILE, decltype(&pclose)> pipe(popen(cmd, "r"), pclose);
    if (!pipe) {
        throw std::runtime_error("popen() failed!");
    }
    while (fgets(buffer.data(), buffer.size(), pipe.get()) != nullptr) {
        result += buffer.data();
    }
    return result;
}
