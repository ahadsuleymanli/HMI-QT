#include "serialmng.h"
#include <QGuiApplication>
#include <QDir>
#include <iostream>
using namespace voice;
#include "serialmessagescheduler.h"
SerialMng::SerialMng(QObject *parent) : QObject(parent)
{

   this->m_serial = new QSerialPort(this);

   //connect(m_serial,&QSerialPort::bytesWritten,this,&SerialMng::handleBytesWritten);
   connect(m_serial,&QSerialPort::readyRead,this,&SerialMng::newMessage);
//   connect(m_serial, &QSerialPort::errorOccurred, this, &SerialMng::handleError);
//   connect(m_serial, &QSerialPort::close,this,&SerialMng::handleClose);

   QString pathToProto = QString("%1/%2").arg(QDir::currentPath()).arg("proto.ini");
   QString pathToProtoOverride = QString("%1/%2").arg(QDir::currentPath()).arg("proto_override.ini");
   m_proto = new OverridableQSettings(pathToProto,pathToProtoOverride,this);
   m_voicehandler = new VoiceProtoHandler(m_proto,this);
   connect(m_voicehandler,&VoiceProtoHandler::needDelay,this,&SerialMng::needDelay);
   connect(m_voicehandler,&VoiceProtoHandler::runFunction,this,&SerialMng::runFunction);
   connect(m_voicehandler,&VoiceProtoHandler::sendKey,this,&SerialMng::voiceSendKey);
   connect(m_voicehandler,&VoiceProtoHandler::sendCode,this,&SerialMng::voiceSendCode);

   m_voicehandler->parseProto();
   m_lstart = m_proto->value("main/start_code").toString();
   m_lend = m_proto->value("main/end_code").toString();
   m_fbstart = m_proto->value("feedbacks/start_code").toString();
   m_fbend = m_proto->value("feedbacks/end_code").toString();
   m_fb_aircondition = m_proto->value("feedbacks/aircondition").toString();
   m_fb_sound_control = m_proto->value("feedbacks/sound_control").toString();
   radio_feedback = m_proto->value("radio/feedback").toString();
   m_fb_ceiling_light = m_proto->value("feedbacks/ceiling_light").toString();
   m_fb_side_light = m_proto->value("feedbacks/side_light").toString();
   m_fb_inside_light = m_proto->value("feedbacks/inside_light").toString();
   m_fb_ambient_light = m_proto->value("feedbacks/ambient_light").toString();
   m_fb_first_seat = m_proto->value("feedbacks/first_seat").toString();
   m_fb_second_seat = m_proto->value("feedbacks/second_seat").toString();
   m_fb_third_seat = m_proto->value("feedbacks/third_seat").toString();
   m_fb_fourth_seat = m_proto->value("feedbacks/fourth_seat").toString();
   m_fb_system = m_proto->value("feedbacks/system").toString();
   bool ok;
   m_wait = m_proto->value("main/delay").toInt(&ok);
   if(!ok) { m_wait = 300; }
   m_appletvdelay = m_proto->value("apple_tv/delay").toInt(&ok);
   if(!ok || m_appletvdelay < -1)
   {
      m_appletvdelay = -1;
   }
   m_samsungdelay = m_proto->value("samsung_tv/delay").toInt(&ok);
   if(!ok || m_samsungdelay < -1)
   {
      m_samsungdelay = -1;
   }
   m_lgdelay = m_proto->value("lg_tv/delay").toInt(&ok);
   if(!ok || m_lgdelay < -1)
   {
      m_lgdelay = -1;
   }
   m_dividedelay = m_proto->value("media/delay_divide").toInt(&ok);
   if(!ok || m_dividedelay < -1)
   {
      m_dividedelay = -1;
   }
   m_dvddelay = m_proto->value("dvdplayer/delay").toInt(&ok);
   if(!ok || m_dvddelay < -1)
   {
      m_dvddelay = -1;
   }
   m_dvdsourcedelay = m_proto->value("dvdplayer/source_delay").toInt(&ok);
   if(!ok || m_dvdsourcedelay < -1)
   {
      m_dvdsourcedelay = -1;
   }


   m_lightsdelay = m_proto->value("lights/request_delay").toInt(&ok);
   if(!ok || m_lightsdelay < -1)
   {
      m_lightsdelay = -1;
   }

   m_lastsend = QTime::currentTime();
   serialScheduler = new SerialScheduler(this);
}

