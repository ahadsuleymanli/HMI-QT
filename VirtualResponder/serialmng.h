#ifndef SERIALMNG_H
#define SERIALMNG_H

#include <QObject>
#include <QSerialPort>
#include <qglobal.h>
#include <QDebug>
#include <ifhandler.h>
#include <QVector>
#include <QRegularExpression>
#include <QSettings>
#include <QCoreApplication>
#include <QDateTime>
#include <QDebug>


struct Seat{
   int no=1;
   int MassageMode=0;
   int heating=0;
   int cooling=0;
};

class SerialMng : public QObject
{
    Q_OBJECT
    bool m_connected = false;
    QSerialPort * m_serial = nullptr;
    QString portName = "";
    QByteArray m_writeData;
    qint64 m_bytesWritten = 0;
    int m_fandeg = 0;
    int m_acdeg = 0;
    bool m_acopen = false;
    Seat seats[4];
    QMap<QString,IFHandler *> m_handlers;
    QSettings* m_protocol = nullptr;
   QString m_begin = "";
   QString m_end = "";
   QString m_fb_begin="";
   QString m_fb_end="";

    Q_PROPERTY(bool connected READ isConnected  NOTIFY connectionChanged)
    Q_PROPERTY(int fandeg READ fandeg WRITE setFandeg NOTIFY fandegChanged) // fan speed degree
    Q_PROPERTY(int acdeg READ acdeg  WRITE setACDeg NOTIFY acdegChanged) //Aircondition temperature degree
    Q_PROPERTY(bool acopen READ acopen  WRITE setACOpen NOTIFY acopenChanged) //Aircondition open/close
public:
    explicit SerialMng(QObject *parent = nullptr);
    void openSerialPort();
    void closeSerialPort();

    bool setPortName(QString str);
    bool setBaudRate(int val);
    bool setDataBits(int val);
    bool setParity(int val);
    bool setStopBits(int val);
    bool setFlowControl(int val);

    int fandeg();
    int acdeg();
    bool acopen();

    void setFandeg(int val);
    void setACDeg(int val);
    void setACOpen(bool val);


    void parseMessage(QString response);
    bool registerHandler(QString uniqueName, IFHandler * handler);
    QSettings* getProtocolFile();

public: //invokables
    Q_INVOKABLE void write(const QByteArray &writeData);
    Q_INVOKABLE bool isConnected();
signals:
    void connectionChanged(bool);
    void fandegChanged(int);
    void acdegChanged(int);
    void acopenChanged(int);
    void newLog(QString);

public slots:
    void read();
    void handleTimeout();
    void handleError(QSerialPort::SerialPortError error);
    void handleClose();
    void closeSystem();
    void openSystem();
};

#endif // SERIALMNG_H
