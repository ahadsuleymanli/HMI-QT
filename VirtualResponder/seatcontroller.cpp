#include "seatcontroller.h"

uint SeatController::com2seatnum(uint p_com)
{
    if(p_com == m_cat_first)
    {
        return 1;
    }
    if(p_com == m_cat_second)
    {
        return 2;
    }
    if(p_com == m_cat_third)
    {
        return 3;
    }
    if(p_com == m_cat_fourth)
    {
        return 4;
    }

       return 0;
}

uint SeatController::seatnum2com(uint p_seat)
{
       switch(p_seat)
       {
        case 1:
           return m_cat_first;
       case 2:
           return m_cat_second;
       case 3:
           return m_cat_third;
       case 4:
           return m_cat_fourth;
       }
       return 0;
}

void SeatController::fillSeatCommands(QSettings * p_proto)
{

    int command;
    QMap<int,Command> *commandMap;
    int seat_no = 1;
    QString str;
    while(seat_no < 5)
    {
        str= seatnum2String(seat_no);
        switch (seat_no) {
        case 1:
        commandMap = &seat1_commands;
        break;
        case 2:
        commandMap = &seat2_commands;
        break;
        case 3:
        commandMap = &seat3_commands;
        break;
        case 4:
        commandMap = &seat4_commands;
        break;
        default:
        return;

        }
        command = extractCommand(p_proto->value(QString("%1/%2").arg(str).arg("back_forward")).toString());
        commandMap->insert(command,Command::BackForward);
        command = extractCommand(p_proto->value(QString("%1/%2").arg(str).arg("back_backward")).toString());
        commandMap->insert(command,Command::BackBackward);
        command = extractCommand(p_proto->value(QString("%1/%2").arg(str).arg("back_stop")).toString());
        commandMap->insert(command,Command::commandStopper1);
        command = extractCommand(p_proto->value(QString("%1/%2").arg(str).arg("cooling")).toString());
        commandMap->insert(command,Command::increaseCooling);
        command = extractCommand(p_proto->value(QString("%1/%2").arg(str).arg("heating")).toString());
        commandMap->insert(command,Command::increaseHeating);
        command = extractCommand(p_proto->value(QString("%1/%2").arg(str).arg("curtain_open")).toString());
        commandMap->insert(command,Command::curtainOpen);
        command = extractCommand(p_proto->value(QString("%1/%2").arg(str).arg("curtain_close")).toString());
        commandMap->insert(command,Command::curtainClose);
        command = extractCommand(p_proto->value(QString("%1/%2").arg(str).arg("drawer_open")).toString());
        commandMap->insert(command,Command::DrawerOpen);
        command = extractCommand(p_proto->value(QString("%1/%2").arg(str).arg("drawer_close")).toString());
        commandMap->insert(command,Command::DrawerClose);
        command = extractCommand(p_proto->value(QString("%1/%2").arg(str).arg("footrest_open")).toString());
        commandMap->insert(command,Command::footRestUp);
        command = extractCommand(p_proto->value(QString("%1/%2").arg(str).arg("footrest_close")).toString());
        commandMap->insert(command,Command::footRestDown);
        command = extractCommand(p_proto->value(QString("%1/%2").arg(str).arg("head_down")).toString());
        commandMap->insert(command,Command::HeadDown);
        command = extractCommand(p_proto->value(QString("%1/%2").arg(str).arg("head_up")).toString());
        commandMap->insert(command,Command::HeadUp);
        command = extractCommand(p_proto->value(QString("%1/%2").arg(str).arg("massage_mode")).toString());
        commandMap->insert(command,Command::MassageMode);
        command = extractCommand(p_proto->value(QString("%1/%2").arg(str).arg("massage_onoff")).toString());
        commandMap->insert(command,Command::MassageOnOff);
        command = extractCommand(p_proto->value(QString("%1/%2").arg(str).arg("seat_backward")).toString());
        commandMap->insert(command,Command::SeatBackward);
        command = extractCommand(p_proto->value(QString("%1/%2").arg(str).arg("seat_forward")).toString());
        commandMap->insert(command,Command::SeatForward);
        command = extractCommand(p_proto->value(QString("%1/%2").arg(str).arg("pagepass")).toString());
        commandMap->insert(command,Command::SeatFeedback);
        command = extractCommand(p_proto->value(QString("%1/%2").arg(str).arg("thigh_down")).toString());
        commandMap->insert(command,Command::ThighDown);
        command = extractCommand(p_proto->value(QString("%1/%2").arg(str).arg("thigh_up")).toString());
        commandMap->insert(command,Command::ThighUp);
        seat_no++;
    } //End of While

}
/*
int SeatController::extractCommand(QString command_str)
{
    QStringList ls = command_str.split("/");
    if(ls.size() < 2)
    {
        return -1;
    }
    return ls.at(1).toInt();
}
*/