QStringList PROTO_SEAT_GROUP_NAMES = {"first_seat", "second_seat", "third_seat", "fourth_seat"};

void SerialMng::loadPositionPreset(int seat_no, int saveSlot){
    if (seat_no>0 && seat_no-1<PROTO_SEAT_GROUP_NAMES.size()){
        sendKey(PROTO_SEAT_GROUP_NAMES[seat_no-1] + "/mem" + QString::number(saveSlot));
    }
}

void SerialMng::savePositionPreset(int seat_no, int saveSlot){
    if (seat_no>0 && seat_no-1<PROTO_SEAT_GROUP_NAMES.size()){
        sendKey(PROTO_SEAT_GROUP_NAMES[seat_no-1] + "/mem_m" + QString::number(saveSlot));
    }
}

bool SerialMng::isConnected()
{
    bool st = this->m_serial->isOpen();
            if(st != this->m_connected)
            {
                emit connectionChanged(st);
                this->m_connected = st;
            }
            return this->m_connected;
}

bool SerialMng::sendVoiceCommandById(int id)
{
    if(m_voicehandler == nullptr)
    {
        return false;
    }
    return m_voicehandler->sendVoiceCommand(id);
}

void SerialMng::openSerialPort()
{
    if (m_serial->open(QIODevice::ReadWrite)) {
        if(m_connected == false)
        {
            emit connectionChanged(true);
        }
        m_connected = true;
    } else {
        if(m_connected == true )
        {
            emit connectionChanged(false);
        }
        m_connected = false;
    }

}

void SerialMng::closeSerialPort()
{
    if(m_serial->isOpen())
    {
       m_serial->close();
    }
}

bool SerialMng::setPortName(QString str)
{
    this->m_serial->setPortName(str);
    return true;
}

bool SerialMng::setBaudRate(int val)
{
    switch(val)
    {
        case 1200:
            this->m_serial->setBaudRate(QSerialPort::Baud1200);
        break;
        case 2400:
            this->m_serial->setBaudRate(QSerialPort::Baud2400) ;
        break;
        case 4800:
            this->m_serial->setBaudRate(QSerialPort::Baud4800) ;
        break;
        case 9600:
            this->m_serial->setBaudRate(QSerialPort::Baud9600);
        break;
        case 19200:
            this->m_serial->setBaudRate(QSerialPort::Baud19200) ;
        break;
        case 38400:
            this->m_serial->setBaudRate(QSerialPort::Baud38400) ;
        break;
        case 57600:
            this->m_serial->setBaudRate(QSerialPort::Baud57600) ;
        break;
        case 115200:
            this->m_serial->setBaudRate(QSerialPort::Baud115200) ;
        break;
        default:
            this->m_serial->setBaudRate(QSerialPort::Baud9600);
        break;
    }

    return true;
}

bool SerialMng::setDataBits(int val)
{
    switch (val) {
        case QSerialPort::Data5:
            this->m_serial->setDataBits(QSerialPort::Data5);
        break;
        case  6:
            this->m_serial->setDataBits(QSerialPort::Data6);
        break;
        case 7:
            this->m_serial->setDataBits(QSerialPort::Data7);
        break;
        case 8:
            this->m_serial->setDataBits(QSerialPort::Data8);
        break;
        default:
            this->m_serial->setDataBits(QSerialPort::Data5);
        break;
    }
    return true;
}

bool SerialMng::setParity(int val)
{
    switch(val)
    {
        case 0:
            this->m_serial->setParity(QSerialPort::NoParity);
            break;
        case 2:
            this->m_serial->setParity(QSerialPort::EvenParity);
            break;
        case 3:
            this->m_serial->setParity(QSerialPort::OddParity);
            break;
        case 4:
            this->m_serial->setParity(QSerialPort::SpaceParity);
            break;
        case 5:
            this->m_serial->setParity(QSerialPort::MarkParity);
            break;
        default:
            this->m_serial->setParity(QSerialPort::NoParity);
            break;
    }
    return true;
}

