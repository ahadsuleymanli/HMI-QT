#ifndef AIRCONDITIONCONTROLLER_H
#define AIRCONDITIONCONTROLLER_H
#include <QObject>
#include <settingsmanager.h>
#include <QRegularExpression>
#include <QRegularExpressionMatch>
#include <ifhandler.h>
#include <utility.h>

struct ACState{
    uint fan = 0;
    uint temp = 15;
    bool open =true;
    uint type = 1;  //1 : can 2: modbus
};
namespace  ai{

    enum class CanCommand
      {
        increaseFan=2,
        decreaseFan=3,
        increaseDeg=4,
        decreaseDeg=5
      };

    enum class ModbusCommand
      {
        increaseFan=1,
        decreaseFan=2,
        increaseDeg=3,
        decreaseDeg=4
      };

    enum class Command{
        increaseFan=1,
        decreaseFan=2,
        increaseDeg=3,
        decreaseDeg=4
    };

}


class AirconditionController: public IFHandler
{
    Q_OBJECT
    Q_INTERFACES(IFHandler)
    QStringList m_paternList;
    QString m_feedback;
    ACState m_state;
    uint m_cat_can;
    uint m_cat_modbus;
    uint m_cat_fb;
    QString m_fb_request_can;
    QString m_fb_request_modbus;
    QMap<int,ai::Command> m_mbcommand_map;
    QMap<int,ai::Command> m_cancommand_map;
private:
    void fillSeatCommands(QSettings * p_proto);
public:
    AirconditionController(QSettings * p_proto,QObject * parent=nullptr);

    bool messageHandler(QString p_message) override;
    QStringList getPatterns() override;
    QString getFeedback() override;
    bool commandExecuter(ai::Command p_command);
    bool cmd_increaseDeg();
    bool cmd_decreaseDeg();
    bool cmd_increaseFan();
    bool cmd_decreaseFan();
    bool cmd_feedback();
signals:
    void newLog(QString plog);
};

#endif // AIRCONDITIONCONTROLLER_H
