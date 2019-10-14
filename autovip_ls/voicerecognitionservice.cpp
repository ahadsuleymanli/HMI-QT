#include "voicerecognitionservice.h"

void VoiceRecognitionService::setLang(int p)
{
    m_cont->setLang(Langs::E_Languages(p));
}

void VoiceRecognitionService::hvoiceCode(int p_code)
{
    if(m_busy != 1)
    {
        m_busy = 1;
        emit busyChanged(m_busy);
    }
    emit voiceCode(p_code);

}

void VoiceRecognitionService::hnotdetection(QString p_msg)
{
    if(m_busy != 1)
    {
        m_busy = 1;
        emit busyChanged(m_busy);
    }
    emit notdetected(p_msg);

}

void VoiceRecognitionService::handle_connectionChange(bool p_state)
{
    if(p_state == false && m_busy != -1)
    {
        m_busy = -1;
        emit busyChanged(m_busy);
    }else if(p_state == true && m_busy == -1)
    {
        m_busy = 1;
        emit busyChanged(m_busy);
    }

}

VoiceRecognitionService::VoiceRecognitionService( QObject *parent) : QObject(parent)
{
    m_cont = new WebsocketController(9000,this);
    QObject::connect(m_cont , &WebsocketController::notDetected, this , &VoiceRecognitionService::hnotdetection);
    QObject::connect(m_cont , &WebsocketController::voiceCode, this , &VoiceRecognitionService::hvoiceCode);
    QObject::connect(m_cont , &WebsocketController::stateChanged, this , &VoiceRecognitionService::handle_connectionChange);

}

void VoiceRecognitionService::openMic()
{
    if(m_busy!=1)
    {
        return;
    }else {
        m_busy = 0;
        emit busyChanged(m_busy);
    }
    m_cont->openMic();
}

void VoiceRecognitionService::closeMic()
{
    m_cont->closeMic();
}

int VoiceRecognitionService::busy()
{
   return m_busy;
}
