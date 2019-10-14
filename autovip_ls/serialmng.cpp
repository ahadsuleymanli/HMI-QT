#include "serialmng.h"
#include <QGuiApplication>
#include <QDir>
using namespace voice;

SerialMng::SerialMng(QObject *parent) : QObject(parent)
{

   this->m_serial = new QSerialPort(this);

   //connect(m_serial,&QSerialPort::bytesWritten,this,&SerialMng::handleBytesWritten);
   connect(m_serial,&QSerialPort::readyRead,this,&SerialMng::newMessage);
//   connect(m_serial, &QSerialPort::errorOccurred, this, &SerialMng::handleError);
   connect(m_serial, &QSerialPort::close,this,&SerialMng::handleClose);

   QString protofile = QString("%1/%2").arg(QDir::currentPath()).arg("proto.ini");

   m_proto = new QSettings(protofile,QSettings::IniFormat);
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

   m_fb_ceiling_light = m_proto->value("feedbacks/ceiling_light").toString();
   m_fb_side_light = m_proto->value("feedbacks/side_light").toString();
   m_fb_inside_light = m_proto->value("feedbacks/inside_light").toString();

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

uint SerialMng::heat()
{
   return m_heat;
}

uint SerialMng::cool()
{
   return m_cool;
}

bool SerialMng::massageon()
{
   return m_massageon;
}

uint SerialMng::massagemode()
{
    return m_massagemod;
}

QColor SerialMng::ceilingcolor()
{
   return m_ceilingcolor;
}

QColor SerialMng::insidecolor()
{
   return m_insidecolor;
}

QColor SerialMng::sidecolor()
{
   return m_sidecolor;
}

void SerialMng::setSystemstate(int p_state)
{
    if(m_systemstate == p_state) return;
   m_systemstate = p_state;
   emit systemstateChanged(m_systemstate);
}

void SerialMng::setHeat(uint p_h)
{
    if(p_h == m_heat) return;
            m_heat = p_h;
            emit heatChanged(m_heat);
}

void SerialMng::setCool(uint p_c)
{
    if(p_c == m_cool) return;
    m_cool = p_c;
    emit coolChanged(p_c);

}

void SerialMng::setMassageon(bool p_o)
{
    if(p_o == m_massageon) return;
    m_massageon = p_o;
    emit massageonChanged(p_o);

}

void SerialMng::setMassagemod(uint p_mm)
{
    if(p_mm == m_massagemod) return;
    m_massagemod = p_mm;
    emit massagemodChanged(p_mm);

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



}

bool SerialMng::parserAircondition(QString p_response)
{
    bool found = false;
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
    m_proto->endGroup();
    QRegularExpressionMatch mt = reg.match(p_response);
    if(mt.hasMatch())
    {
        SeatState tst;
        tst.m_cool = mt.captured(4).toUInt();
        tst.m_heat = mt.captured(5).toUInt();
        tst.m_massagemode = mt.captured(3).toUInt();
        tst.m_massageon = mt.captured(2).toUInt();

        uint seatno = mt.captured(1).toUInt();
        setCool(tst.m_cool);
        setHeat(tst.m_heat);
        setMassageon(tst.m_massageon == 0?false:true);
        setMassagemod(tst.m_massagemode);
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



void SerialMng::write(const QByteArray &writeData)
{
    qDebug()<<writeData<<endl;
    this->m_writeData = writeData;
    this->m_serial->write(m_writeData);
    m_serial->flush();
    this->m_lastsend = QTime::currentTime();
}

void SerialMng::sendKey(const QString &key,bool wait,int p_delay,QString param)
{
   if(!this->m_serial->isOpen()) return;
   QString realCode = m_proto->value(key).toString();
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
    this->parseFeedback(readData);
}

void SerialMng::handleTimeout()
{

}

void SerialMng::handleError(QSerialPort::SerialPortError error)
{
    qDebug()<<"Serial Connection Error "<<error<<endl;
}

void SerialMng::handleClose()
{
    if(this->m_connected != false)
    {
        emit connectionChanged(false);
    }
    this->m_connected = false;

}
