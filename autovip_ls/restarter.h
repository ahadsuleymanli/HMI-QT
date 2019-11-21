#ifndef RESTARTER_H
#define RESTARTER_H

#include <QObject>
#include <QProcess>
#include <QQmlEngine>
#include <QDebug>

class Restarter : public QObject
{
    Q_OBJECT
    Q_DISABLE_COPY(Restarter)
    Restarter(){}

public:
    static QObject *qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine)
    {
        Q_UNUSED(engine);
        Q_UNUSED(scriptEngine);

        return new Restarter;
    }
    Q_INVOKABLE static void makeRestart(){
        qDebug()<<"restarter.cpp: restarting";
        QProcess::execute("sudo service dizaynvip restart");
    }
    Q_INVOKABLE static void restoreOlderVersion(){
        qDebug()<<"restarter.cpp: restoring old version";
        QProcess::startDetached("sudo ./backup/restore.sh");
    }

};

#endif // RESTARTER_H
