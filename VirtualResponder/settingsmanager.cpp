#include "settingsmanager.h"
#include <QDir>
#include <QCoreApplication>
#include <QDebug>

SettingsManager::SettingsManager(QObject *parent) : QObject(parent)
{
    QString setfile = QString("%1/%2").arg(QDir::currentPath()).arg("settings.ini");
    this->general = new QSettings(setfile,QSettings::IniFormat);
}

int SettingsManager::lang()
{
    return this->general->value("main/lang",1).toInt();
}

QString SettingsManager::mediaPlayerURL()
{
   return this->general->value("media/url","ws://192.168.1.38:9090").toString();
}

void SettingsManager::setMediaPlayerURL(QString nmediaPlayerURL)
{
    if(this->mediaPlayerURL().compare(nmediaPlayerURL) != 0)
    {
        this->general->setValue("media/url",nmediaPlayerURL);
        emit mediaPlayerURLChanged(nmediaPlayerURL);
    }

}

void SettingsManager::setLang(int nlang)
{
   int lang = this->lang();
   if(lang != nlang)
   {
      this->general->setValue("main/lang",nlang);
      emit langChanged(nlang);
   }
}

bool SettingsManager::init()
{
    QString settings_path = QString("%1/settings.ini").arg(QDir::currentPath());
    qDebug()<<"settings file : " << settings_path;
    QFileInfo check_file(settings_path);
    if (check_file.exists() && check_file.isFile()) {
           return true;
    }
    this->general->beginGroup("main");
    this->general->setValue("lang",1);
    this->general->endGroup();

    this->general->beginGroup("media");
    this->general->setValue("url","ws://192.168.1.38:9090");
    this->general->endGroup();

    this->general->beginGroup("serial");
    this->general->setValue("baud_rate", BAUDRATE );
    this->general->setValue("port_name", STRPNAME );
    this->general->setValue("databits",8);
    this->general->setValue("parity",0);
    this->general->setValue("stopbits",1);
    this->general->setValue("flowcontrol",0);
    this->general->endGroup();


    this->general->beginGroup("seatone");
    this->general->setValue("heating", 0);
    this->general->setValue("cooling", 0);
    this->general->setValue("massage", 0);
    this->general->endGroup();


    this->general->beginGroup("seattwo");
    this->general->setValue("heating", 0);
    this->general->setValue("cooling", 0);
    this->general->setValue("massage", 0);
    this->general->endGroup();

    this->general->beginGroup("seatthree");
    this->general->setValue("heating", 0);
    this->general->setValue("cooling", 0);
    this->general->setValue("massage", 0);
    this->general->endGroup();

    this->general->beginGroup("seatfour");
    this->general->setValue("heating", 0);
    this->general->setValue("cooling", 0);
    this->general->setValue("massage", 0);
    this->general->endGroup();

    this->general->beginGroup("update");
    this->general->setValue("update_server", "31.210.65.230");
    this->general->setValue("username", "gokhan");
    this->general->setValue("password", "g0khan111");
    this->general->setValue("version", "1.0");
    this->general->setValue("lastversion", "1.0");
    this->general->endGroup();


    this->general->sync();

    if (check_file.exists() && check_file.isFile()) {
           return true;
    }
    return false;
}

int SettingsManager::baudrate()
{
   return this->general->value("serial/baud_rate").toInt();
}

void SettingsManager::setBaudrate(int r)
{
   int brate =  this->general->value("serial/baud_rate").toInt();
   if(r != brate)
   {
       this->general->setValue("serial/baud_rate",r);
       emit baudrateChanged(r);
   }
}

QString SettingsManager::portname()
{
    return this->general->value("serial/port_name").toString();
}

void SettingsManager::setPortname(QString p_pn)
{
    QString pn = this->general->value("serial/port_name").toString();
    if(pn.compare(p_pn)!=0)
    {
        this->general->setValue("serial/port_name",p_pn);
        emit portnameChanged(p_pn);
    }

}

