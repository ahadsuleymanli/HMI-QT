#ifndef MEDIAPLAYERMNG_H
#define MEDIAPLAYERMNG_H

#include <QObject>
#include <jcon/jcon.h>
#include "jcon/json_rpc_tcp_client.h"
#include "jcon/json_rpc_websocket_client.h"
#include <QUrl>
#include <QTimer>
#include <QJsonDocument>
#include <QJsonObject>

class MediaPlayerMng : public QObject
{
    Q_OBJECT
    jcon::JsonRpcWebSocketClient * client;
    QString host;
    int port;
    QUrl url;
    bool m_connected = false;
    int m_playerid = -1;
    int m_playid = -1;
    QString m_title = "";
    QString m_thumbnail = "";
    QTimer* check_timer = nullptr;
    float m_speed = 1;
    //total media duration
    double m_thours = 0;
    double m_tminutes = 0;
    double m_tseconds = 0;
    //current media seek
    double m_chours = 0;
    double m_cminutes = 0;
    double m_cseconds = 0;
    float m_percentage = 0;
    Q_PROPERTY(bool connected READ isConnected  NOTIFY connectionChanged)
    Q_PROPERTY(int playerid READ playerid NOTIFY playeridChanged)
    Q_PROPERTY(float speed READ speed NOTIFY speedChanged)
    Q_PROPERTY(float percentage READ percentage NOTIFY percentageChanged)

    Q_PROPERTY(double thours READ thours NOTIFY thoursChanged)
    Q_PROPERTY(double tminutes READ tminutes NOTIFY tminutesChanged)
    Q_PROPERTY(double tseconds READ tseconds NOTIFY tsecondsChanged)

    Q_PROPERTY(double chours READ chours NOTIFY choursChanged)
    Q_PROPERTY(double cminutes READ cminutes NOTIFY cminutesChanged)
    Q_PROPERTY(double cseconds READ cseconds NOTIFY csecondsChanged)

    Q_PROPERTY(QString title READ title NOTIFY titleChanged)
    Q_PROPERTY(QString thumbnail READ thumbnail NOTIFY thumbnailChanged)
    QStringList notificationMethods;
public:
    explicit MediaPlayerMng(QObject *parent = nullptr);
    bool connectToServer(QString host,int port);
    bool connectToServer(QUrl url);
    void setURL(QUrl url);
    bool isConnected();
    int playerid();
    QString title();
    QString thumbnail();
    float speed();

    double thours();
    double tminutes();
    double tseconds();


    double chours();
    double cminutes();
    double cseconds();

    float percentage();


public:
    Q_INVOKABLE void fleft();
    Q_INVOKABLE void fright();
    Q_INVOKABLE void fup();
    Q_INVOKABLE void fdown();
    Q_INVOKABLE void fselect();
    Q_INVOKABLE void fhome();
    Q_INVOKABLE void fcontext();
    Q_INVOKABLE void fback();
    Q_INVOKABLE void getActivePlayers();
    Q_INVOKABLE void getItem(int pid);
    Q_INVOKABLE void getItem();
    Q_INVOKABLE void getData();
    Q_INVOKABLE void playPause();
    Q_INVOKABLE void stop();
    Q_INVOKABLE void fseek(double p);
    Q_INVOKABLE void fgetPlayerProperties();



signals:
    void connectionChanged(bool);
    void playeridChanged(int);
    void titleChanged(QString);
    void thumbnailChanged(QString);
    void speedChanged(float);

    void choursChanged(double);
    void cminutesChanged(double);
    void csecondsChanged(double);


    void thoursChanged(double);
    void tminutesChanged(double);
    void tsecondsChanged(double);

    void percentageChanged(float);


public slots:
    void sendCheckRequests();
    void parseNotification(QJsonObject response);
};

#endif // MEDIAPLAYERMNG_H
