#include "updater.h"

#include <QCoreApplication>
#include <QDebug>


int main(int argc, char *argv[])
{
    QCoreApplication app(argc, argv);

    Updater updater(&app);
//    updater.app = &app;
    return app.exec();
}