bool SerialMng::setStopBits(int val)
{
    switch (val) {
    case 1:
        this->m_serial->setStopBits(QSerialPort::OneStop);
        break;
    case 2:
        this->m_serial->setStopBits(QSerialPort::TwoStop);
        break;
    case 3:
        this->m_serial->setStopBits(QSerialPort::OneAndHalfStop);
        break;
    default:
        this->m_serial->setStopBits(QSerialPort::OneStop);
        break;
    }
    return  true;
}

bool SerialMng::setFlowControl(int val)
{

    switch(val)
    {
        case 0:
        this->m_serial->setFlowControl(QSerialPort::NoFlowControl);
        break;
        case 1:
        this->m_serial->setFlowControl(QSerialPort::HardwareControl);
        break;
        case 2:
        this->m_serial->setFlowControl(QSerialPort::SoftwareControl);
        break;
        default:
        this->m_serial->setFlowControl(QSerialPort::NoFlowControl);
        break;
      }
    return true;
}

void SerialMng::setDemomode(bool p_mode)
{
   m_demomode  = p_mode;
}

int SerialMng::fandeg()
{
    return this->m_fandeg;
}

int SerialMng::acdeg()
{
    return this->m_acdeg;
}

int SerialMng::systemstate()
{
    return m_systemstate;
}

bool SerialMng::acopen()
{
    return this->m_acopen;
}

QColor SerialMng::ceilingcolor()
{
   return m_ceilingcolor;
}

QColor SerialMng::insidecolor()
{
   return m_insidecolor;
}

QColor SerialMng::ambientcolor()
{
   return m_ambientcolor;
}

QColor SerialMng::sidecolor()
{
    return m_sidecolor;
}

int SerialMng::volume()
{
    return m_volume;
}

uint SerialMng::soundSource()
{
    return m_soundSource;
}

void SerialMng::setSystemstate(int p_state)
{
    if(m_systemstate == p_state) return;
   m_systemstate = p_state;
   emit systemstateChanged(m_systemstate);
}

void SerialMng::setVolume(int vol)
{
    if(m_volume == vol) return;
    m_volume = vol;
    emit volumeChanged(m_volume);
}


void SerialMng::setRadioFrequency(uint frequency)
{
    if(frequency == radioFrequency_uint) return;
    radioFrequency_uint = frequency;
    serialScheduler->sendKey("radio/set_frequency",QString::number(frequency));
//    sendKey("radio/set_frequency",false,-1,QString::number(frequency));
    emit radioFrequencyChanged();
}

void SerialMng::setCeilingcolor(QColor p_color)
{
    if(p_color != m_ceilingcolor)
    {
       m_ceilingcolor = p_color;
       emit ceilingcolorChanged(p_color);
    }

}

void SerialMng::setInsidecolor(QColor p_color)
{
    if(p_color != m_insidecolor)
    {
       m_insidecolor = p_color;
       emit insidecolorChanged(p_color);
    }

}
void SerialMng::setAmbientcolor(QColor p_color)
{
    if(p_color != m_ambientcolor)
    {
       m_ambientcolor = p_color;
       emit ambientcolorChanged(p_color);
    }

}

void SerialMng::setSidecolor(QColor p_color)
{
    if(p_color != m_sidecolor)
    {
       m_sidecolor = p_color;
       emit sidecolorChanged(p_color);
    }

}

SeatState SerialMng::firstseat()
{

    return m_firstseat;
}

SeatState SerialMng::secondseat()
{
    return m_secondseat;
}

SeatState SerialMng::thirdseat()
{
    return m_thirdseat;
}

SeatState SerialMng::fourthseat()
{
    return m_fourthseat;
}

qint32 SerialMng::getLightsDelay()
{
    return m_lightsdelay;
}

qint32 SerialMng::getLgDelay()
{
   return m_lgdelay;
}

qint32 SerialMng::getSamsungDelay()
{
   return m_samsungdelay;
}

