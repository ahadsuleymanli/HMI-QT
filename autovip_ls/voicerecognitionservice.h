#ifndef VOICERECOGNITIONSERVICE_H
#define VOICERECOGNITIONSERVICE_H

#include <QObject>
#include <websocketcontroller.h>
#include <langs.h>

class VoiceRecognitionService : public QObject
{
    Q_OBJECT
    WebsocketController * m_cont = nullptr;
    int m_busy = -1; // -1 not conected, 0 busy, 1 ready
    Q_PROPERTY(int busy READ busy NOTIFY busyChanged)
private:
public:
    explicit VoiceRecognitionService(QObject *parent = nullptr);
    Q_INVOKABLE void openMic();
    Q_INVOKABLE void closeMic();
    int busy();

signals:
    void voiceCode(int);
    void notdetected(QString);
    void busyChanged(int);


public slots:
    void setLang(int p);
    void hvoiceCode(int p_code);
    void hnotdetection(QString p_msg);
    void handle_connectionChange(bool p_state);
};

#endif // VOICERECOGNITIONSERVICE_H
