#ifndef SERIALMESSAGESCHEDULER_H
#define SERIALMESSAGESCHEDULER_H
#include <QTimer>
#include <QObject>
#include "serialmng.h"

class SerialScheduler: public QObject{
    Q_OBJECT
    QTimer *waitTimer;
    QString lastKey = "";
    QString lastKeyParameter = "";
    SerialMng * smng;
public:
    SerialScheduler(SerialMng *parent = nullptr);
    void sendKey(QString key,QString param="");
    bool queueHasntEnded();

};
#endif // SERIALMESSAGESCHEDULER_H
