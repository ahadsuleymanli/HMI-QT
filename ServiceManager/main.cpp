#include <QCoreApplication>
#include <servicemanager.h>

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);
    ServiceManager smng;
    QMetaObject::invokeMethod(&smng,&ServiceManager::simulate);
    return a.exec();
}
