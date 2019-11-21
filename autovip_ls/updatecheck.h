#ifndef UPDATECHECK_H
#define UPDATECHECK_H

#include <QObject>
#include <QProcess>
#include <QDir>
#include <QDebug>
#include <QTimer>
#include <settingsmanager.h>
#include <restarter.h>

class UpdateCheck : public QObject
{
    enum state{
        idle = 0,
        checking,
        failed,
        updateReady,
        uptodate
    };

    Q_OBJECT
    Q_PROPERTY(QString currentVersion READ currentVersion WRITE setCurrentVersion NOTIFY currentVersionChanged)
    Q_PROPERTY(QString updateVersion READ updateVersion WRITE setUpdateVersion NOTIFY updateVersionChanged)

    int m_timeout = 5000;
    QProcess *m_rpro = nullptr;
    QTimer m_timer;
    QString m_programPath = QString("%1/AutoUpdater2").arg(QDir::currentPath());
    QString unzippedPath;
    QTimer overlaytimer;
    SettingsManager sm;
    state m_state;

    QString m_updateVersion;
    QString m_currentVersion;
private:
    bool checkExecutable();
public:
    explicit UpdateCheck(QObject *parent = nullptr);

    QString currentVersion() { return m_currentVersion; }
    void setCurrentVersion(QString version);

    QString updateVersion() { return  m_updateVersion; }
    void setUpdateVersion(QString version);

    Q_INVOKABLE void makeUpdate();
    Q_INVOKABLE void checkUpdate();
    Q_INVOKABLE bool checkUnzipped();
    Q_INVOKABLE QString changeLog();
    Q_INVOKABLE QString dirPath();
    void run();

signals:
    void doUpdateOverlay();
    void updateStateChanged(int updateState);

    void updateVersionChanged(QString);
    void currentVersionChanged(QString);
public slots:
    void handleReadyRead();
    void sendArguments();

    void overlayFunction();
};

#endif // UPDATECHECK_H
