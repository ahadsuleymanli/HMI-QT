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
    Q_OBJECT
    int m_timeout = 5000;
    QProcess *m_rpro = nullptr;
    QTimer m_timer;
    QString m_programPath = QString("%1/AutoUpdater2").arg(QDir::currentPath());
    QString unzippedPath;
    QTimer overlaytimer;
    SettingsManager smng;
    Restarter rstrtr;
private:
    bool checkExecutable();
public:
    explicit UpdateCheck(QObject *parent = nullptr);
    Q_INVOKABLE void makeUpdate();
    Q_INVOKABLE void checkUpdate();
    Q_INVOKABLE bool checkUnzipped();
    Q_INVOKABLE QString changeLog();
    Q_INVOKABLE QString dirPath();
    void run();

signals:
    void doUpdateOverlay();

public slots:
    void overlayFunction();
};

#endif // UPDATECHECK_H
