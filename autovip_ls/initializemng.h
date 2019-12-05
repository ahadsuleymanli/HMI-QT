#ifndef INITIALIZEMNG_H
#define INITIALIZEMNG_H
#include "translator.h"
#include "settingsmanager.h"
#include "mediaplayermng.h"
#include "serialmng.h"
#include "nvidiaconnmanager.h"
#include <QObject>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QUrl>
#include <LightsMenu/colorcomponents.h>
#include <logger/filelogger.h>
#include <clocksetter.h>
#include <voicerecognitionservice.h>
#include "MediaPlayer/mediaplayercontroller.h"
#include "MediaPlayer/facade.h"

class InitializeMng: public QObject
{
    Translator* translator = nullptr;
    SettingsManager* settings_mng = nullptr;
    QQmlApplicationEngine* engine = nullptr;
    MediaPlayerMng* mp_mng = nullptr;
    SerialMng* serial_mng = nullptr;
    ClockSetter* csetter = nullptr;
    MediaPlayerFacade* mPlayerController = nullptr;
    NvidiaConnManager* nvidiaConnManager = nullptr;
public:
    explicit InitializeMng(QObject *parent = nullptr);
    void setClockSetter(ClockSetter *csetter);
    void setTranslator(Translator * trl);
    void setSettingsManager(SettingsManager* p_sm);
    void setEngine(QQmlApplicationEngine* p_eng);
    void setMediaPlayerMng(MediaPlayerMng* p_mply);
    void setSerialMng(SerialMng* p_smng);
    void setMediaPlayerController(MediaPlayerFacade *mPlayerController);
    void setNvidiaConnManager(NvidiaConnManager *nvidiaConnManager);

    bool init();
};

#endif // INITIALIZEMNG_H
