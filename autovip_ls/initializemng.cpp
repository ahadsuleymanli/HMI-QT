#include "initializemng.h"
#include <QDebug>
#include <QDir>


InitializeMng::InitializeMng(QObject *parent):QObject(parent)
{
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

bool InitializeMng::init()
{
    Q_ASSERT(
            this->translator != nullptr &&
            this->settings_mng != nullptr &&
            this->engine != nullptr &&
            this->mp_mng != nullptr &&
            this->serial_mng != nullptr
            );
    csetter = new ClockSetter(this);
    if(this->translator == nullptr)
    {
        return false;
    }
    if(this->settings_mng == nullptr)
    {
        return false;
    }
    if(this->engine == nullptr)
    {
        return false;
    }
    if(this->mp_mng == nullptr)
    {
        return false;
    }
    if(this->serial_mng == nullptr)
    {
        return false;
    }

    QObject::connect(settings_mng,&SettingsManager::langChanged,translator,&Translator::updateLanguage,Qt::QueuedConnection);

    qmlRegisterType<Langs>("MyLang", 1, 0, "MyLang");
    qmlRegisterType<VoiceRecognitionService>("VRService",1,0,"VRService");
    qmlRegisterType<ColorComponents>("ColorComponents", 1, 0, "ColorComponents");
    qmlRegisterSingletonType( QUrl("qrc:/SGlobal.qml"), "ck.gmachine", 1, 0, "GSystem" );


    QUrl mediaurl(this->settings_mng->mediaPlayerURL());
    this->mp_mng->setURL(mediaurl);

    if(!this->settings_mng->init()) {
	    qDebug()<<"settings creation error";
	    return false;
    }

    this->flogger = new FileLogger(settings_mng->getSettings(),10000,this);
    this->flogger->installMsgHandler();

    engine->rootContext()->setContextProperty("applicationDirPath", QGuiApplication::applicationDirPath());
    engine->rootContext()->setContextProperty("workingDirPath", QDir::currentPath());
    engine->rootContext()->setContextProperty("SM",this->settings_mng);
    engine->rootContext()->setContextProperty("mytrans", this->translator);
    engine->rootContext()->setContextProperty("serial_mng", this->serial_mng);
    engine->rootContext()->setContextProperty("mp_mng", this->mp_mng);
    engine->rootContext()->setContextProperty("csetter", this->csetter);


    this->translator->updateLanguage(this->settings_mng->lang());

    this->serial_mng->setBaudRate(this->settings_mng->value("serial/baud_rate").toInt());
    this->serial_mng->setDataBits(this->settings_mng->value("serial/databits").toInt());
    this->serial_mng->setParity(this->settings_mng->value("serial/parity").toInt());
    this->serial_mng->setStopBits(this->settings_mng->value("serial/stopbits").toInt());
    this->serial_mng->setFlowControl(this->settings_mng->value("serial/flowcontrol").toInt());
    this->serial_mng->setPortName(this->settings_mng->value("serial/port_name").toString());
    this->serial_mng->setActype(settings_mng->value("main/actype").toInt());

    this->serial_mng->openSerialPort();
    serial_mng->setDemomode(settings_mng->demomode());
    switch(settings_mng->mediaplayertype())
    {
        case 1:
            if(this->mp_mng->connectToServer(mediaurl) == true)
            {
            qDebug()<<"MediaPlayer connection is successful";
            }else{

//            qDebug()<<"MediaPlayer connection is unsuccessful";
            }
        break;

    }


    engine->load(QUrl(QStringLiteral("qrc:/main.qml")));
//    qDebug()<<"main.qml is loadded"<<endl;

    if (engine->rootObjects().isEmpty())
        return false;

    return true;

}
