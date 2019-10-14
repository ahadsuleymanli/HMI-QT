#include "restarter.h"
//#include <QApplication>
#include <QProcess>
#include <QtDebug>


Restarter::Restarter(QObject *parent) :
    QObject (parent)
{
}

void Restarter::makeRestart()
{
    QProcess::execute("sudo service dizaynvip restart");
}

void Restarter::restoreOlderVersion()
{
    QProcess::startDetached("sudo ./backup/restore.sh");
}
