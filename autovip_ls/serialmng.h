#ifndef SERIALMNG_H
#define SERIALMNG_H

#include <QObject>
#include <QSerialPort>
#include <qglobal.h>
#include <QRegularExpression>
#include <QRegularExpressionMatch>
#include <QDebug>
#include <QSettings>
#include <QTime>
#include <QTimer>
#include <QColor>
#include <voiceprotohandler.h>
struct SeatState {
    Q_GADGET
    Q_PROPERTY(uint cool MEMBER m_cool)
    Q_PROPERTY(uint heat MEMBER m_heat)
    Q_PROPERTY(uint massageon MEMBER m_massageon)
    Q_PROPERTY(uint massagemode MEMBER m_massagemode)
public:
    uint m_cool = 0;
    uint m_heat = 0;
    uint m_massageon = 0;
    uint m_massagemode = 0;
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
    SeatState m_firstseat;
    SeatState m_secondseat;
    SeatState m_thirdseat;
    SeatState m_fourthseat;
    uint m_heat = 0;
    uint m_cool = 0;
    uint m_massageon = false;
    uint m_massagemod = 0;
    QSettings * m_proto;

    QString m_lstart;
    QString m_lend;
    QString m_fbstart;
    QString m_fbend;

    QString m_fb_aircondition;

    QString m_fb_ceiling_light;
    QString m_fb_side_light;
    QString m_fb_inside_light;

    QString m_fb_first_seat;
    QString m_fb_second_seat;
    QString m_fb_third_seat;
    QString m_fb_fourth_seat;
    QString m_fb_system;

    QColor m_ceilingcolor;
    QColor m_insidecolor;
    QColor m_sidecolor;

    QTime m_lastsend;
    int m_last_arranged_cmd = 0;
    int m_wait = 300;
    int m_lightsdelay = -1;
    int m_appletvdelay = -1;
    int m_samsungdelay = -1;
    int m_dividedelay = -1;
    int m_dvddelay = -1;
    int m_dvdsourcedelay = -1;
    int m_lgdelay = -1;
    int m_systemstate = -1;
    int m_actype = 1;
    bool m_demomode = false;

    voice::VoiceProtoHandler* m_voicehandler = nullptr;


    Q_PROPERTY(bool connected READ isConnected  NOTIFY connectionChanged)
    Q_PROPERTY(int fandeg READ fandeg WRITE setFandeg NOTIFY fandegChanged) // fan speed degree
    Q_PROPERTY(int acdeg READ acdeg  WRITE setACDeg NOTIFY acdegChanged) //Aircondition temperature degree
    Q_PROPERTY(bool acopen READ acopen  WRITE setACOpen NOTIFY acopenChanged) //Aircondition open/close
    Q_PROPERTY(SeatState firstseat READ firstseat  WRITE setFirstseat NOTIFY firstseatChanged)
    Q_PROPERTY(SeatState secondseat READ secondseat  WRITE setSecondseat NOTIFY secondseatChanged)
    Q_PROPERTY(SeatState thirdseat READ thirdseat  WRITE setThirdseat NOTIFY thirdseatChanged)
    Q_PROPERTY(SeatState fourthseat READ fourthseat  WRITE setFourthseat NOTIFY fourthseatChanged)
    Q_PROPERTY(uint heat READ heat WRITE setHeat NOTIFY heatChanged)
    Q_PROPERTY(uint cool READ cool WRITE setCool NOTIFY coolChanged)
    Q_PROPERTY(uint massageon READ massageon WRITE setMassageon NOTIFY massageonChanged)
    Q_PROPERTY(uint massagemod READ massagemode WRITE setMassagemod NOTIFY massagemodChanged)
    Q_PROPERTY(int systemstate READ systemstate WRITE setSystemstate NOTIFY systemstateChanged)
    Q_PROPERTY(QColor ceilingcolor READ ceilingcolor WRITE setCeilingcolor NOTIFY ceilingcolorChanged)
    Q_PROPERTY(QColor sidecolor READ sidecolor WRITE setSidecolor NOTIFY sidecolorChanged)
    Q_PROPERTY(QColor insidecolor READ insidecolor WRITE setInsidecolor NOTIFY insidecolorChanged)
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
    void setDemomode(bool p_mode);

    inline void setActype(int p_type){ this->m_actype = p_type;}

    int fandeg();
    int acdeg();
    int systemstate();
    bool acopen();

    uint heat();
    uint cool();
    bool massageon();
    uint massagemode();

    QColor ceilingcolor();
    QColor insidecolor();
    QColor sidecolor();

    void setSystemstate(int p_state);


    void setHeat(uint p_h);
    void setCool(uint p_c);
    void setMassageon(bool p_o);
    void setMassagemod(uint p_mm);

    void setCeilingcolor(QColor p_color);
    void setInsidecolor(QColor p_color);
    void setSidecolor(QColor p_color);



    void setActemp(uint p_temp);
    void setAcfan(uint p_fan);
    void setAcon(bool p_on);


    Q_INVOKABLE SeatState firstseat();
    Q_INVOKABLE SeatState secondseat();
    Q_INVOKABLE SeatState thirdseat();
    Q_INVOKABLE SeatState fourthseat();

    Q_INVOKABLE qint32 getLightsDelay();
    Q_INVOKABLE qint32 getLgDelay();
    Q_INVOKABLE qint32 getSamsungDelay();
    Q_INVOKABLE qint32 getAppltvDelay();
    Q_INVOKABLE qint32 getDivideDelay();
    Q_INVOKABLE qint32 getDvdDelay();
    Q_INVOKABLE qint32 getDvdSourceDelay();

    void setFirstseat(SeatState p_s);
    void setSecondseat(SeatState p_s);
    void setThirdseat(SeatState p_s);
    void setFourthseat(SeatState p_s);

    void setFandeg(int val);
    void setACDeg(int val);
    void setACOpen(bool val);


    void parseFeedback(QString response);
    //feedback parsers
    bool parserAircondition(QString p_response);
    bool parserFirstSeat(QString p_response);
    bool parserSeats(QString p_response);
    bool parserSecondSeat(QString p_response);
    bool parserThirdSeat(QString p_response);
    bool parserFourthSeat(QString p_response);
    bool parserSystem(QString p_response);
    bool parserSideLight(QString p_response);
    bool parserInsideLight(QString p_response);
    bool parserCeilingLight(QString p_response);

public: //invokables
    Q_INVOKABLE void write(const QByteArray &writeData);
    Q_INVOKABLE bool isConnected();
    Q_INVOKABLE bool sendVoiceCommandById(int id);
signals:

    void connectionChanged(bool);
    void fandegChanged(int);
    void acdegChanged(int);
    void acopenChanged(int);

    void systemstateChanged(int);

    void firstseatChanged(SeatState);
    void secondseatChanged(SeatState);
    void fourthseatChanged(SeatState);
    void thirdseatChanged(SeatState);

    void heatChanged(uint);
    void coolChanged(uint);
    void massageonChanged(bool);
    void massagemodChanged(uint);

    void insidecolorChanged(QColor );
    void sidecolorChanged(QColor);
    void ceilingcolorChanged(QColor);

    void runFunction(QString);

public slots:
    void handleBytesWritten(qint64 bytes);
    void sendKey(const QString &key, bool wait=false,int p_delay = -1,QString param="");
    void voiceSendKey(QString key);
    void voiceSendCode(QString key);
    void needDelay(int p_delay);
    //void runFunction(QString p_function_name);
    void newMessage();
    void handleTimeout();
    void handleError(QSerialPort::SerialPortError error);
    void handleClose();
};

#endif // SERIALMNG_H
