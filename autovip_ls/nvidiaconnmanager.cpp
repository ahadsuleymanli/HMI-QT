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
    setProtocolBusType();
    instantiateValueChangers();
    menuReturnTimer = new QTimer();
    menuReturnTimer->setInterval(changePageTimeout);
    connect(menuReturnTimer,&QTimer::timeout,this,&NvidiaConnManager::returnToUsersPage);


}

NvidiaConnManager::~NvidiaConnManager()
{
    webSocketServer->close();
}

void NvidiaConnManager::instantiateValueChangers(){
    //acdeg------------------------
    acdegChanger = new IterativeValueChanger("acdeg",50,[this](int current, int target)-> int{
        if (current < target){
            this->serial_mng->sendKey("controls/" + bustype["ac"] + "_ai_degree_up",true,50);
            this->serial_mng->setACDeg(current += 1);
        }
        else if (current > target){
            this->serial_mng->sendKey("controls/" + bustype["ac"] + "_ai_degree_down",true,50);
            this->serial_mng->setACDeg(current -= 1);
        }
        return current;
    });
    acdegChanger->setMinMax(0,13, 20-15);
    //acfan-------------------------
    acfanChanger = new IterativeValueChanger("acfan",50,[this](int current, int target)-> int{
        if (current < target){
            this->serial_mng->sendKey("controls/" + bustype["ac"] + "_ai_fan_up",true,50);
            this->serial_mng->setACDeg(current += 1);
        }
        else if (current > target){
            this->serial_mng->sendKey("controls/" + bustype["ac"] + "_ai_fan_down",true,50);
            this->serial_mng->setACDeg(current -= 1);
        }
        return current;
    });
    acfanChanger->setMinMax(0,7,2);

    toggleCommands = new IterativeValueChanger("toggleCommands",50,nullptr,[this](QString function)-> int{
        this->serial_mng->sendKey(function,true,50);
        return 0;
    });
    timedToggleCommands["seat_headrest_adjust/up"]="head_up";
    timedToggleCommands["seat_headrest_adjust/down"]="head_down";
    timedToggleCommands["seat_headrest_adjust/stop"]="head_stop";
    timedToggleCommands["seat_back_position/forwards"]="back_forward";
    timedToggleCommands["seat_back_position/backwards"]="back_backwards";
    timedToggleCommands["seat_back_position/stop"]="back_stop";
    timedToggleCommands["seat_position/forwards"]="seat_forward";
    timedToggleCommands["seat_position/backwards"]="seat_backwards";
    timedToggleCommands["seat_position/stop"]="seat_stop";
    seatIntentMajorParameters << "forwards_backwards" << "up_down" << "heating_cooling";
    //serial_mng.sendKey("first_seat/"+key)
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
    QTextStream(stdout)  << "InspectionServer::onNewConnection\n";

    auto socket_ptr = webSocketServer->nextPendingConnection();
    socket_ptr->setParent(this);

    connect(socket_ptr, &QWebSocket::textMessageReceived,
            this, &NvidiaConnManager::processMessage);
    connect(socket_ptr, &QWebSocket::disconnected,
            this, &NvidiaConnManager::socketDisconnected);

    clients << socket_ptr;
}