qint32 SerialMng::getAppltvDelay()
{
    return m_appletvdelay;
}

qint32 SerialMng::getDivideDelay()
{
    return m_dividedelay;
}

qint32 SerialMng::getDvdDelay()
{
    return m_dvddelay;
}

qint32 SerialMng::getDvdSourceDelay()
{

    return m_dvdsourcedelay;
}

void SerialMng::setFirstseat(SeatState p_s)
{
    SeatState & st = m_firstseat;
   if(p_s.m_cool == st.m_cool
           &&
           p_s.m_heat == st.m_heat
           &&
           p_s.m_massageon == st.m_massageon
           &&
           p_s.m_massagemode == st.m_massagemode
           )

   {
       return;
   }
   this->m_firstseat = p_s;
   emit firstseatChanged(st);
}

void SerialMng::setSecondseat(SeatState p_s)
{
    SeatState & st = m_secondseat;
   if(p_s.m_cool == st.m_cool
           &&
           p_s.m_heat == st.m_heat
           &&
           p_s.m_massageon == st.m_massageon
           &&
           p_s.m_massagemode == st.m_massagemode
           )

   {
       return;
   }
   this->m_secondseat = p_s;
   emit secondseatChanged(st);

}

void SerialMng::setThirdseat(SeatState p_s)
{

   SeatState & st = m_thirdseat;
   if(p_s.m_cool == st.m_cool
           &&
           p_s.m_heat == st.m_heat
           &&
           p_s.m_massageon == st.m_massageon
           &&
           p_s.m_massagemode == st.m_massagemode
           )

   {
       return;
   }
   st = p_s;
   emit thirdseatChanged(st);
}

void SerialMng::setFourthseat(SeatState p_s)
{

   SeatState & st = m_fourthseat;
   if(p_s.m_cool == st.m_cool
           &&
           p_s.m_heat == st.m_heat
           &&
           p_s.m_massageon == st.m_massageon
           &&
           p_s.m_massagemode == st.m_massagemode
           )

   {
       return;
   }
   st = p_s;
   emit fourthseatChanged(st);
}

void SerialMng::setFandeg(int val)
{
    if(this->m_fandeg != val)
    {
       this->m_fandeg = val;
        emit fandegChanged(val);
    }
}

void SerialMng::setACDeg(int val)
{
   if(this->m_acdeg != val)
   {
      this->m_acdeg = val;
      emit acdegChanged(val);
   }
}

void SerialMng::setACOpen(bool val)
{
   if(this->m_acopen != val)
   {
       this->m_acdeg = val;
       emit acopenChanged(val);
   }
}

void SerialMng::parseFeedback(QString response)
{
    bool found = false;

    if(!m_fbstart.isEmpty())
    {
       if(!response.startsWith(m_fbstart))  return;
       response.remove(0,m_fbstart.length());
    }

    if(!m_fbend.isEmpty())
    {
       if(!response.endsWith(m_fbend))  return;
       response.remove(response.length()-m_fbend.length(),m_fbend.length());
    }

    found = parserSystem(response);
    if(found) { return; }
    found = parserAircondition(response);
    if(found) { return; }
    found = parserSeats(response);
    if(found) { return; }
    found = parserInsideLight(response);
    if(found) { return; }
    found = parserSideLight(response);
    if(found) { return; }
    found = parserCeilingLight(response);
    if(found) { return; }
    found = parserAmbientLight(response);
    if(found) { return; }
    found = parserSoundControl(response);
    if(found) { return; }
    found = parserRadioControl(response);
    if(found) { return; }
}

bool SerialMng::parserAircondition(QString p_response)
{
    bool found = false;
    if (m_fb_aircondition=="") return false;
    found = p_response.startsWith(m_fb_aircondition);
    if(found)
    {
        QStringList parts = p_response.split("/");
        bool ok;
        if(parts.length()!=4)
        {
            //error
            return false;
        }
        bool isOpen = parts[1].toInt(&ok);
        if(ok)
        {
           this->setACOpen(isOpen);
        }else{
            //error
            return false;
        }
        int fd = parts[2].toInt(&ok);
        if(ok)
        {
           this->setFandeg(fd);
        }else{
           //error
            return false;
        }
        int tacdeg = parts[3].toInt(&ok);
        if(ok)
        {
           this->setACDeg(tacdeg);
        }else{
            if(parts[3].compare("HI") == 0)
            {
                    this->setACDeg(29);
                return true;
            }
            if(parts[3].compare("LO") == 0)
            {
                    this->setACDeg(15);
                    return true;
            }

            return false;
        }
        return true;
    }

    return false;
}

