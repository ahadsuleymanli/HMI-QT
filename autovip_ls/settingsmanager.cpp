#include "settingsmanager.h"
#include "langs.h"
#include <QDir>
#include <QCoreApplication>
#include <QDebug>
#include <QProcess>

SettingsManager::SettingsManager(QObject *parent) : QObject(parent)
{
    QString setfilePath = QString("%1/%2").arg(QDir::currentPath()).arg("settings.ini");
    QString protofilePath = QString("%1/%2").arg(QDir::currentPath()).arg("proto.ini");
    QString datafilePath = QString("%1/%2").arg(QDir::currentPath()).arg("data.ini");
    this->general = new QSettings(setfilePath,QSettings::IniFormat);
    this->m_proto = new QSettings(protofilePath,QSettings::IniFormat);
    this->datafile = new QSettings(datafilePath,QSettings::IniFormat);
}

void SettingsManager::resetSettings()
{
    QString setfile = QString("%1/%2").arg(QDir::currentPath()).arg("settings.ini");
    QString protofile = QString("%1/%2").arg(QDir::currentPath()).arg("proto.ini");
    delete general;
    delete m_proto;
    this->general = new QSettings(setfile,QSettings::IniFormat);
    m_proto = new QSettings(protofile,QSettings::IniFormat);
}

int SettingsManager::lang()
{
   int lang = this->general->value("main/lang",Langs::ENG).toInt();
   QLocale::setDefault(static_cast<QLocale::Language>(lang));
   return lang;
}

QString SettingsManager::localeCode(){
    return QLocale(static_cast<QLocale::Language>(this->general->value("main/lang",Langs::ENG).toInt())).name();
}

int SettingsManager::carModel(){
    return this->general->value("main/carmodel",1).toInt();
}

bool SettingsManager::voiceActivationButton(){
    return this->general->value("assistant/VA_button",false).toBool();
}

uint SettingsManager::actype()
{
    return this->general->value("main/actype",1).toUInt();
}

bool SettingsManager::acvents()
{
    return this->general->value("main/acvents",false).toBool();
}

uint SettingsManager::tvtype()
{
    return this->general->value("main/tvtype",6).toUInt();
}

uint SettingsManager::espressoopentime()
{
    return this->general->value("delays/espressoopentime",10000).toUInt();
}

uint SettingsManager::seatmovementduration()
{
    return this->general->value("delays/espressoopentime",5000).toUInt();
}
bool SettingsManager::satalliteremote()
{
    return this->general->value("main/satalliteremote",false).toBool();
}
bool SettingsManager::playstation()
{
    return this->general->value("main/playstation",false).toBool();
}

bool SettingsManager::dockingstation()
{
    return this->general->value("main/dockingstation",false).toBool();
}

bool SettingsManager::twodoor()
{
    return this->general->value("main/twodoor",false).toBool();
}

bool SettingsManager::regrigerator()
{
    return this->general->value("main/regrigerator",false).toBool();
}

bool SettingsManager::radio()
{
    return this->general->value("main/radio",false).toBool();
}

bool SettingsManager::slboolean()
{
    return this->general->value("lights/sidelight",false).toBool();
}

bool SettingsManager::sunroof()
{
    return this->general->value("main/sunroof",false).toBool();
}

bool SettingsManager::safeLocker()
{
    return this->general->value("main/safelocker",false).toBool();
}

bool SettingsManager::espresso()
{

    return this->general->value("main/espresso",false).toBool();
}

bool SettingsManager::windows()
{
    return this->general->value("main/windows",false).toBool();
}

bool SettingsManager::aircondition()
{
    return this->general->value("main/aircondition",true).toBool();
}

bool SettingsManager::bar()
{

    return this->general->value("main/bar",false).toBool();
}

bool SettingsManager::ceilingscreen()
{
    return this->general->value("main/ceilingscreen",false).toBool();
}

bool SettingsManager::safebox()
{

    return this->general->value("main/safebox",false).toBool();
}

bool SettingsManager::dvdplayer()
{
    return this->general->value("main/dvdplayer",false).toBool();
}

bool SettingsManager::curtains()
{
    return this->general->value("main/curtains",false).toBool();
}

bool SettingsManager::demomode()
{

    return this->general->value("main/demo_mode",true).toBool();
}

bool SettingsManager::intro()
{

    return this->general->value("main/intro",false).toBool();
}

bool SettingsManager::sidelight()
{
    return this->general->value("lights/sidelight",true).toBool();
}

bool SettingsManager::insidelight()
{
    return this->general->value("lights/insidelight",true).toBool();
}

bool SettingsManager::ambientlight()
{
    return this->general->value("lights/ambientlight",false).toBool();
}

bool SettingsManager::starlight()
{
    return this->general->value("lights/starlight",false).toBool();
}

bool SettingsManager::readinglight()
{
    return this->general->value("lights/readinglight",true).toBool();
}

bool SettingsManager::amp()
{
    return this->general->value("media/amp",false).toBool();
}
bool SettingsManager::ampInput()
{
    return this->general->value("media/ampinput",false).toInt()==2?true:false;
}
void SettingsManager::setActype(uint type)
{
    this->general->value("main/actype",type);
}

