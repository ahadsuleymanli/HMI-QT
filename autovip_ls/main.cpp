#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <settingsmanager.h>
#include "langs.h"
#include "translator.h"
#include <QObject>
#include <initializemng.h>
#include "mediaplayermng.h"
#include <logger/dualfilelogger.h>
#include <cronjobs.h>
#include <QDebug>
#include "clocksetter.h"
#include "updatecheck.h"
#include "restarter.h"
#include <QDir>
#include <nvidiaconnmanager.h>
#include "MediaPlayer/tracklist.h"
#include "MediaPlayer/mediaplayerbackend.h"
#include <QProcess>
#include "MediaPlayer/secondthread.h"
#include "MediaPlayer/mediaplayerfrontend.h"

bool changeCD()
{
    QString realpath = "/home/linaro/autovip";
    if(QFileInfo::exists("/home/linaro/autovip")){
       return QDir::setCurrent(realpath);
    }
    return false;
}

int main(int argc, char *argv[])
{
//    qDebug()<<"start"<<endl;
    //qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    qputenv("QT_QUICK_CONTROLS_STYLE", "material");
    qputenv("QSG_RENDER_LOOP", "basic"); // PC ANIMATION
//    qputenv("QSG_INFO", "1"); // INFO
    changeCD();



    QQmlApplicationEngine engine;


//    qDebug()<<"apps created"<<endl;
    qmlRegisterType<Restarter>("closx.restarter", 1, 0, "Restarter");
    qmlRegisterType<SettingsManager>("closx.smanager", 1, 0, "SettingsManager");
    qmlRegisterType<ClockSetter>("closx.clocksetter", 1, 0, "ClockSetter");
    qmlRegisterType<UpdateCheck>("closx.updater",1,0,"Updater");
//    qmlRegisterType<MediaPlayerBackend>("MediaPlayerBackend",1,0,"MediaPlayerBackend");


    SettingsManager sm;
    Translator mTrans(&app);

//    MediaPlayerMng mpMan;

    InitializeMng imng;
    SerialMng smng;
    ClockSetter mclck;

    imng.setTranslator(&mTrans);
    imng.setSettingsManager(&sm);
    imng.setEngine(&engine);
//    imng.setMediaPlayerMng(&mpMan);
    imng.setSerialMng(&smng);

    // instantiating an NvidiaConnManager object
    NvidiaConnManager nvidiaConnManager(1234, &smng, &sm, &app);
    engine.rootContext()->setContextProperty("nvidia_conn_manager", &nvidiaConnManager);
//    SecondThread secondThread;
//    MediaPlayerFrontend mPlayerBackend(&app);
//    QObject::connect(&mPlayerBackend, &MediaPlayerFrontend::playPauseSignal, &secondThread, &SecondThread::playPause);
//    QObject::connect(&mPlayerBackend, &MediaPlayerFrontend::nextSignal, &secondThread, &SecondThread::next);
//    QObject::connect(&mPlayerBackend, &MediaPlayerFrontend::previousSignal, &secondThread, &SecondThread::previous);
//    secondThread.start();
    MediaPlayerBackend mPlayerBackend(&app);
    engine.rootContext()->setContextProperty("mPlayerBackend", &mPlayerBackend);

    if(imng.init() == false)
    {
//        qDebug()<<"init unsuccessful"<<endl;
         return -1;
    }


    return app.exec();
}

