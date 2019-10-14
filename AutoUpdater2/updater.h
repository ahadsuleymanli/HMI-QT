#ifndef UPDATER_H
#define UPDATER_H

#include "qftpcontroller.h"

#include <QFile>
#include <QObject>
#include <QProcess>
#include <QTimer>

class Updater : public QObject
{
    Q_OBJECT
    QFtpController qftpController;
    QString update_server;
    QString password;
    QString username;
    int minor_version;
    int major_version;
    QFile downloadFile;
    QString downloadFileName= "";
    QString current_action_name = "";
    bool TEST_MODE = false;                  // is intended to be used during debugging only
    QProcess unzipProcess;
    QTimer listingDoneTimer;
    QTimer ftpOperationsGracePeriod;
    QString ftpCurrentState;

public:
//    QCoreApplication* app;
    explicit Updater(QObject *parent = nullptr);
    void deleteFile(QString filename);

signals:
    void signalClose(QString closeReason);
//    void signalCheckForUpdate();
//    void signalDownload();
//    void signalApplyUpdate();
//    void quitSignal();

public slots:
    void loginDone();
    void doListing(const QUrlInfo& inf);
    void download();
    void downloadProgress(qint64 p1, qint64 p2);
    void downloadDone();
    void unzipFinished();
    void closeApp(QString closeReason = "");
};

#endif // UPDATER_H