// TODO: implement curtains
// TODO: OO implementation of ui and serialmanager things
void NvidiaConnManager::processMessage(const QString &message)
{
    QJsonDocument jsonResponse = QJsonDocument::fromJson(message.toUtf8());
    QJsonObject jsonObject = jsonResponse.object();
    QVariantMap messageMap = jsonObject.toVariantMap();
//    qDebug() << jsonObject;
//    QTextStream(stdout) << "msg: "<< message<< "\n";
    QStringList parts;
    for(QVariantMap::const_iterator iter = messageMap.begin(); iter != messageMap.end(); ++iter) {
      parts.append( iter.key() + ": " + (iter.value()).toString()) ;
    }
    QTextStream(stdout) << parts.join(" ") << "\n";
    QString intent = messageMap["intent"].toString();

    if (intent=="acdeg" || intent=="acdeg_followup"){
       int current_acdeg = serial_mng->acdeg();
       if(messageMap["open_close"] == "open"){
          if (current_acdeg == -1)
            acdegChanger->turnOn(current_acdeg);
       }
       else if(messageMap["open_close"] == "close"){
          if (current_acdeg != -1)
            acdegChanger->turnOff(current_acdeg);
       }
       else if(messageMap["value"].userType() != QMetaType::QString){
           int val = messageMap["value"].toInt();
           acdegChanger->changeVal(current_acdeg, val - 15);
       }
       else if(messageMap["increase_decrease"] == "increase"){
           acdegChanger->changeVal(current_acdeg, current_acdeg + 1);
       }
       else if (messageMap["increase_decrease"] == "decrease"){
           acdegChanger->changeVal(current_acdeg, current_acdeg - 1);
       }
    }
    if (intent=="acfan" || intent=="acfan_followup"){
       int current_acdeg = serial_mng->acdeg();
       if(messageMap["open_close"] == "open"){
          if (current_acdeg == -1)
            acdegChanger->turnOn(current_acdeg);
       }
       else if(messageMap["open_close"] == "close"){
          if (current_acdeg != -1)
            acdegChanger->turnOff(current_acdeg);
       }
       else if(messageMap["value"].userType() != QMetaType::QString){
           int val = messageMap["value"].toInt();
           acdegChanger->changeVal(current_acdeg, val - 15);
       }
       else if(messageMap["increase_decrease"] == "increase"){

           acdegChanger->changeVal(current_acdeg, current_acdeg + 1);
       }
       else if (messageMap["increase_decrease"] == "decrease"){
           acdegChanger->changeVal(current_acdeg, current_acdeg - 1);
       }
    }
    else if (intent == "change_menu")
    {
        QString menuName = messageMap["menu_name"].toString();
        if ( this->menuNames.contains(menuName) )
            emit changeQmlPage(menuName);
    }
    else if (intent.contains("seat_")){
        QString timedToggleCommandKey  = "";
        timedToggleCommandKey += intent + "/";
        for(QVariantMap::const_iterator iter = messageMap.begin(); iter != messageMap.end(); ++iter) {
            if(seatIntentMajorParameters.contains(iter.key()))
            timedToggleCommandKey += iter.value().toString();
        }
        if (timedToggleCommands.contains(timedToggleCommandKey)){
            QString toggleOnKey = messageMap["seat"].toString() + "/" + timedToggleCommands[timedToggleCommandKey];
            QString toggleOffKey = messageMap["seat"].toString() + "/" + timedToggleCommands[intent + "/stop"];
            toggleCommands->toggleKey(toggleOnKey,toggleOffKey,seatMovementDurationMs);
        }
        else if (intent == "seat_heating_cooling") {
            QString key = messageMap["seat"].toString() + "/";
            if (messageMap["heating_cooling"].toString() == "heating" && messageMap["open_close"].toString() == "open")
                serial_mng->sendKey(key + "heating");
            if (messageMap["heating_cooling"].toString() == "cooling" && messageMap["open_close"].toString() == "open")
                serial_mng->sendKey(key + "cooling");
        }
        else if (intent == "seat_massage") {
            QString key = messageMap["seat"].toString() + "/";
            serial_mng->sendKey(key + "massage_onoff");
        }
    }
    else if (intent == "change_light_colors"){
        QMap<QString, QString> colorTranslations;
        colorTranslations["kırmızı"] = "red";
        colorTranslations["yeşil"] = "green";
        colorTranslations["mavi"] = "blue";
        colorTranslations["gökyüzü mavisi"] = "blue";
        colorTranslations["sarı"] = "yellow";
        colorTranslations["siyah"] = "black";
        colorTranslations["beyaz"] = "white";
        colorTranslations["mor"] = "violet";
        colorTranslations["pembe"] = "pink";
        if (colorTranslations.contains(messageMap["color"].toString())){
            QColor color = QColor(colorTranslations[messageMap["color"].toString()]);
            QString key = "lights/";
            if (messageMap["light_region"].toString() == "default" or messageMap["light_region"].toString() == "ceilingcolor"){
                key += "ceiling";
                this->serial_mng->setCeilingcolor(color);
            }
            else if (messageMap["light_region"].toString() == "sidecolor"){
                key += "side";
                this->serial_mng->setSidecolor(color);
            }
            else if (messageMap["light_region"].toString() == "insidecolor"){
                key += "inside";
                this->serial_mng->setInsidecolor(color);
            }
            if (key != "lights/"){
                serial_mng->sendKey(key + "_red",false,50,QString(color.red()));
                serial_mng->sendKey(key + "_green",false,50,QString(color.green()));
                serial_mng->sendKey(key + "_blue",false,50,QString(color.blue()));
            }
        }
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
