#ifndef SEATCONTROLLER_H
#define SEATCONTROLLER_H

#include <QObject>
#include <settingsmanager.h>
#include <handlerinterface.h>
#include <QRegularExpression>
#include <QRegularExpressionMatch>
#include <ifhandler.h>
#include <utility.h>
struct SeatState{
    uint heat = 0;
    uint cooling =0;
    uint massageMod =0;
};
enum MassageType{
    NoMassage,
    ShoulderAndThigh,
    WaistAndThigh,
    ShoulderAndWaist,
    Pulse,
    Smooth,
    Shoulder,
    Thigh,
    Relax
};

namespace  seats{
    enum class Command
      {
        HeadUp=0,
        HeadDown=1,
        BackForward,
        BackBackward,
        ThighUp=6,
        ThighDown=7,
        SeatForward,
        SeatBackward,
        DrawerOpen=10,
        DrawerClose=11,
        MassageOnOff=16,
        MassageMode=17,
        SeatFeedback=22,
        increaseHeating=23,
        increaseCooling=24,
        footRestUp=25,
        footRestDown=26,
        closeMassage=27,
        changeMassageMode=28,
        tableOpen=32,
        tableClose=33,
        curtainOpen=34,
        curtainClose=35,
        commandStopper1=98,
        commandStopper2=99,
        noCommand=1000
      };
}
using namespace seats;

class SeatController : public IFHandler
{
    Q_OBJECT
    Q_INTERFACES(IFHandler)
    SettingsManager * m_sm = nullptr;
    QStringList m_paternList;
    uint com2seatnum(uint p_com);
    uint seatnum2com(uint p_seat);
    QMap<int,Command> seat1_commands;
    QMap<int,Command> seat2_commands;
    QMap<int,Command> seat3_commands;
    QMap<int,Command> seat4_commands;
    bool seatBusy = false;
    bool ctBusy = false; //curtains tables
    Command m_last = Command::noCommand;
    SeatState m_seatStates[4];
    QString m_feedback;
    uint m_cat_first;
    uint m_cat_second;
    uint m_cat_third;
    uint m_cat_fourth;
private:
    void fillSeatCommands(QSettings * p_proto);
    //int extractCommand(QString command_str);
    QString seatnum2String(int num);
public:
    explicit SeatController(QSettings * p_proto,QObject *parent = nullptr);

    void setSM(SettingsManager * p_sm);

    bool closeMassage(uint p_seatno);
    bool changeMassageMode(uint p_seatno);
    uint getMassageMode(uint p_seatno);

    bool setHeatingLevel(uint p_seatno,uint p_level);
    bool increaseHeating(uint p_seatno);
    uint getHeatingLevel(uint p_seatno);

    bool setCoolingLevel(uint p_seatno,uint p_level);
    bool increaseCooling(uint p_seatno);
    uint getCoolingLevel(uint p_seatno);

    bool cmdHeadUp(uint p_seatno);
    bool cmdHeadDown(uint p_seatno);
    bool cmdHeadStop(uint p_seatno);

    bool cmdBackForward(uint p_seatno);
    bool cmdBackBackward(uint p_seatno);
    bool cmdBackStop(uint p_seatno);


    bool cmdSeatForward(uint p_seatno);
    bool cmdSeatBackward(uint p_seatno);
    bool cmdSeatStop(uint p_seatno);
    bool cmdSeatFeedback(uint p_seatno);


    bool cmdFootrestUp(uint p_seatno);
    bool cmdFootrestDown(uint p_seatno);
    bool cmdFootrestStop(uint p_seatno);


    bool cmdTableOpen(uint p_seatno);
    bool cmdTableClose(uint p_seatno);
    bool cmdTableStop(uint p_seatno);


    bool cmdCurtainOpen(uint p_seatno);
    bool cmdCurtainClose(uint p_seatno);
    bool cmdCurtainStop(uint p_seatno);

    bool cmdDrawerOpen(uint p_seatno);
    bool cmdDrawerClose(uint p_seatno);
    bool cmdDrawerStop(uint p_seatno);


    bool cmdFrontThightUp(uint p_seatno);
    bool cmdFrontThightDown(uint p_seatno);
    bool cmdFrontThightStop(uint p_seatno);



    bool messageHandler(QString p_message) override;

    bool commandExecuter(uint seat_no,Command command);

    bool commandStopper(uint seat_no);

    QStringList getPatterns() override;
    QString getFeedback() override;



signals:
    void newLog(QString plog);

public slots:
};

#endif // SEATCONTROLLER_H