uint SettingsManager::mediaplayertype()
{
   return this->general->value("main/mediaplayertype",1).toUInt() ;
}

void SettingsManager::setMediaplayertype(uint p_mptype)
{
   this->general->value("main/mediaplayertype",p_mptype);
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


int SettingsManager::mindiff()
{
    return this->general->value("main/mindiff",0).toInt();
}

int SettingsManager::hourdiff()
{
    return this->general->value("main/hourdiff",0).toInt();
}




void SettingsManager::setTimeDiff(int mindiff, int hourdiff,int daydiff,int monthdiff,int yeardiff)
{
    this->general->setValue("timedate/mindiff",mindiff);
    this->general->setValue("timedate/hourdiff",hourdiff);
    this->general->setValue("timedate/daydiff",daydiff);
    this->general->setValue("timedate/monthdiff",monthdiff);
    this->general->setValue("timedate/yeardiff",yeardiff);
}

void SettingsManager::setHwTimeOffset(int sec, int min, int hour,int day,int month,int year, QString timezone)
{
    this->general->setValue("timedate/hw_offset_sec",sec);
    this->general->setValue("timedate/hw_offset_min",min);
    this->general->setValue("timedate/hw_offset_hour",hour);
    this->general->setValue("timedate/hw_offset_day",day);
    this->general->setValue("timedate/hw_offset_month",month);
    this->general->setValue("timedate/hw_offset_year",year);
    this->general->setValue("timedate/timezone",timezone);
}

void SettingsManager::setVersion(int major, int minor)
{
    this->general->setValue("update/version",QString::number(major) + "." + QString::number(minor));
}

QString SettingsManager::version()
{
    return this->general->value("update/version").toString();
}

// do not use this
//QString SettingsManager::lastdownloadedversion()
//{
//    return this->general->value("update/lastdownloadedversion").toString();
//}


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
    QString protofile = QString("%1/%2").arg(QDir::currentPath()).arg("proto.ini");
    qDebug()<<"settings file : " << settings_path;
    QFileInfo check_file(settings_path);
    bool settings_exist = false;
    bool proto_exist = false;
    if (check_file.exists() && check_file.isFile()) {
        settings_exist = true;
    }
    check_file.setFile(protofile);
    if (check_file.exists() && check_file.isFile()) {
        proto_exist = true;
    }
    if(proto_exist && settings_exist){
        return true;
    }
    else{
        return false;
    }
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

bool SettingsManager::seatHeating(int seat_no)
{
   switch(seat_no)
   {
       case 1:
            if(!this->general->contains("seatone/heating")) return false;
            return this->general->value("seatone/heating").toBool();
       case 2:
            if(!this->general->contains("seattwo/heating")) return false;
            return this->general->value("seattwo/heating").toBool();
       case 3:
            if(!this->general->contains("seatthree/heating")) return false;
            return this->general->value("seatthree/heating").toBool();
       case 4:
            if(!this->general->contains("seatfour/heating")) return false;
            return this->general->value("seatfour/heating").toBool();
   }
   return false;
}

bool SettingsManager::seatCooling(int seat_no)
{
   switch(seat_no)
   {
       case 1:
            if(!this->general->contains("seatone/cooling")) return false;
            return this->general->value("seatone/cooling").toBool();
       case 2:
            if(!this->general->contains("seattwo/cooling")) return false;
            return this->general->value("seattwo/cooling").toBool();
       case 3:
            if(!this->general->contains("seatthree/cooling")) return false;
            return this->general->value("seatthree/cooling").toBool();
       case 4:
            if(!this->general->contains("seatfour/cooling")) return false;
            return this->general->value("seatfour/cooling").toBool();
   }
   return false;

}

bool SettingsManager::seatMassage(int seat_no)
{
   switch(seat_no)
   {
       case 1:
            if(!this->general->contains("seatone/massage")) return false;
            return this->general->value("seatone/massage").toBool();
       case 2:
            if(!this->general->contains("seattwo/massage")) return false;
            return this->general->value("seattwo/massage").toBool();
       case 3:
            if(!this->general->contains("seatthree/massage")) return false;
            return this->general->value("seatthree/massage").toBool();
       case 4:
            if(!this->general->contains("seatfour/massage")) return false;
            return this->general->value("seatfour/massage").toBool();
   }
   return false;

}

bool SettingsManager::seatThigh(int seat_no)
{
   switch(seat_no)
   {
       case 1:
            if(!this->general->contains("seatone/thigh")) return false;
            return this->general->value("seatone/thigh").toBool();
       case 2:
            if(!this->general->contains("seattwo/thigh")) return false;
            return this->general->value("seattwo/thigh").toBool();
       case 3:
            if(!this->general->contains("seatthree/thigh")) return false;
            return this->general->value("seatthree/thigh").toBool();
       case 4:
            if(!this->general->contains("seatfour/thigh")) return false;
            return this->general->value("seatfour/thigh").toBool();
   }
   return false;

}

bool SettingsManager::seatDrawer(int seat_no)
{

   switch(seat_no)
   {
       case 1:
            if(!this->general->contains("seatone/drawer")) return false;
            return this->general->value("seatone/drawer").toBool();
       case 2:
            if(!this->general->contains("seattwo/drawer")) return false;
            return this->general->value("seattwo/drawer").toBool();
       case 3:
            if(!this->general->contains("seatthree/drawer")) return false;
            return this->general->value("seatthree/drawer").toBool();
       case 4:
            if(!this->general->contains("seatfour/drawer")) return false;
            return this->general->value("seatfour/drawer").toBool();
   }
   return false;
}

bool SettingsManager::seatFootrest(int seat_no)
{

   switch(seat_no)
   {
       case 1:
            if(!this->general->contains("seatone/footrest")) return false;
            return this->general->value("seatone/footrest").toBool();
       case 2:
            if(!this->general->contains("seattwo/footrest")) return false;
            return this->general->value("seattwo/footrest").toBool();
       case 3:
            if(!this->general->contains("seatthree/footrest")) return false;
            return this->general->value("seatthree/footrest").toBool();
       case 4:
            if(!this->general->contains("seatfour/footrest")) return false;
            return this->general->value("seatfour/footrest").toBool();
   }
   return false;
}

QStringList SEAT_GROUP_NAMES = { "seatone", "seattwo", "seatthree", "seatfour" };

bool SettingsManager::seatReadingLight(int seat_no){
    if ( seat_no>0 && seat_no-1<SEAT_GROUP_NAMES.size())
        return general->value(SEAT_GROUP_NAMES[seat_no-1] + "/readinglight",false).toBool();
    else
        return false;
}

bool SettingsManager::seatPositionPresets(int seat_no){
    if (seat_no==3||seat_no==4)
        return true;
    if ( seat_no>0 && seat_no-1<SEAT_GROUP_NAMES.size())
        return general->value(SEAT_GROUP_NAMES[seat_no-1] + "/positionpresets",false).toBool();
    else
        return false;
}


bool SettingsManager::saveLightMemory(int p_unit, int p_type, QString p_color)
{
    QString str_unit;
    QString str_type;
    switch (p_unit) {
        case 1:
        str_unit="mem1";
        break;
    case 2:
        str_unit="mem2";
        break;
    case 3:
        str_unit="mem3";
        break;
    default:
        return false;

    }
    switch (p_type) {
        case 1:
        str_type="ceiling";
        break;
    case 2:
        str_type="side";
        break;
    case 3:
        str_type="inside";
        break;
    default:
        return false;

    }
   general->setValue(QString("lights/%1_%2").arg(str_unit).arg(str_type),p_color);
   general->sync();
   return true;
}

QString SettingsManager::getLightMemory(int p_unit, int p_type)
{
    QString str_unit;
    QString str_type;
    switch (p_unit) {
        case 1:
        str_unit="mem1";
        break;
    case 2:
        str_unit="mem2";
        break;
    case 3:
        str_unit="mem3";
        break;
    default:
        return "#FFFFFF";

    }
    switch (p_type) {
        case 1:
        str_type="ceiling";
        break;
    case 2:
        str_type="side";
        break;
    case 3:
        str_type="inside";
        break;
    default:
        return "#FFFFFF";

    }
   return general->value(QString("lights/%1_%2").arg(str_unit).arg(str_type)).toString();
}

QSettings *SettingsManager::getSettings()
{
    return this->general;
}

//-Datafile--------------------------------------------------
QSettings *SettingsManager::getDatafile()
{
    return this->datafile;
}
QStringList SettingsManager::datafileGetRadioStations(){
    datafile->beginGroup("RadioStations");
    const QStringList radioStations = datafile->childKeys();
    datafile->endGroup();
    return radioStations;
}
void SettingsManager::datafileRemoveRadioStation(QString radioFrequency){
    datafile->remove("RadioStations/"+radioFrequency);
}
void SettingsManager::datafileAddRadioStation(QString radioFrequency){
    datafile->setValue("RadioStations/"+radioFrequency,"");
}
QString SettingsManager::datafileGetSafePin(){
    datafile->beginGroup("Security");
    QString pin;
    if (datafile->childKeys().contains("safe_pin"))
        pin=datafile->value("safe_pin").toString();
    else
        pin="1111";
    datafile->endGroup();
    return pin;
}
void SettingsManager::datafileSetSafePin(QString newPin){
    datafile->setValue("Security/safe_pin",newPin);
    emit safePinChanged();
}
//-----------------------------------------------------------

bool SettingsManager::autoUpdate()
{
    return this->general->value("update/autoUpdate", true).toBool();
}

void SettingsManager::setAutoUpdate(bool enabled)
{
    if(autoUpdate() == enabled) return;
    this->general->setValue("update/autoUpdate",enabled);
    emit autoUpdateChanged(enabled);
}

QVariant SettingsManager::value(QString key, QVariant defaultValue)
{
   return this->general->value(key,defaultValue);
}

