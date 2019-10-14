#include "serialmng.h"
#include <QDir>

SerialMng::SerialMng(QObject *parent) : QObject(parent)
{
    this->m_serial = new QSerialPort(this);
    QString protofile = QString("%1/%2").arg(QDir::currentPath()).arg("proto.ini");
    m_protocol = new QSettings(protofile,QSettings::IniFormat);
   connect(
               m_serial,
               &QSerialPort::readyRead,
               this,
               &SerialMng::read);
    connect(m_serial, &QSerialPort::errorOccurred,
            this, &SerialMng::handleError);
   m_begin = m_protocol->value("main/start_code").toString();
   m_end = m_protocol->value("main/end_code").toString();
   m_fb_begin = m_protocol->value("feedbacks/start_code").toString();
   m_fb_end = m_protocol->value("feedbacks/end_code").toString();

    //connect(m_serial, &QSerialPort::,this,&SerialMng::handleClose);
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

int SerialMng::fandeg()
{
    return this->m_fandeg;
}

int SerialMng::acdeg()
{
    return this->m_acdeg;
}

bool SerialMng::acopen()
{
   return this->m_acopen;
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

void SerialMng::parseMessage(QString message)
{
    for(int i=0;i<m_handlers.size();i++)
    {
       IFHandler * hnd = m_handlers.value(m_handlers.keys().at(i));
       const QStringList patterns = hnd->getPatterns();
       for(QString pattern : patterns)
       {
            QRegularExpression exp(pattern);
            if(exp.match(message).hasMatch())
            {
                if(hnd->messageHandler(message))
                {
                    QString fb = hnd->getFeedback();
                    this->write(fb.toUtf8());
                }
            }
       }
    }

}

bool SerialMng::registerHandler(QString uniqueName, IFHandler *handler)
{
    if(m_handlers.contains(uniqueName))
    {
        return false;
    }
    m_handlers.insert(uniqueName,handler);
    connect(handler,SIGNAL(newLog(QString)),this,SIGNAL(newLog(QString)));
    return true;
}

QSettings *SerialMng::getProtocolFile()
{
    return m_protocol;
}



void SerialMng::write(const QByteArray &writeData)
{
    QString p_write = QString("%1%2%3").arg(m_fb_begin).arg(QString(writeData)).arg(m_fb_end);
    emit newLog(QString("Outcoming Message : %1").arg(p_write));
    this->m_writeData = p_write.toUtf8();
    this->m_serial->write(m_writeData);
    m_serial->flush();
}

void SerialMng::read()
{
    QString readData = m_serial->readAll();
    QStringList items = readData.split(m_end);
    foreach(QString item , items)
    {
            if(item.isEmpty()) continue;
            QString message = QString("Incoming Message : %2%3").arg(item).arg(m_end);
            emit newLog(message);
            qDebug()<<message<<endl;
            if(!m_begin.isEmpty())
            {
                if(!item.startsWith(m_begin))  { continue;}
                item.remove(0,m_begin.length());
            }

            /*
            if(!m_end.isEmpty())
            {
               if(!readData.endsWith(m_end))  break;
               readData.remove(readData.length()-m_end.length(),m_end.length());
            }
            */
            this->parseMessage(item);
    }
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

void SerialMng::closeSystem()
{

    this->write("Ax/42/0\n");
}

void SerialMng::openSystem()
{
    this->write("Ax/42/1\n");
}