bool SerialMng::parserFirstSeat(QString p_response)
{

    bool found = false;
    return found;
}

bool SerialMng::parserSeats(QString p_response)
{

    m_proto->beginGroup("feedbacks");
    QRegularExpression reg(
                QString("(%1|%2|%3|%4)/([0-9]+)/([0-9]+)/([0-9]+)/([0-9]+)")
                .arg(m_proto->value("first_seat").toString())
                .arg(m_proto->value("second_seat").toString())
                .arg(m_proto->value("third_seat").toString())
                .arg(m_proto->value("fourth_seat").toString())
                );
    int seatIndexes[4] = {m_proto->value("first_seat").toInt(),m_proto->value("second_seat").toInt(),m_proto->value("third_seat").toInt(),m_proto->value("fourth_seat").toInt()};
    m_proto->endGroup();
    QRegularExpressionMatch mt = reg.match(p_response);
    if(mt.hasMatch())
    {
        int seatno = mt.captured(1).toInt();
        int index = std::distance(seatIndexes, std::find(seatIndexes, seatIndexes + 4, seatno));
        seats_massage[index]= mt.captured(2).toUInt()==0?false:true;
        seats_massageMode[index]= mt.captured(3).toUInt();
        seats_cooling[index]= mt.captured(4).toUInt();
        seats_heating[index]= mt.captured(5).toUInt();
        emit massageonChanged(0);
        emit massagemodChanged(0);
        emit coolChanged(0);
        emit heatChanged(0);
        return true;
    }
    return false;
}

bool SerialMng::parserSecondSeat(QString p_response)
{

    return false;
}

bool SerialMng::parserThirdSeat(QString p_response)
{

    return false;
}

bool SerialMng::parserFourthSeat(QString p_response)
{

    return false;
}

bool SerialMng::parserSystem(QString p_response)
{
    bool found = false;
    if (m_fb_system=="") return false;
    found = p_response.startsWith(m_fb_system);
    if(found)
    {
        QStringList parts = p_response.split("/");
        if(parts.length() != 2)
        {
            return false;
        }
        bool ok;
        int result = parts[1].toInt(&ok);
        if(!ok && result <0 && result > 1) return false;
        this->setSystemstate(result);
        return true;

    }

    return false;
}

bool SerialMng::parserSideLight(QString p_response)
{
    bool found = false;
    if (m_fb_side_light=="") return false;
    found = p_response.startsWith(m_fb_side_light);
    QColor vsidecolor;
    if(found)
    {
        QStringList parts = p_response.split("/");
        bool ok;
        if(parts.length()!=4)
        {
            //error
            return false;
        }
        int red = parts[1].toInt(&ok);
        if(ok)
        {
           vsidecolor.setRed(red);
        }else{
            //error
            return false;
        }
        int green = parts[2].toInt(&ok);
        if(ok)
        {
            vsidecolor.setGreen(green);
        }else{
           //error
            return false;
        }
        int blue = parts[3].toInt(&ok);
        if(ok)
        {
            vsidecolor.setBlue(blue);
        }else{
            //error
            return false;
        }
        setSidecolor(vsidecolor);
        return true;
    }

    return false;
}

bool SerialMng::parserInsideLight(QString p_response)
{
    bool found = false;
    if (m_fb_inside_light=="") return false;
    found = p_response.startsWith(m_fb_inside_light);
    QColor newcolor;
    if(found)
    {
        QStringList parts = p_response.split("/");
        bool ok;
        if(parts.length()!=4)
        {
            //error
            return false;
        }
        int red = parts[1].toInt(&ok);
        if(ok)
        {
           newcolor.setRed(red);
        }else{
            //error
            return false;
        }
        int green = parts[2].toInt(&ok);
        if(ok)
        {
            newcolor.setGreen(green);
        }else{
           //error
            return false;
        }
        int blue = parts[3].toInt(&ok);
        if(ok)
        {
            newcolor.setBlue(blue);
        }else{
            //error
            return false;
        }
        setInsidecolor(newcolor);
        return true;
    }

    return false;
}

