#ifndef NVIDIACONNMANAGER_H
#define NVIDIACONNMANAGER_H

#include <QtCore/QObject>
#include <QtCore/QList>
#include <QtWebSockets>
#include <QtCore>
#include <QObject>
#include <iostream>
#include <memory>
#include "serialmng.h"
#include "settingsmanager.h"

class NvidiaConnManager;


class NvidiaConnManager: public QObject
{
    Q_OBJECT

    QWebSocketServer *webSocketServer;
    QList<QWebSocket *> clients;
    SerialMng* serial_mng;
    SettingsManager* SM;
    QJsonObject stateObject {};
    QMap<QString, QString> bustype;
    QTimer * menuReturnTimer = nullptr;
    int changePageTimeout = 2000;
    QString usersLastPage = "Home";
    QMap<QString, QStringList> commandMap;

private:
    void initializeStateObject();
    void setProtocolBusType();
    void createCommandMap();
    bool commandExists(QString part0, QString part1);
public:
    NvidiaConnManager(quint16 port, SerialMng *serial_mng , SettingsManager *SM, QObject * parent = nullptr);
    virtual ~NvidiaConnManager();

signals:
    void closed();
    void changeQmlPage(QString page);
    //void sendSuggestion(QString suggestion);        //suggestion based on emotional analysis performed by AI

private slots:
    void onNewConnection();
    void processMessage(const QString &message);
    void returnToUsersPage();
    void socketDisconnected();

public slots:
    void stateJsonUpdated(QString ID, QString value);
    void setUsersLastPage(QString page);

};

#endif // NVIDIACONNMANAGER_H
