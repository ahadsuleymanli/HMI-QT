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
    //QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
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
    qmlRegisterType<UpdateCheck>("closx.updater",1,0,"Updater");            // Ahadin notlari: bunu yapmakla klasin 2 kez instantiate ediyorsun.

    SettingsManager sm;
    Translator mTrans(&app);
    MediaPlayerMng mpMan;
    InitializeMng imng;
    SerialMng smng;
    ClockSetter mclck;
//    qDebug()<<"objs created"<<endl;

    imng.setTranslator(&mTrans);
    imng.setSettingsManager(&sm);
    imng.setEngine(&engine);
    imng.setMediaPlayerMng(&mpMan);
    imng.setSerialMng(&smng);

    // instantiating an NvidiaConnManager object
    NvidiaConnManager nvidiaConnManager(1234, &smng, &sm, &app);
    engine.rootContext()->setContextProperty("nvidia_conn_manager", &nvidiaConnManager);
    UpdateCheck updatecheck(&app);
    engine.rootContext()->setContextProperty("update_manager", &updatecheck);


    if(imng.init() == false)
    {
//        qDebug()<<"init unsuccessful"<<endl;
         return -1;
    }

//    qDebug()<<"init successful"<<endl;
//    CronJobs cjobs;
//    CronJobsMgr cronJobsMgr;


    return app.exec();
}