bool SerialMng::parserCeilingLight(QString p_response)
{
    bool found = false;
    if (m_fb_ceiling_light=="") return false;
    found = p_response.startsWith(m_fb_ceiling_light);
    QColor newcolor;
    if(found)
    {
        QStringList parts = p_response.split("/");
        bool ok;
        if(parts.length()!=4)
        {
            //error
            return false;
        }
        int red = parts[1].toInt(&ok);
        if(ok)
        {
           newcolor.setRed(red);
        }else{
            //error
            return false;
        }
        int green = parts[2].toInt(&ok);
        if(ok)
        {
            newcolor.setGreen(green);
        }else{
           //error
            return false;
        }
        int blue = parts[3].toInt(&ok);
        if(ok)
        {
            newcolor.setBlue(blue);
        }else{
            //error
            return false;
        }
        setCeilingcolor(newcolor);
        return true;
    }

    return false;

}

bool SerialMng::parserAmbientLight(QString p_response)
{
    bool found = false;
    if (m_fb_ambient_light=="") return false;
    found = p_response.startsWith(m_fb_ambient_light);
    QColor newcolor;
    if(found)
    {
        QStringList parts = p_response.split("/");
        bool ok;
        if(parts.length()!=4)
        {
            //error
            return false;
        }
        int red = parts[1].toInt(&ok);
        if(ok)
        {
           newcolor.setRed(red);
        }else{
            //error
            return false;
        }
        int green = parts[2].toInt(&ok);
        if(ok)
        {
            newcolor.setGreen(green);
        }else{
           //error
            return false;
        }
        int blue = parts[3].toInt(&ok);
        if(ok)
        {
            newcolor.setBlue(blue);
        }else{
            //error
            return false;
        }
        setAmbientcolor(newcolor);
        return true;
    }

    return false;

}

bool SerialMng::parserSoundControl(QString p_response)
{
    bool found = false;
    found = p_response.startsWith(m_fb_sound_control);
    uint source=0, volume = 0;
    if(found)
    {

        QStringList parts = p_response.split("/");
        bool ok;
        if(parts.length()!=3)
        {
            //error
            return false;
        }
        source = parts[1].toUInt(&ok);
        if(!ok){
            //error
            return false;
        }
        volume = parts[2].toUInt(&ok) - 1;
        setVolume(volume);
        if(!ok)
        {
            return false;
        }
        if (source > 0 && source < 5 && m_soundSource != source){
            m_soundSource = source;
            emit soundSourceChanged(m_soundSource);
        }
        return true;
    }
    return false;
}
void SerialMng::sendSoundSource(uint source)
{
    qDebug()<<m_soundSource;
    if (source==m_soundSource)
        return;
    switch(source)
    {
        case 1:
            sendKey("controls/aux_source",true,100);
        break;
        case 2:
            sendKey("controls/optic_source",true,100);
        break;
        case 3:
            sendKey("controls/highlevel_source",true,100);
        break;
        case 4:
            sendKey("controls/bluetooth_source",true,100);
        break;
    }
}

void SerialMng::sendRadioOff(){
    if (radioVolume!=0)
        sendKey("radio/audio_off");
}

void SerialMng::sendRadioOn(){
    if (radioVolume!=15)
        sendKey("radio/audio_on");
}

