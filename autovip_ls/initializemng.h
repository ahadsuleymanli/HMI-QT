#ifndef INITIALIZEMNG_H
#define INITIALIZEMNG_H
#include "translator.h"
#include "settingsmanager.h"
#include "mediaplayermng.h"
#include "serialmng.h"
#include <QObject>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QUrl>
#include <colorcomponents.h>
#include <logger/filelogger.h>
#include <clocksetter.h>
#include <voicerecognitionservice.h>

class InitializeMng: public QObject
{
    Translator* translator = nullptr;
    SettingsManager* settings_mng = nullptr;
    QQmlApplicationEngine* engine = nullptr;
    MediaPlayerMng* mp_mng = nullptr;
    SerialMng* serial_mng = nullptr;
    FileLogger* flogger = nullptr;
    ClockSetter* csetter = nullptr;
public:
    explicit InitializeMng(QObject *parent = nullptr);
    void setTranslator(Translator * trl);
    void setSettingsManager(SettingsManager* p_sm);
    void setEngine(QQmlApplicationEngine* p_eng);
    void setMediaPlayerMng(MediaPlayerMng* p_mply);
    void setSerialMng(SerialMng* p_smng);

    bool init();
};

#endif // INITIALIZEMNG_H
