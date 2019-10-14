#include "voiceprotohandler.h"
using namespace voice;

VoiceProtoHandler::VoiceProtoHandler(QSettings * p_proto,QObject *parent) : QObject(parent)
{
    m_proto = p_proto;
}

bool VoiceProtoHandler::parseProto()
{
    m_proto->beginGroup("macros");
    QStringList keys = m_proto->childKeys();
    for(int i=0;i<keys.size();i++)
    {
            QString macroName = keys.at(i);
            QString macro = m_proto->value(macroName).toString();
            QStringList parts = macro.split(":");
            if(parts.size()<2)
            {
                qDebug()<<"Invalid macro size. Macro Name : "+macroName;
                continue;
            }
            bool ok;
            int id = parts[0].toInt(&ok);
            if(ok == false) continue;
            int enable = parts[1].toInt(&ok);
            if(ok == false) continue;
            CommandPack *cp = new CommandPack();
            cp->name = macroName;

            if(enable==0)
            {
//                qDebug()<<"Disabled Macro Name :"<<macroName<<endl;
                m_commandMap.insert(id,cp);
                continue;
            }

            int checkSize = parts.length() - 2;
            if(checkSize%2 != 0)
            {
                qDebug()<<"Incomplete Macro Name :"<<macroName<<endl;
                m_commandMap.insert(id,cp);
                continue;
            }
            int commandSize = checkSize/2;
            cp->enabled = true;
            QList<CommandObj *> * c_list = new QList<CommandObj *>();
            for(int j=0;j<commandSize;j++)
            {
               CommandObj * co = new CommandObj();
               commandType type = voice::stringToType(parts[j*2 + 2]);
               if(type == commandType::Invalid) continue;
               co->type = type;
               QString parstr = parts[j*2 + 3];
               if(!parstr.isEmpty() && parstr.compare("null") != 0)
               {
                   co->params = parstr.split(",");
               }
               c_list->append(co);
            }
            if(!c_list->empty())
            {
                cp->commands = c_list;
            }else{
                delete c_list;
            }
            m_commandMap.insert(id,cp);

    }
    m_proto->endGroup();

    return true;
}

bool VoiceProtoHandler::sendVoiceCommand(int id)
{
    if(!m_commandMap.contains(id))
    {
        qDebug()<<"voice command id not found "<<id;
        return false;
    }
    CommandPack * cpack = m_commandMap.value(id);
    if(cpack->enabled==0)
    {
        qDebug()<<"trying to run pasive macro. Name : "<<cpack->name<<endl;
        return false;
    }
    if(cpack->commands == nullptr)
    {
        qDebug()<<"No commands : "<<cpack->name<<endl;
        return false;

    }
    foreach(CommandObj * obj ,*cpack->commands)
    {
        switch(obj->type)
        {
        case commandType::Key:
            if(obj->params.length()==1)
            {
                emit sendKey(obj->params[0]);
                continue;
            }else{
               qDebug()<<"Wrong usage : "<<cpack->name<<endl;
               return false;
            }
            break;
        case commandType::Code:
            if(obj->params.length()==1)
            {
                emit sendCode(obj->params[0]);
                continue;
            }else{
               qDebug()<<"Wrong usage : "<<cpack->name<<endl;
               return false;
            }
            break;
        case commandType::Wait_key:
            if(obj->params.length()!=1)
            {
               qDebug()<<"Wrong usage : "<<cpack->name<<endl;
               return false;
            }else{
                QString waitkey = obj->params[0];
                bool ok;
                int delay = m_proto->value(QString("macro_variables/%1").arg(waitkey)).toInt(&ok);
                if(!ok || delay < 0)
                {
                       qDebug()<<"waitkey not found"<<cpack->name<<endl;
                       return false;
                }
                emit needDelay(delay);
                continue;
            }

            break;
        case commandType::Wait:
            if(obj->params.length()!=1)
            {
               qDebug()<<"Wrong usage : "<<cpack->name<<endl;
               return false;
            }else{
                QString waitvalue = obj->params[0];
                bool ok;
                int delay = waitvalue.toInt(&ok);
                if(!ok || delay < 0)
                {
                       qDebug()<<"waitvalue not found"<<cpack->name<<endl;
                       return false;
                }
                emit needDelay(delay);
                continue;
            }
            break;
        case commandType::Function:
            if(obj->params.length()!=1)
            {
               qDebug()<<"Wrong usage : "<<cpack->name<<endl;
               return false;
            }
                QString functionname = obj->params[0];
                emit runFunction(functionname);
                continue;
            break;
                /*
        case commandType::Invalid:
            break;
            */
        }
    }


    return true;
}

VoiceProtoHandler::~VoiceProtoHandler()
{
   qDeleteAll(m_commandMap);
   m_commandMap.clear();
}


commandType voice::stringToType(QString p_type)
{
    if(!p_type.compare("key"))
    {
        return commandType::Key;
    }
    if(!p_type.compare("code"))
    {
        return commandType::Code;
    }
    if(!p_type.compare("wait"))
    {
        return commandType::Wait;
    }
    if(!p_type.compare("wait_key"))
    {
        return commandType::Wait_key;
    }
    if(!p_type.compare("function"))
    {
        return commandType::Function;
    }
    return commandType::Invalid;

}
