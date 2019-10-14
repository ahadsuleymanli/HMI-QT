#ifndef SETTINGSMANAGER_H
#define SETTINGSMANAGER_H

#include <QObject>
#include <QSettings>
#include <QFileInfo>
#define STR(tok) #tok
#ifdef WIN_X86_64
    #define STRPNAME "COM5"
#elif defined WIN_X86
    #define STRPNAME "COM5"
#elif defined LIN_X86_64
    #define STRPNAME "tnt1"
#elif defined MACX_X86_64
    #define STRPNAME "TTYS0"
#elif  defined LIN_ARM64
    #define STRPNAME "ttyMSM1"
#endif

class SettingsManager : public QObject
{
    Q_OBJECT
    QSettings * general = nullptr;
    Q_PROPERTY(int lang READ lang WRITE setLang NOTIFY langChanged)
    Q_PROPERTY(QString mediaPlayerURL READ mediaPlayerURL WRITE setMediaPlayerURL NOTIFY mediaPlayerURLChanged)
    Q_PROPERTY(QString portname READ portname WRITE setPortname NOTIFY portnameChanged)
    Q_PROPERTY(int baudrate READ baudrate WRITE setBaudrate NOTIFY baudrateChanged)
public:
    explicit SettingsManager(QObject *parent = nullptr);
    int lang();
    QString mediaPlayerURL();
    void setMediaPlayerURL(QString);
    void setLang(int);
    bool init();
    int baudrate();
    void setBaudrate(int r);
    QString portname();
    void setPortname(QString p_pn);
    QSettings* getSettings();


Q_INVOKABLE  QVariant value(QString key);
Q_INVOKABLE  uint seatHeating(uint seat_no);
Q_INVOKABLE  uint seatCooling(uint seat_no);
Q_INVOKABLE  uint seatMassage(uint seat_no);
Q_INVOKABLE  bool setSeatHeating(uint seat_no, uint deg);
Q_INVOKABLE  bool setSeatCooling(uint seat_no, uint deg);
Q_INVOKABLE  bool setSeatMassage(uint seat_no, uint deg);

signals:
    void langChanged(int);
    void mediaPlayerURLChanged(QString);
    void baudrateChanged(int);
    void portnameChanged(QString);
public slots:
};

#endif // SETTINGSMANAGER_H
