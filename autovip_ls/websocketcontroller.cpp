#include "websocketcontroller.h"
#include <QStringLiteral>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>

#include <cstdio>
using namespace std;

QT_USE_NAMESPACE

static QString getIdentifier(QWebSocket *peer)
{
    return QStringLiteral("%1:%2").arg(peer->peerAddress().toString(),
                                       QString::number(peer->peerPort()));
}

WebsocketController::WebsocketController(quint16 port, QObject *parent):
    QObject(parent),
    m_pWebSocketServer(new QWebSocketServer(
                           QStringLiteral("dvserver"),
                           QWebSocketServer::NonSecureMode,
                           this))
{

    if (m_pWebSocketServer->listen(QHostAddress::Any, port))
    {
        QTextStream(stdout) << "Web socket server listening on port" << port << '\n';
        connect(m_pWebSocketServer,
                &QWebSocketServer::newConnection,
                this,
                &WebsocketController::onNewConnection);
    }
    prepareOpenCmd();
}

WebsocketController::~WebsocketController()
{
    m_pWebSocketServer->close();
}

void WebsocketController::openMic()
{
    for (QWebSocket *pClient : qAsConst(m_clients)) {
            pClient->sendTextMessage(m_opencmd);
    }

}

void WebsocketController::closeMic()
{

}

void WebsocketController::setLang(Langs::E_Languages p_lang)
{
    m_seleted_lang = p_lang;
    prepareOpenCmd();
}

void WebsocketController::onNewConnection()
{
    auto pSocket = m_pWebSocketServer->nextPendingConnection();
    QTextStream(stdout) << getIdentifier(pSocket) << " connected!\n";
    pSocket->setParent(this);

    connect(pSocket, &QWebSocket::textMessageReceived,
            this, &WebsocketController::processMessage);
    connect(pSocket, &QWebSocket::disconnected,
            this, &WebsocketController::socketDisconnected);

    m_clients << pSocket;

    if(m_clients.size() == 1)
    {
        emit stateChanged(true);
    }

}

void WebsocketController::processMessage(const QString &message)
{
    try{
        qDebug()<<"Microphone Service Message : "<<message<<endl;
        QJsonDocument json = QJsonDocument::fromJson(message.toUtf8());
        QJsonObject obj = json.object();
        if(!obj.contains("notice") || !obj.contains("state"))
        {
            return;
        }else{

            QString state = obj.value("state").toString();
            if(!state.compare("notfound"))
            {
                emit notDetected(state);
                return;
            }else{
                bool ok;
                int code = state.toInt(&ok);
                if(ok == false) return;
                 emit voiceCode(code);
                return;
            }

        }


    }catch(...)
    {
        qDebug()<<"Voice json message error"<<endl;
    }

}

void WebsocketController::socketDisconnected()
{
    QWebSocket *pClient = qobject_cast<QWebSocket *>(sender());
    QTextStream(stdout) << getIdentifier(pClient) << " disconnected!\n";
    if (pClient)
    {
        m_clients.removeAll(pClient);
        pClient->deleteLater();
    }
    if(m_clients.size() == 0)
    {
        emit stateChanged(false);
    }

}

QString WebsocketController::prepareOpenCmd()
{

    QJsonObject obj;
    obj.insert("method","vr");
    switch (m_seleted_lang) {
    case Langs::TR:
        obj.insert("lang","trt");
        break;
    case Langs::ENG:
        obj.insert("lang","enu");
        break;
    case Langs::AR:
        obj.insert("lang","ar");
        break;
    case Langs::JAP:
        obj.insert("lang","jap");
        break;
    }
    QJsonDocument doc;
    doc.setObject(obj);
    m_opencmd = doc.toJson();
    return m_opencmd;
}
