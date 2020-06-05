#ifndef SERIALMESSAGESCHEDULER_H
#define SERIALMESSAGESCHEDULER_H
#include <QTimer>
#include <QObject>
#include "serialmng.h"
#include "settingsmanager.h"

class DelayedMessage: public QObject{
    Q_OBJECT
    SerialMng * smng;
    QString message;
    QTimer *postSendWaitTimer;
public:
    DelayedMessage(QString message, int delay, SerialMng *smng, DelayedMessage **head, QObject *parent = nullptr);
    DelayedMessage *next = nullptr;
    DelayedMessage **head;
public slots:
    void sendMessageAndStartTimer();
    void timerAction();
signals:
    void start();
};

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
    DelayedMessage * delayedMessageHead = nullptr;
public:
    SerialScheduler(QSerialPort* serialConn, SerialMng *parent = nullptr);
    void reopenSerial(bool wait = false);
    void sendKey(QString key,QString param="");
    bool queueHasntEnded();
    void enqueueMessage(QString message, int delay);
    bool messageQueueEmpty();
signals:


};
#endif // SERIALMESSAGESCHEDULER_H
