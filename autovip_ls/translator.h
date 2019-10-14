#ifndef TRANSLATOR_H
#define TRANSLATOR_H

#include <QObject>
#include <QGuiApplication>
#include <QQuickView>
#include <QTranslator>
#include "langs.h"

class Translator : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString emptyString READ getEmptyString NOTIFY languageChanged)

public:
    Translator(QGuiApplication* app) { mApp = app; }

    QString getEmptyString() { return ""; }

signals:
    void languageChanged();

public slots:
    void updateLanguage(int lang){
        switch(lang){
        case Langs::AR:
            mTranslator.load("general_AR", ":/translator");
            mApp->installTranslator(&mTranslator);
            break;
        case Langs::JAP:
            mTranslator.load("general_JA", ":/translator");
            mApp->installTranslator(&mTranslator);
            break;
        case Langs::TR:
            mTranslator.load("general_TR", ":/translator");
            mApp->installTranslator(&mTranslator);
            break;
        case Langs::CH:
            mTranslator.load("general_CH", ":/translator");
            mApp->installTranslator(&mTranslator);
            break;
        default:
            mApp->removeTranslator(&mTranslator);
            break;
        }
        emit languageChanged();
    }

private:
    QGuiApplication* mApp;
    QTranslator mTranslator;
};

#endif // MYTRANSLATOR_H

