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
    QSettings * datafile = nullptr;
    Q_PROPERTY(int lang READ lang WRITE setLang NOTIFY langChanged)
    Q_PROPERTY(QString mediaPlayerURL READ mediaPlayerURL WRITE setMediaPlayerURL NOTIFY mediaPlayerURLChanged)
    Q_PROPERTY(QString portname READ portname WRITE setPortname NOTIFY portnameChanged)
    Q_PROPERTY(int baudrate READ baudrate WRITE setBaudrate NOTIFY baudrateChanged)
    Q_PROPERTY(uint actype READ actype WRITE setActype NOTIFY actypeChanged)
    Q_PROPERTY(uint mediaplayertype READ mediaplayertype WRITE setMediaplayertype NOTIFY mediaplayertypeChanged)

    Q_PROPERTY(uint tvtype READ tvtype)

    Q_PROPERTY(bool espressoopentime READ espressoopentime)
    Q_PROPERTY(bool seatmovementduration READ seatmovementduration)
    Q_PROPERTY(bool playstation READ playstation)
    Q_PROPERTY(bool satalliteremote READ satalliteremote)
    Q_PROPERTY(bool slboolean READ slboolean)
    Q_PROPERTY(bool dockingstation READ dockingstation)
    Q_PROPERTY(bool twodoor READ twodoor)
    Q_PROPERTY(bool amp READ amp NOTIFY settingsChanged)
    Q_PROPERTY(bool refrigerator READ regrigerator NOTIFY settingsChanged)
    Q_PROPERTY(bool radio READ radio)
    Q_PROPERTY(bool sunroof READ sunroof)
    Q_PROPERTY(bool windows READ windows)
    Q_PROPERTY(bool aircondition READ aircondition)
    Q_PROPERTY(bool espresso READ espresso)
    Q_PROPERTY(bool bar READ bar)
    Q_PROPERTY(bool ceilingscreen READ ceilingscreen)
    Q_PROPERTY(bool safebox READ safebox)
    Q_PROPERTY(bool dvdplayer READ dvdplayer)
    Q_PROPERTY(bool curtains READ curtains)
    Q_PROPERTY(bool demomode READ demomode)
    Q_PROPERTY(bool intro READ intro)

    Q_PROPERTY(bool autoUpdate READ autoUpdate WRITE setAutoUpdate NOTIFY autoUpdateChanged)
    Q_PROPERTY(QString version READ version)
//    Q_PROPERTY(QString lastdownloadedversion READ lastdownloadedversion)
    void deleteLockFile(QString path);
    SettingsManager(QObject *parent = nullptr);
public:
    SettingsManager(SettingsManager const&) = delete;
    SettingsManager& operator=(SettingsManager const&) = delete;
    static SettingsManager& instance(){
      static SettingsManager INSTANCE;
      return INSTANCE;
    }
    void resetSettings();
    int lang();
    uint actype();
    uint tvtype();
    uint espressoopentime();
    uint seatmovementduration();
    int mindiff();
    int hourdiff();
    bool satalliteremote();
    bool playstation();
    bool dockingstation();
    bool twodoor();
    bool regrigerator();
    bool radio();
    bool slboolean();
    bool sunroof();
    Q_INVOKABLE bool pinProtectedSafe();
    bool espresso();
    bool windows();
    bool aircondition();
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
    QSettings* getDatafile();
    Q_INVOKABLE QStringList datafileGetRadioStations();
    Q_INVOKABLE void datafileRemoveRadioStation(QString);
    Q_INVOKABLE void datafileAddRadioStation(QString);

    bool autoUpdate();
    void setAutoUpdate(bool enabled = true);
    QString version();
    QString lastdownloadedversion();


Q_INVOKABLE  QVariant value(QString key, QVariant defaultValue = QVariant());
Q_INVOKABLE  bool bganim(){return value("graphics/bganim").toBool();}
Q_INVOKABLE  bool sidelight();
Q_INVOKABLE  bool insidelight();
Q_INVOKABLE  bool readinglight();
Q_INVOKABLE  bool seatHeating(int seat_no);
Q_INVOKABLE  bool seatCooling(int seat_no);
Q_INVOKABLE  bool seatMassage(int seat_no);
Q_INVOKABLE  bool seatThigh(int seat_no);
Q_INVOKABLE  void setTimeDiff(int mindiff, int hourdiff,int daydiff,int monthdiff,int yeardiff);
             void setHwTimeOffset(int sec, int min, int hour,int day,int month,int year, QString timezone);
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
    void autoUpdateChanged(bool);
    void settingsChanged(bool);
public slots:
};

#endif // SETTINGSMANAGER_H
