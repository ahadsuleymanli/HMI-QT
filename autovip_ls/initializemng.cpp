#include "initializemng.h"
#include "updatecheck.h"
#include "restarter.h"
#include "MediaPlayer/mediaplayercontroller.h"
#include <QDebug>
#include <QDir>
#include <QProcess>

InitializeMng::InitializeMng(QObject *parent):QObject(parent)
{
}

void InitializeMng::setMediaPlayerController(MediaPlayerController *mPlayerController)
{
    this->mPlayerController = mPlayerController;
}

void InitializeMng::setClockSetter(ClockSetter *csetter)
{
    this->csetter = csetter;
}

void InitializeMng::setTranslator(Translator *trl)
{
    this->translator = trl;
}

void InitializeMng::setSettingsManager(SettingsManager *p_sm)
{
    this->settings_mng = p_sm;
}

void InitializeMng::setEngine(QQmlApplicationEngine *p_eng)
{
    this->engine = p_eng;
}

void InitializeMng::setMediaPlayerMng(MediaPlayerMng *p_mply)
{
    this->mp_mng = p_mply;
}

void InitializeMng::setSerialMng(SerialMng *p_smng)
{
   this->serial_mng = p_smng;
}
void InitializeMng::setNvidiaConnManager(NvidiaConnManager *nvidiaConnManager)
{
   this->nvidiaConnManager = nvidiaConnManager;
}

bool InitializeMng::init()
{
    Q_ASSERT(
            this->mPlayerController != nullptr &&
            this->csetter != nullptr &&
            this->translator != nullptr &&
            this->settings_mng != nullptr &&
            this->engine != nullptr &&
            this->serial_mng != nullptr
            );

    QProcess *removeProcess = new QProcess();
    connect(removeProcess, SIGNAL(finished(int,QProcess::ExitStatus)), removeProcess, SLOT(deleteLater()));
//    qDebug()<<"initializemng.cpp: removing /var/lock/LCK..ttyMSM1";
    removeProcess->start("sudo rm /var/lock/LCK..ttyMSM1");
    bool waitResult = removeProcess->waitForFinished(1000);
//    qDebug()<<"initializemng.cpp: removed /var/lock/LCK..ttyMSM1 , result: "<< waitResult;
    QObject::connect(settings_mng,&SettingsManager::langChanged,translator,&Translator::updateLanguage,Qt::QueuedConnection);

    qmlRegisterType<Langs>("MyLang", 1, 0, "MyLang");
    qmlRegisterType<VoiceRecognitionService>("VRService",1,0,"VRService");
    qmlRegisterType<ColorComponents>("ColorComponents", 1, 0, "ColorComponents");
    qmlRegisterType<UpdateCheck>("closx.updater",1,0,"Updater");
    qmlRegisterSingletonType( QUrl("qrc:/SGlobal.qml"), "ck.gmachine", 1, 0, "GSystem" );
    qmlRegisterSingletonType<Restarter>("closx.restarter", 1, 0,"Restarter",&Restarter::qmlInstance);


    QUrl mediaurl(this->settings_mng->mediaPlayerURL());
//    this->mp_mng->setURL(mediaurl);

    if(!this->settings_mng->init()) {
        qDebug()<<"ini files not found";
	    return false;
    }


    engine->rootContext()->setContextProperty("applicationDirPath", QGuiApplication::applicationDirPath());
    engine->rootContext()->setContextProperty("workingDirPath", QDir::currentPath());
    engine->rootContext()->setContextProperty("SM",this->settings_mng);
    engine->rootContext()->setContextProperty("mytrans", this->translator);
    engine->rootContext()->setContextProperty("serial_mng", this->serial_mng);
    engine->rootContext()->setContextProperty("csetter", this->csetter);
    qmlRegisterInterface<TrackList>("TrackList");

    engine->rootContext()->setContextProperty("mPlayerBackend", mPlayerController);
    if (nvidiaConnManager)
        engine->rootContext()->setContextProperty("nvidia_conn_manager", nvidiaConnManager);


    this->translator->updateLanguage(this->settings_mng->lang());
    qDebug()<<"initializemng.cpp: serial_mng->setBaudRate.., etc";
    this->serial_mng->setBaudRate(this->settings_mng->value("serial/baud_rate").toInt());
    this->serial_mng->setDataBits(this->settings_mng->value("serial/databits").toInt());
    this->serial_mng->setParity(this->settings_mng->value("serial/parity").toInt());
    this->serial_mng->setStopBits(this->settings_mng->value("serial/stopbits").toInt());
    this->serial_mng->setFlowControl(this->settings_mng->value("serial/flowcontrol").toInt());
    this->serial_mng->setPortName(this->settings_mng->value("serial/port_name").toString());
    this->serial_mng->setActype(settings_mng->value("main/actype").toInt());
    qDebug()<<"initializemng.cpp: serial_mng->openSerialPort()";
    this->serial_mng->openSerialPort();
    serial_mng->setDemomode(settings_mng->demomode());

    engine->load(QUrl(QStringLiteral("qrc:/main.qml")));
    mPlayerController->init();
    qDebug()<<"initializemng.cpp: main.qml is loadded"<<endl;
    if (engine->rootObjects().isEmpty())
        return false;

    return true;

}
