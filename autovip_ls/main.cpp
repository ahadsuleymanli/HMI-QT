#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <settingsmanager.h>
#include "langs.h"
#include "translator.h"
#include <QObject>
#include <initializemng.h>
#include "mediaplayermng.h"
#include <cronjobs.h>
#include <QDebug>
#include "clocksetter.h"
#include <QDir>
#include <nvidiaconnmanager.h>
#include "MediaPlayer/tracklist.h"
#include "MediaPlayer/mediaplayerbackend.h"
#include <QProcess>
#include "MediaPlayer/secondthread.h"
#include "MediaPlayer/mediaplayerfrontend.h"
#include "tools/logstacktrace.h"

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
    //qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    qputenv("QT_QUICK_CONTROLS_STYLE", "material");
    qputenv("QSG_RENDER_LOOP", "basic"); // PC ANIMATION
    qputenv("QSG_INFO", "1"); // INFO
    changeCD();
    enableStackTraceDump();

    QQmlApplicationEngine engine;
    SettingsManager *sm = &SettingsManager::instance();
    Translator mTrans(&app);
    InitializeMng imng;
    SerialMng smng;
    ClockSetter csetter;
    FileLogger flogger(sm->getSettings(),10000,&app);

    NvidiaConnManager nvidiaConnManager(1234, &smng, sm, &app);
    MediaPlayerBackend mPlayerBackend(&app);

    imng.setMediaPlayerBackend(&mPlayerBackend);
    imng.setClockSetter(&csetter);
    imng.setTranslator(&mTrans);
    imng.setSettingsManager(sm);
    imng.setEngine(&engine);
    imng.setSerialMng(&smng);
    imng.setNvidiaConnManager(&nvidiaConnManager);

//    SecondThread secondThread;
//    MediaPlayerFrontend mPlayerBackend(&app);
//    QObject::connect(&mPlayerBackend, &MediaPlayerFrontend::playPauseSignal, &secondThread, &SecondThread::playPause);
//    QObject::connect(&mPlayerBackend, &MediaPlayerFrontend::nextSignal, &secondThread, &SecondThread::next);
//    QObject::connect(&mPlayerBackend, &MediaPlayerFrontend::previousSignal, &secondThread, &SecondThread::previous);
//    secondThread.start();

    qDebug()<<"initiating imng";
    if(imng.init() == false){
        qDebug()<<"main.cpp: initializemng failed";
         return -1;
    }
    else {
        qDebug()<<"main.cpp: initializemng succeeded";
    }


    return app.exec();
}

