#ifndef SERIALMESSAGESCHEDULER_H
#define SERIALMESSAGESCHEDULER_H
#include <QTimer>
#include <QObject>
#include "serialmng.h"
#include "settingsmanager.h"

class SerialScheduler: public QObject{
    Q_OBJECT
    QTimer *waitTimer;
    QTimer *reopenSerialTimer;
    QTimer *continiousSerialCheckTimer;
    QString lastKey = "";
    QString lastKeyParameter = "";
    SerialMng * smng;
    QSerialPort* serialConn;
    SettingsManager *sm;
    QString portname;
public:
    SerialScheduler(QSerialPort* serialConn, SerialMng *parent = nullptr);
    void reopenSerial(bool wait = false);
    void sendKey(QString key,QString param="");
    bool queueHasntEnded();
signals:


};
#endif // SERIALMESSAGESCHEDULER_H
