#include "nvidiaconnmanager.h"
#include <QColor>
#include <QMap>

void NvidiaConnManager::setProtocolBusType(){
    bustype["ac"] = SM->actype() == 1 ? "can" : (SM->actype() == 2 ? "modbus" : nullptr);
}

NvidiaConnManager::NvidiaConnManager(quint16 port, SerialMng *serial_mng,  SettingsManager *SM, QObject *parent):
    QObject(parent),
    webSocketServer(new QWebSocketServer(
                           QStringLiteral("nvidia_websocket_server"),
                           QWebSocketServer::NonSecureMode,
                           this))
{
    this->serial_mng = serial_mng;
    this->SM = SM;

    if (webSocketServer->listen(QHostAddress::Any, port))
    {
        QTextStream(stdout) << "Web socket server listening on port " << port << '\n';
        connect(webSocketServer,
                &QWebSocketServer::newConnection,
                this,
                &NvidiaConnManager::onNewConnection);
    }

    initializeStateObject();
    createCommandMap();
    setProtocolBusType();
    menuReturnTimer = new QTimer();
    menuReturnTimer->setInterval(changePageTimeout);
    connect(menuReturnTimer,&QTimer::timeout,this,&NvidiaConnManager::returnToUsersPage);
}

NvidiaConnManager::~NvidiaConnManager()
{
    webSocketServer->close();
}

void NvidiaConnManager::initializeStateObject(){
    stateObject["CeilColor"] = serial_mng->ceilingcolor().name();
    stateObject["InsideColor"] = serial_mng->insidecolor().name();
    stateObject["SideColor"] = serial_mng->sidecolor().name();
    stateObject["fandeg"] = serial_mng->fandeg();
    stateObject["acdeg"] = serial_mng->acdeg();

    connect(this->serial_mng, &SerialMng::ceilingcolorChanged, [this](QColor color){
        this->stateObject["CeilColor"] = color.name();  });

    connect(this->serial_mng, &SerialMng::insidecolorChanged, [this](QColor color){
        this->stateObject["InsideColor"] = color.name(); });

    connect(this->serial_mng, &SerialMng::sidecolorChanged, [this](QColor color){
        this->stateObject["SideColor"] = color.name(); });

    connect(this->serial_mng, &SerialMng::fandegChanged, [this](int fandeg){
        this->stateObject["fandeg"] = fandeg; });

    connect(this->serial_mng, &SerialMng::acdegChanged, [this](int acdeg){
        this->stateObject["acdeg"] = acdeg; });
}


void NvidiaConnManager::onNewConnection()
{
    QTextStream(stdout)  << "InspectionServer::onNewConnection";

    auto socket_ptr = webSocketServer->nextPendingConnection();
    socket_ptr->setParent(this);

    connect(socket_ptr, &QWebSocket::textMessageReceived,
            this, &NvidiaConnManager::processMessage);
    connect(socket_ptr, &QWebSocket::disconnected,
            this, &NvidiaConnManager::socketDisconnected);

    clients << socket_ptr;
}



void NvidiaConnManager::createCommandMap(){
    commandMap.insert("ChangeMenu",{"Home", "Lights", "AirConditioner"});
}


bool NvidiaConnManager::commandExists(QString part0, QString part1){

    if (commandMap.contains(part0) && commandMap[part0].contains(part1))
        return true;
    else {
        qDebug()<<"command "<<part0<<part1<<"is not defined";
        return false;
    }
}

// TODO: remove the color string validation
// TODO: implement specific temperature setting
// TODO: implement curtains
// TODO: OO implementation of ui and serialmanager things
void NvidiaConnManager::processMessage(const QString &message)
{
    QStringList msg_parts = message.split(" ");
    if (msg_parts[0] == "CeilColor" && msg_parts.length()==2 && QColor::isValidColor(msg_parts[1]))
    {
//        if (usersLastPage == "Home")
//            emit changeQmlPage("Lights");
        QColor color = QColor(msg_parts[1]);
        this->serial_mng->setCeilingcolor(color);
    }
    else if (msg_parts[0] == "SideColor" && msg_parts.length()==2 && QColor::isValidColor(msg_parts[1]))
    {
        QColor color = QColor(msg_parts[1]);
        this->serial_mng->setSidecolor(color);
    }
    else if (msg_parts[0] == "InsideColor" && msg_parts.length()==2 && QColor::isValidColor(msg_parts[1]))
    {
        QColor color = QColor(msg_parts[1]);
        this->serial_mng->setInsidecolor(color);
    }
    else if (msg_parts[0] == "fandeg" && msg_parts.length()==2)
    {
        if(msg_parts[1]=="up"){
            this->serial_mng->sendKey("controls/" + bustype["ac"] + "_ai_fan_up");
        }
        else if (msg_parts[1]=="down"){
            this->serial_mng->sendKey("controls/" + bustype["ac"] + "_ai_fan_down");
        }
    }
    else if (msg_parts[0] == "acdeg" && msg_parts.length()==2)
    {
        int current_acdeg = serial_mng->acdeg();
        if(msg_parts[1]=="up"){
            this->serial_mng->sendKey("controls/" + bustype["ac"] + "_ai_degree_up");
            if(current_acdeg < 13)
                this->serial_mng->setACDeg(current_acdeg + 1);
        }
        else if (msg_parts[1]=="down"){
            this->serial_mng->sendKey("controls/" + bustype["ac"] + "_ai_degree_down");
            if(current_acdeg > -1 )
                this->serial_mng->setACDeg(current_acdeg - 1);
        }
    }
    else if (msg_parts[0] == "ChangeMenu" && msg_parts.length()==2)
    {
        if (commandExists(msg_parts[0],msg_parts[1]))
            emit changeQmlPage(msg_parts[1]);
    }
}




static QString getIdentifier(QWebSocket *peer)
{
    return QStringLiteral("%1:%2").arg(peer->peerAddress().toString(),
                                       QString::number(peer->peerPort()));
}

void NvidiaConnManager::socketDisconnected()
{
    QWebSocket *client_ptr = qobject_cast<QWebSocket *>(sender());
    QTextStream(stdout) << "\n" <<getIdentifier(client_ptr) << " disconnected!\n";
    if (client_ptr)
    {
        clients.removeAll(client_ptr);
        client_ptr->deleteLater();
    }

}


void NvidiaConnManager::stateJsonUpdated(QString ID, QString value)
{
    stateObject[ID] = value;
//    qDebug() <<"state json updated " + ID +" " + value;
    qDebug() <<"stateJsonObject: " << stateObject;

}
void NvidiaConnManager::setUsersLastPage(QString page)
{
    usersLastPage = page;
}
void NvidiaConnManager::returnToUsersPage()
{
    menuReturnTimer->stop();
    emit changeQmlPage(usersLastPage);
}
