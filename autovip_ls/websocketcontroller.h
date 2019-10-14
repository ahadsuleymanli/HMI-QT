#ifndef WEBSOCKETCONTROLLER_H
#define WEBSOCKETCONTROLLER_H

#include <QtCore/QObject>
#include <QtCore/QList>
#include <QtWebSockets>
#include <QtCore>
#include <langs.h>


class WebsocketController : public QObject
{
    Q_OBJECT
    QString m_opencmd;
    QString m_closecmd;
    Langs::E_Languages m_seleted_lang = Langs::ENG;
public:
    WebsocketController(quint16 port, QObject * parent);
    virtual ~WebsocketController();
public slots:
    Q_INVOKABLE void openMic();
    Q_INVOKABLE void closeMic();
    void setLang(Langs::E_Languages p_lang);
private slots:
    void onNewConnection();
    void processMessage(const QString &message);
    void socketDisconnected();

private:
    QWebSocketServer *m_pWebSocketServer;
    QList<QWebSocket *> m_clients;
    QString prepareOpenCmd();
signals:
    void voiceCode(int code);
    void notDetected(QString mess);
    void stateChanged(bool );
    void error(QString message);

};

#endif // WEBSOCKETCONTROLLER_H