bool SerialMng::parserRadioControl(QString p_response)
{
    if (radio_feedback=="") return false;
    if(p_response.startsWith(radio_feedback))
    {
        uint frequency_part1=0, frequency_part2 = 0;
        uint radioFrequency_uint = 0;
        uint radioVolume = 0;
        QStringList parts = p_response.split("/");
        bool ok;
        if(parts.length()!=4){
            return false;
        }
        radioVolume = parts[1].toUInt(&ok);
        if(!ok){
            return false;
        }
        this->radioVolume = radioVolume;
        frequency_part1 = parts[2].toUInt(&ok);
        if(!ok){
            return false;
        }
        frequency_part2 = parts[3].toUInt(&ok);
        if(!ok){
            return false;
        }
        radioFrequency_uint=frequency_part1+frequency_part2*256;
        if (this->radioFrequency_uint!=radioFrequency_uint){
            if (!(serialScheduler->queueHasntEnded())){
                this->radioFrequency_uint=radioFrequency_uint;
                radioFrequencyChanged();
            }
        }
        return true;
    }
    return false;
}


void SerialMng::write(const QByteArray &writeData)
{
    if (lastWriteData!=nullptr && lastWriteData == writeData){
        writeDataSpamCount ++;
    }
    else if (writeDataSpamCount){
        qDebug()<<writeData<<" . before this "<<lastWriteData<<" was repeated "<<writeDataSpamCount<<" time(s)";
        writeDataSpamCount = 0;
        lastWriteData = writeData;
    }
    else{
        qDebug()<<writeData<<"";
        lastWriteData = writeData;
    }
    this->m_writeData = writeData;
    this->m_serial->write(m_writeData);
    m_serial->flush();
    this->m_lastsend = QTime::currentTime();
}

void SerialMng::sendKey(const QString &key,bool wait,int p_delay,QString param)
{
   QString realCode = m_proto->value(key).toString();

   if(!this->m_serial->isOpen() && key!="main/system_request"){
        std::cout <<"key: " << key.toStdString()<<" "<<param.toStdString()<< "  real: " <<realCode.toStdString() << std::endl;
        return;
   }
   else if (!this->m_serial->isOpen()) return;

   bool command_arranged = false;
   if(realCode.isEmpty() || realCode.compare("no") == 0)
   {
       return;
   }
   if(!param.isEmpty())
   {
      realCode = QString("%1/%2").arg(realCode).arg(param);
   }
   QString message = QString("%1%2%3").arg(m_lstart).arg(realCode).arg(m_lend).toUtf8();
   int cur = QTime::currentTime().msecsSinceStartOfDay();
   int diff = m_last_arranged_cmd - cur;
   int delay = 0;
   if(diff > 0)
   {
           delay+=diff;
           QTimer::singleShot(diff,this,[=]{ this->write(message.toUtf8()); });
           command_arranged= true;
   }

   if(wait && p_delay > 0)
   {
        delay+= p_delay;
        m_last_arranged_cmd = cur + delay;
   }
   if(!command_arranged)
   {
        this->write(message.toUtf8());
   }

}

void SerialMng::voiceSendKey(QString key)
{
    this->sendKey(key);
}

void SerialMng::voiceSendCode(QString key)
{

}

void SerialMng::needDelay(int p_delay)
{
   int cur = QTime::currentTime().msecsSinceStartOfDay();
   int diff = m_last_arranged_cmd - cur;
   if(diff > 0)
   {
        m_last_arranged_cmd += p_delay;
   }else{
        m_last_arranged_cmd = cur + p_delay;
   }
}

/*
void SerialMng::runFunction(QString p_function_name)
{

}
*/

void SerialMng::handleBytesWritten(qint64 bytes)
{
    Q_UNUSED(bytes)
    QString readData = m_serial->readAll();
    if(readData.isEmpty()) return;
    //const QByteArray data = m_serial->readAll();
    //QString readData(data);
    this->parseFeedback(readData);
}

void SerialMng::newMessage()
{
    QString readData = m_serial->readAll();
//    std::cout << "Received Message: " << readData.toStdString() << std::endl;
    qDebug() << "Received Message: " << readData;
    this->parseFeedback(readData);
}

void SerialMng::handleTimeout()
{

}

void SerialMng::handleError(QSerialPort::SerialPortError error)
{
    qDebug()<<"Serial Connection Error "<<error<<"\n";
}

void SerialMng::handleClose()
{
    if(this->m_connected != false)
    {
        emit connectionChanged(false);
    }
    this->m_connected = false;

}