QString SeatController::seatnum2String(int num)
{
   switch(num)
   {
    case 1:
            return "first_seat";
    case 2:
            return "second_seat";
    case 3:
       return "third_seat";
    case 4:
       return "fourth_seat";
     default:
           return "";
   }
}

SeatController::SeatController(QSettings * p_proto,QObject *parent) : IFHandler(parent)
{
    m_cat_first = p_proto->value("seats/first_seat").toString().toUInt();
    m_cat_second = p_proto->value("seats/second_seat").toString().toUInt();
    m_cat_third = p_proto->value("seats/third_seat").toString().toUInt();
    m_cat_fourth = p_proto->value("seats/fourth_seat").toString().toUInt();
    m_paternList<<QString("^(%1|%2|%3|%4)/(\\d+)$").arg(m_cat_first).arg(m_cat_second).arg(m_cat_third).arg(m_cat_fourth);
    fillSeatCommands(p_proto);
}

void SeatController::setSM(SettingsManager *p_sm)
{
   m_sm = p_sm;
}


bool SeatController::closeMassage(uint p_seatno)
{

    uint &md = this->m_seatStates[p_seatno-1].massageMod;
    if(md == 0)
    {
        this->m_sm->setSeatMassage(p_seatno,1);
        emit newLog(QString("Seat %1 Massage Mode On").arg(p_seatno));
        md = 1;
    }else{
        this->m_seatStates[p_seatno-1].massageMod = 0;
        emit newLog(QString("Seat %1 Massage Mode Off").arg(p_seatno));
        md = 0;
    }
    this->cmdSeatFeedback(p_seatno);
    return true;
}

bool SeatController::changeMassageMode(uint p_seatno)
{
   uint mm = this->m_sm->seatMassage(p_seatno);
   if(mm == 8)
   {
      mm = 0;
   }else{
      mm++;
   }
   this->m_sm->setSeatMassage(p_seatno,mm);
   m_seatStates[p_seatno-1].massageMod = mm;
   emit newLog(QString("Seat %1 Massage Mod changed to %2").arg(p_seatno).arg(mm));
   cmdSeatFeedback(p_seatno);
   return true;
}

uint SeatController::getMassageMode(uint p_seatno)
{
   return m_seatStates[p_seatno-1].massageMod;
}

bool SeatController::setHeatingLevel(uint p_seatno,uint p_level)
{

    m_seatStates[p_seatno-1].heat = p_level;
    this->m_sm->setSeatHeating(p_seatno,p_level);
    return false;
}

bool SeatController::increaseHeating(uint p_seatno)
{
    if(m_seatStates[p_seatno-1].heat == 0)
    {
        m_seatStates[p_seatno-1].heat = 3;
    }else{
        m_seatStates[p_seatno-1].heat--;
    }
    this->m_sm->setSeatHeating(p_seatno,m_seatStates[p_seatno].heat);

    this->cmdSeatFeedback(p_seatno);
    emit newLog(QString("Seat %1: heat level changed to %2").arg(p_seatno).arg(m_seatStates[p_seatno-1].heat));
    return true;
}

uint SeatController::getHeatingLevel(uint p_seatno)
{
    return m_seatStates[p_seatno-1].heat;
}

bool SeatController::setCoolingLevel(uint p_seatno,uint p_level)
{
    m_seatStates[p_seatno-1].cooling = p_level;
    m_sm->setSeatCooling(p_seatno,p_level);
    return false;
}

