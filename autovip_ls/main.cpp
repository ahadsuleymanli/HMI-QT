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
#include "MediaPlayer/mediaplayercontroller.h"
#include "MediaPlayer/facade.h"
#include <QAudioDeviceInfo>
#include <QProcess>
#include "tools/logstacktrace.h"
#include "secondthread/thread.h"
#include "secondthread/threadutils.h"

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
    ThreadUtils::pin_to_core(0,(pthread_t)QThread::currentThreadId());
    //qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
//    ThreadUtils::pin_to_core(0,(pthread_t)app.thread());

    qputenv("QT_QUICK_CONTROLS_STYLE", "material");
    qputenv("QSG_RENDER_LOOP", "basic"); // PC ANIMATION
//    qputenv("QSG_INFO", "1"); // INFO
    changeCD();
    enableStackTraceDump();

    QQmlApplicationEngine engine;
    SettingsManager *sm = &SettingsManager::instance();
    Translator mTrans(&app);
    InitializeMng imng;
    SerialMng smng;
    FileLogger flogger(sm->getSettings(),10000,&app);
    ClockSetter csetter;
    qDebug()<<"main called from: "<<QThread::currentThreadId();
    MediaPlayerFacade mPlayerFacade(&app);
    SecondThread secondthread(&csetter, &mPlayerFacade);
    csetter.start();

    NvidiaConnManager nvidiaConnManager(1234, &smng, sm, &app);

    imng.setMediaPlayerController(&mPlayerFacade);
    imng.setClockSetter(&csetter);
    imng.setTranslator(&mTrans);
    imng.setSettingsManager(sm);
    imng.setEngine(&engine);
    imng.setSerialMng(&smng);
    imng.setNvidiaConnManager(&nvidiaConnManager);

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

