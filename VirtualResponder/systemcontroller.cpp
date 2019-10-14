#include "systemcontroller.h"

void SystemController::prepareFeedback()
{
    m_feedback = QString("%1/%2").arg(m_system_fb).arg(m_state);
}

SystemController::SystemController(QSettings *p_proto, QObject *parent):IFHandler (parent)
{

    m_fb_request_system = p_proto->value("main/system_request").toString();
    m_onoff_request = p_proto->value("main/system_onoff").toString();
    bool ok;
    m_system_fb = p_proto->value("feedbacks/system").toInt(&ok);
    if(ok==false){
        m_system_fb = 41;
    }
    m_paternList<<QString("^%1$").arg(m_fb_request_system)<<QString("^%1$").arg(m_onoff_request);
}

bool SystemController::messageHandler(QString p_message)
{
    if(p_message.compare(m_onoff_request) == 0)
    {
       m_state=m_state?false:true;

    }

    prepareFeedback();
    //her zaman feedback gönderiyoruz
    emit newLog(QString("System Feedback is sending"));
    return true;
}

QStringList SystemController::getPatterns()
{
    return m_paternList;
}

QString SystemController::getFeedback()
{
    return m_feedback;
}

void SystemController::changeonoff(bool p_state)
{
   m_state  = p_state;
   prepareFeedback();
   emit newLog(QString("Manual Feedback is ready"));
}