bool SeatController::increaseCooling(uint p_seatno)
{
    if(m_seatStates[p_seatno-1].cooling  == 0)
    {
        m_seatStates[p_seatno-1].cooling = 3;
    }else{
        m_seatStates[p_seatno-1].cooling--;
    }
    m_sm->setSeatCooling(p_seatno,m_seatStates[p_seatno-1].cooling);
    this->cmdSeatFeedback(p_seatno );
    emit newLog(QString("Seat %1: cooling level changed to %2").arg(p_seatno).arg(m_seatStates[p_seatno-1].cooling));
    return true;
}

uint SeatController::getCoolingLevel(uint p_seatno)
{
    return m_seatStates[p_seatno-1].cooling;
}

bool SeatController::cmdHeadUp(uint p_seatno)
{
    emit newLog(QString("Seat %1 head up").arg(p_seatno));
    return false;
}

bool SeatController::cmdHeadDown(uint p_seatno)
{

    emit newLog(QString("Seat %1 head down").arg(p_seatno));
    return false;
}

bool SeatController::cmdHeadStop(uint p_seatno)
{

    emit newLog(QString("Seat %1 head stop").arg(p_seatno));
    return false;
}

bool SeatController::cmdBackForward(uint p_seatno)
{

    emit newLog(QString("Seat %1 back forward").arg(p_seatno));
    return false;
}

bool SeatController::cmdBackBackward(uint p_seatno)
{

    emit newLog(QString("Seat %1 back backward").arg(p_seatno));
    return false;
}

bool SeatController::cmdBackStop(uint p_seatno)
{

    emit newLog(QString("Seat %1 back stop").arg(p_seatno));
    return false;
}

bool SeatController::cmdSeatForward(uint p_seatno)
{

    emit newLog(QString("Seat %1 seat forward").arg(p_seatno));
    return false;
}

bool SeatController::cmdSeatBackward(uint p_seatno)
{

    emit newLog(QString("Seat %1 seat backward").arg(p_seatno));
    return false;
}

bool SeatController::cmdSeatStop(uint p_seatno)
{

    emit newLog(QString("Seat %1 seat stop").arg(p_seatno));
    return false;
}

bool SeatController::cmdSeatFeedback(uint p_seatno)
{

    emit newLog(QString("Seat %1 feedback").arg(p_seatno));
    SeatState & tstate = m_seatStates[p_seatno-1];
    this->m_feedback =  QString("%1/%2/%3/%4/%5")
            .arg(seatnum2com(p_seatno))
            .arg(tstate.massageMod!=0)
            .arg(tstate.massageMod)
            .arg(tstate.heat)
            .arg(tstate.cooling);

    return true;
}

bool SeatController::cmdFootrestUp(uint p_seatno)
{

    emit newLog(QString("Seat %1 foot rest up").arg(p_seatno));
    return false;
}

bool SeatController::cmdFootrestDown(uint p_seatno)
{

    emit newLog(QString("Seat %1 foot rest down").arg(p_seatno));
    return false;
}

bool SeatController::cmdFootrestStop(uint p_seatno)
{

    emit newLog(QString("Seat %1 foot rest stop").arg(p_seatno));
    return false;
}

bool SeatController::cmdTableOpen(uint p_seatno)
{

    emit newLog(QString("Table %1 open").arg(p_seatno));
    return false;
}

bool SeatController::cmdTableClose(uint p_seatno)
{

    emit newLog(QString("Table %1 close").arg(p_seatno));
    return false;
}

bool SeatController::cmdTableStop(uint p_seatno)
{

    emit newLog(QString("Table %1 stop").arg(p_seatno));
    return false;
}

bool SeatController::cmdCurtainOpen(uint p_seatno)
{

    emit newLog(QString("Curtain %1 open").arg(p_seatno));
    return false;
}

bool SeatController::cmdCurtainClose(uint p_seatno)
{

    emit newLog(QString("Curtain %1 close").arg(p_seatno));
    return false;
}

bool SeatController::cmdCurtainStop(uint p_seatno)
{

    emit newLog(QString("Curtain %1 stop").arg(p_seatno));
    return false;
}

bool SeatController::cmdDrawerOpen(uint p_seatno)
{

    emit newLog(QString("Drawer %1 open").arg(p_seatno));
    return false;
}

