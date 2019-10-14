#ifndef SETTINGSMANAGER_H
#define SETTINGSMANAGER_H

#include <QObject>
#include <QSettings>
#include <QGuiApplication>
#include <QFileInfo>
#define STR(tok) #tok
#ifdef WIN_X86_64
    #define STRPNAME "COM5"
#elif defined WIN_X86
    #define STRPNAME "COM5"
#elif defined LIN_X86_64
    #define STRPNAME "TTYS0"
#elif defined MACX_X86_64
    #define STRPNAME "TTYS0"
#elif  defined LIN_ARM64
    #define STRPNAME "ttyMSM1"
#endif

class SettingsManager : public QObject
{
    Q_OBJECT
    QSettings * general = nullptr;
    QSettings * m_proto = nullptr;
    Q_PROPERTY(int lang READ lang WRITE setLang NOTIFY langChanged)
    Q_PROPERTY(QString mediaPlayerURL READ mediaPlayerURL WRITE setMediaPlayerURL NOTIFY mediaPlayerURLChanged)
    Q_PROPERTY(QString portname READ portname WRITE setPortname NOTIFY portnameChanged)
    Q_PROPERTY(int baudrate READ baudrate WRITE setBaudrate NOTIFY baudrateChanged)
    Q_PROPERTY(uint actype READ actype WRITE setActype NOTIFY actypeChanged)
    Q_PROPERTY(uint mediaplayertype READ mediaplayertype WRITE setMediaplayertype NOTIFY mediaplayertypeChanged)

    Q_PROPERTY(uint tvtype READ tvtype)

    Q_PROPERTY(bool playstation READ playstation)
    Q_PROPERTY(bool slboolean READ slboolean)
    Q_PROPERTY(bool dockingstation READ dockingstation)
    Q_PROPERTY(bool twodoor READ twodoor)
    Q_PROPERTY(bool amp READ amp)
    Q_PROPERTY(bool refrigerator READ regrigerator)
    Q_PROPERTY(bool radio READ radio)
    Q_PROPERTY(bool sunroof READ sunroof)
    Q_PROPERTY(bool espresso READ espresso)
    Q_PROPERTY(bool bar READ bar)
    Q_PROPERTY(bool ceilingscreen READ ceilingscreen)
    Q_PROPERTY(bool safebox READ safebox)
    Q_PROPERTY(bool dvdplayer READ dvdplayer)
    Q_PROPERTY(bool curtains READ curtains)
    Q_PROPERTY(bool demomode READ demomode)
    Q_PROPERTY(bool intro READ intro)


    Q_PROPERTY(QString version READ version)
    Q_PROPERTY(QString lastversion READ lastversion)
public:
    explicit SettingsManager(QObject *parent = nullptr);
    int lang();
    uint actype();
    uint tvtype();
    int mindiff();
    int hourdiff();
    bool playstation();
    bool dockingstation();
    bool twodoor();
    bool regrigerator();
    bool radio();
    bool slboolean();
    bool sunroof();
    bool espresso();
    bool bar();
    bool ceilingscreen();
    bool safebox();
    bool dvdplayer();
    bool curtains();
    bool demomode();
    bool intro();
    bool amp();

    void setActype(uint p_actype);
Q_INVOKABLE uint mediaplayertype();
    void setMediaplayertype(uint p_mptype);
    QString mediaPlayerURL();
    void setMediaPlayerURL(QString);
    void setLang(int);
    bool init();
    int baudrate();
    void setBaudrate(int r);
    void setVersion(int major, int minor);
    QString portname();
    void setPortname(QString p_pn);
    QSettings* getSettings();
    QString version();
    QString lastversion();


Q_INVOKABLE  QVariant value(QString key);
Q_INVOKABLE  bool sidelight();
Q_INVOKABLE  bool seatHeating(int seat_no);
Q_INVOKABLE  bool seatCooling(int seat_no);
Q_INVOKABLE  bool seatMassage(int seat_no);
Q_INVOKABLE  bool seatThigh(int seat_no);
Q_INVOKABLE  void setLastVersion(QString lversion);
Q_INVOKABLE  void setTimeDiff(int mndf,int hrdf);
Q_INVOKABLE  bool seatDrawer(int seat_no);
Q_INVOKABLE  bool seatFootrest(int seat_no);
Q_INVOKABLE  bool saveLightMemory(int p_unit,int type,QString p_color);
Q_INVOKABLE  QString getLightMemory(int p_unit,int type);

signals:
    void langChanged(int);
    void mediaPlayerURLChanged(QString);
    void baudrateChanged(int);
    void portnameChanged(QString);
    void actypeChanged(uint);
    void mediaplayertypeChanged(uint);
public slots:
};

#endif // SETTINGSMANAGER_H
