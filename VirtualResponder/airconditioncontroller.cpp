#include "airconditioncontroller.h"
using namespace ai;

void AirconditionController::fillSeatCommands(QSettings *p_proto)
{
    int command;
    QMap<int,Command> *commandMap;

    commandMap = &m_cancommand_map;
    command = extractCommand(p_proto->value(QString("controls/%2").arg("can_ai_degree_down")).toString());
    commandMap->insert(command,Command::decreaseDeg);
    command = extractCommand(p_proto->value(QString("controls/%2").arg("can_ai_degree_up")).toString());
    commandMap->insert(command,Command::increaseDeg);
    command = extractCommand(p_proto->value(QString("controls/%2").arg("can_ai_fan_up")).toString());
    commandMap->insert(command,Command::increaseFan);
    command = extractCommand(p_proto->value(QString("controls/%2").arg("can_ai_fan_down")).toString());
    commandMap->insert(command,Command::decreaseFan);


    commandMap = &m_mbcommand_map;
    command = extractCommand(p_proto->value(QString("controls/%2").arg("modbus_ai_degree_down")).toString());
    commandMap->insert(command,Command::decreaseDeg);
    command = extractCommand(p_proto->value(QString("controls/%2").arg("modbus_ai_degree_up")).toString());
    commandMap->insert(command,Command::increaseDeg);
    command = extractCommand(p_proto->value(QString("controls/%2").arg("modbus_ai_fan_up")).toString());
    commandMap->insert(command,Command::increaseFan);
    command = extractCommand(p_proto->value(QString("controls/%2").arg("modbus_ai_fan_down")).toString());
    commandMap->insert(command,Command::decreaseFan);

}

AirconditionController::AirconditionController(QSettings * p_proto,QObject *parent):IFHandler(parent)
{

    m_cat_can = p_proto->value("controls/aircondition_cat_can").toString().toUInt();
    m_cat_modbus = p_proto->value("controls/aircondition_cat_modbus").toString().toUInt();
    m_cat_fb = p_proto->value("feedbacks/aircondition").toUInt();
    m_fb_request_can = p_proto->value("controls/can_ai_feedback").toString();
    m_fb_request_modbus = p_proto->value("controls/modbus_ai_feedback").toString();
    m_paternList<<QString("^(%1|%2)/(\\d+)$").arg(m_cat_can).arg(m_cat_modbus);
    fillSeatCommands(p_proto);
}

bool AirconditionController::messageHandler(QString p_message)
{

    QRegularExpression re(m_paternList[0]);
    QRegularExpressionMatch rem = re.match(p_message);
    if(rem.hasMatch())
    {
       bool ok;
       uint ctype = rem.captured(1).toUInt(&ok);
       if(ok == false)
       {
           return false;
       }

       int command = rem.captured(2).toInt(&ok);

       Command real_cmd;


       if(p_message.compare(m_fb_request_can)==0 || p_message.compare(m_fb_request_modbus) == 0)
       {
            return cmd_feedback();
       }
       if(ctype == m_cat_can)
       {
                if(!m_cancommand_map.contains(command))
                {
                    return false;
                }
                real_cmd = m_cancommand_map.value(command);
                return commandExecuter(real_cmd);
       }
       if(ctype == m_cat_modbus)
       {
                if(!m_cancommand_map.contains(command))
                {
                    return false;
                }
                real_cmd = m_mbcommand_map.value(command);
                return commandExecuter(real_cmd);
       }
    }
    return false;
}

QStringList AirconditionController::getPatterns()
{
    return m_paternList;
}

QString AirconditionController::getFeedback()
{
    cmd_feedback();
    return m_feedback;
}

bool AirconditionController::commandExecuter(Command p_command)
{
    Command lastCmd = p_command;
    switch(lastCmd)
    {
        case Command::increaseDeg:
            return cmd_increaseDeg();
        case Command::decreaseDeg:
            return cmd_decreaseDeg();
        case Command::increaseFan:
            return cmd_increaseFan();
        case Command::decreaseFan:
            return cmd_decreaseFan();
    }
    return false;

}
/*
bool AirconditionController::modbusCommandExecuter(uint p_command)
{
    ModbusCommand lastCmd;
    try{
        lastCmd = static_cast<ModbusCommand>(p_command);
    }catch(...)
    {
       return false;
    }
    switch(lastCmd)
    {
        case ModbusCommand::increaseDeg:
            return cmd_increaseDeg();
        case ModbusCommand::decreaseDeg:
            return cmd_decreaseDeg();
        case ModbusCommand::increaseFan:
            return cmd_increaseFan();
        case ModbusCommand::decreaseFan:
            return cmd_decreaseFan();
    }
    return false;

}
*/

bool AirconditionController::cmd_increaseDeg()
{
        if(m_state.temp + 1 == 30)
        {
            return false;
        }else{
           m_state.temp++;
        }
        emit newLog(QString("Increase temperature to %1").arg(m_state.temp));
        return false;
}

bool AirconditionController::cmd_decreaseDeg()
{
        if(m_state.temp - 1 == 14)
        {
            return false;
        }else{
           m_state.temp--;
        }
        emit newLog(QString("Decrease temperature to %1").arg(m_state.temp));
        return false;

}

bool AirconditionController::cmd_increaseFan()
{
    if(m_state.type == 1)
    {
        if(m_state.fan + 1 == 8)
        {
            emit newLog(QString("Fan state is at HI"));
            return false;
        }else{
           m_state.fan++;
        }

    }else if(m_state.type == 2)
    {
        if(m_state.fan + 1 == 6)
        {
        emit newLog(QString("Fan state is at HI"));
            return false;
        }else{
           m_state.fan++;
        }

    }
    emit newLog(QString("Fan state is Increased at %1").arg(m_state.fan));
    return false;

}

bool AirconditionController::cmd_decreaseFan()
{
    if(m_state.type == 1)
    {
        if(m_state.fan  == 0)
        {
            emit newLog(QString("Fan state is at LOW"));
            return true;
        }else{
           m_state.fan--;
        }

    }else if(m_state.type == 2)
    {
        if(m_state.fan  == 0)
        {
            emit newLog(QString("Fan state is at LOW"));
            return true;
        }else{
           m_state.fan--;
        }
    }
            emit newLog(QString("Fan state is decreased at %1").arg(m_state.fan));
    return false;
}

bool AirconditionController::cmd_feedback()
{
    QString deg;
    if(m_state.temp == 29)
    {
       deg = "HI";
    }else if(m_state.temp == 15)
    {
       deg = "LO";
    }else{
       deg = QString("%1").arg(m_state.temp);
    }
    m_feedback = QString("%1/%2/%3/%4").arg(m_cat_fb).arg(uint(m_state.open)).arg(m_state.fan).arg(deg);
    emit newLog(QString("Feedback is sending"));
    return true;
}