bool SeatController::cmdDrawerClose(uint p_seatno)
{

    emit newLog(QString("Drawer %1 close").arg(p_seatno));
    return false;
}

bool SeatController::cmdDrawerStop(uint p_seatno)
{
    emit newLog(QString("Drawer %1 stop").arg(p_seatno));
    return false;
}

bool SeatController::cmdFrontThightUp(uint p_seatno)
{
    emit newLog(QString("Thight %1 up").arg(p_seatno));
    return false;
}

bool SeatController::cmdFrontThightDown(uint p_seatno)
{
    emit newLog(QString("Thight %1 down").arg(p_seatno));
    return false;
}

bool SeatController::cmdFrontThightStop(uint p_seatno)
{
    emit newLog(QString("Thight %1 stop").arg(p_seatno));
   return false;
}


bool SeatController::messageHandler(QString p_message)
{
    QRegularExpression re(m_paternList[0]);
    QRegularExpressionMatch rem = re.match(p_message);
    if(rem.hasMatch())
    {

       bool ok;
       uint seat_no;
       int command;
       seat_no = com2seatnum(rem.captured(1).toUInt(&ok));

       if(!ok) return false;

       command = rem.captured(2).toInt(&ok);

       if(!ok) return false;

       Command  real_cmd;

       switch(seat_no)
       {
           case 1:
               if(!seat1_commands.contains(command)) return false;
               real_cmd = seat1_commands.value(command);
           break;
           case 2:
               if(!seat2_commands.contains(command)) return false;
               real_cmd = seat2_commands.value(command);
           break;
           case 3:
               if(!seat3_commands.contains(command)) return false;
               real_cmd = seat3_commands.value(command);
           break;
           case 4:
               if(!seat4_commands.contains(command)) return false;
               real_cmd = seat4_commands.value(command);
           break;
           default:
           return false;

       }


       return commandExecuter(seat_no,real_cmd);

    }
    return false;
}

bool SeatController::commandExecuter(uint seat_no, Command command)
{

    Command lastCmd = m_last;
    m_last = command;
    switch(m_last)
    {
    case Command::HeadUp:
        return this->cmdHeadUp(seat_no);
    case Command::HeadDown:
        return this->cmdHeadDown(seat_no);
    case Command::BackForward:
        return this->cmdBackForward(seat_no);
    case Command::BackBackward:
        return this->cmdBackBackward(seat_no);
    case Command::ThighUp:
        return this->cmdFrontThightUp(seat_no);
    case Command::ThighDown:
        return this->cmdFrontThightDown(seat_no);
    case Command::SeatForward:
        return this->cmdSeatForward(seat_no);
    case Command::SeatBackward:
        return this->cmdSeatBackward(seat_no);
    case Command::SeatFeedback:
        return this->cmdSeatFeedback(seat_no);
    case Command::increaseHeating:
        return this->increaseHeating(seat_no);
    case Command::increaseCooling:
        return this->increaseCooling(seat_no);
    case Command::footRestUp:
        return this->cmdFootrestUp(seat_no);
    case Command::footRestDown:
        return this->cmdFootrestDown(seat_no);
    case Command::MassageOnOff:
        return this->closeMassage(seat_no);
    case Command::MassageMode:
        return this->changeMassageMode(seat_no);
    case Command::tableOpen:
        return this->cmdTableOpen(seat_no);
    case Command::tableClose:
        return this->cmdTableClose(seat_no);
    case Command::curtainOpen:
        return this->cmdCurtainOpen(seat_no);
    case Command::curtainClose:
        return this->cmdCurtainClose(seat_no);
    case Command::DrawerOpen:
        return this->cmdDrawerOpen(seat_no);
    case Command::DrawerClose:
        return this->cmdDrawerClose(seat_no);
    case Command::commandStopper1:
        return this->commandStopper(seat_no);
    case Command::commandStopper2:
        return this->commandStopper(seat_no);
    default:
        m_last = lastCmd;
    }
    return false;
}

bool SeatController::commandStopper(uint p_seatno)
{
   emit newLog(QString("Seat %1 command stop").arg(p_seatno));
   return false;
}

QStringList SeatController::getPatterns()
{
   return m_paternList;
}

QString SeatController::getFeedback()
{
   return this->m_feedback;
}