uint SettingsManager::seatHeating(uint seat_no)
{
   switch(seat_no)
   {
       case 1:
            if(!this->general->contains("seatone/heating")) return 0;
            return this->general->value("seatone/heating").toUInt();
       case 2:
            if(!this->general->contains("seattwo/heating")) return 0;
            return this->general->value("seattwo/heating").toUInt();
       case 3:
            if(!this->general->contains("seatthree/heating")) return 0;
            return this->general->value("seatthree/heating").toUInt();
       case 4:
            if(!this->general->contains("seatfour/heating")) return 0;
            return this->general->value("seatfour/heating").toUInt();
   }
   return 0;
}

uint SettingsManager::seatCooling(uint seat_no)
{
   switch(seat_no)
   {
       case 1:
            if(!this->general->contains("seatone/cooling")) return 0;
            return this->general->value("seatone/cooling").toUInt();
       case 2:
            if(!this->general->contains("seattwo/cooling")) return 0;
            return this->general->value("seattwo/cooling").toUInt();
       case 3:
            if(!this->general->contains("seatthree/cooling")) return 0;
            return this->general->value("seatthree/cooling").toUInt();
       case 4:
            if(!this->general->contains("seatfour/cooling")) return 0;
            return this->general->value("seatfour/cooling").toUInt();
   }
   return 0;

}

uint SettingsManager::seatMassage(uint seat_no)
{
   switch(seat_no)
   {
       case 1:
            if(!this->general->contains("seatone/massage")) return 0;
            return this->general->value("seatone/massage").toUInt();
       case 2:
            if(!this->general->contains("seattwo/massage")) return 0;
            return this->general->value("seattwo/massage").toUInt();
       case 3:
            if(!this->general->contains("seatthree/massage")) return 0;
            return this->general->value("seatthree/massage").toUInt();
       case 4:
            if(!this->general->contains("seatfour/massage")) return 0;
            return this->general->value("seatfour/massage").toUInt();
   }
   return 0;

}

bool SettingsManager::setSeatHeating(uint seat_no, uint deg)
{

   switch(seat_no)
   {
       case 1:
            if(!this->general->contains("seatone/heating")) return false;
            this->general->setValue("seatone/heating",deg);
       break;
       case 2:
            if(!this->general->contains("seattwo/heating")) return false;
            this->general->setValue("seattwo/heating",deg);
       break;
       case 3:
            if(!this->general->contains("seatthree/heating")) return false;
            this->general->setValue("seatthree/heating",deg);
       break;
       case 4:
            if(!this->general->contains("seatfour/heating")) return false;
            this->general->setValue("seatfour/heating",deg);
       break;
   default:
       return false;
   }

    return true;
}

bool SettingsManager::setSeatCooling(uint seat_no, uint deg)
{

   switch(seat_no)
   {
       case 1:
            if(!this->general->contains("seatone/cooling")) return false;
            this->general->setValue("seatone/cooling",deg);
       break;
       case 2:
            if(!this->general->contains("seattwo/cooling")) return false;
            this->general->setValue("seattwo/cooling",deg);
       break;
       case 3:
            if(!this->general->contains("seatthree/cooling")) return false;
            this->general->setValue("seatthree/cooling",deg);
       break;
       case 4:
            if(!this->general->contains("seatfour/cooling")) return false;
            this->general->setValue("seatfour/cooling",deg);
       break;
   default:
       return false;
   }

    return true;
}

bool SettingsManager::setSeatMassage(uint seat_no, uint deg)
{

   switch(seat_no)
   {
       case 1:
            if(!this->general->contains("seatone/massage")) return false;
            this->general->setValue("seatone/massage",deg);
       break;
       case 2:
            if(!this->general->contains("seattwo/massage")) return false;
            this->general->setValue("seattwo/massage",deg);
       break;
       case 3:
            if(!this->general->contains("seatthree/cooling")) return false;
            this->general->setValue("seatthree/massage",deg);
       break;
       case 4:
            if(!this->general->contains("seatfour/cooling")) return false;
            this->general->setValue("seatfour/massage",deg);
       break;
   default:
       return false;
   }

   return true;
}

QSettings *SettingsManager::getSettings()
{
   return this->general;
}

QVariant SettingsManager::value(QString key)
{
   return this->general->value(key);
}
