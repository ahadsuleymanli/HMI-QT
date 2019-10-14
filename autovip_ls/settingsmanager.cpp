#include "settingsmanager.h"
#include "langs.h"
#include <QDir>
#include <QCoreApplication>
#include <QDebug>

SettingsManager::SettingsManager(QObject *parent) : QObject(parent)
{
    QString setfile = QString("%1/%2").arg(QDir::currentPath()).arg("settings.ini");
    QString protofile = QString("%1/%2").arg(QDir::currentPath()).arg("proto.ini");
    this->general = new QSettings(setfile,QSettings::IniFormat);
    m_proto = new QSettings(protofile,QSettings::IniFormat);
}

int SettingsManager::lang()
{
    return this->general->value("main/lang",Langs::ENG).toInt();
}

uint SettingsManager::actype()
{
    return this->general->value("main/actype",1).toUInt();
}

uint SettingsManager::tvtype()
{
    return this->general->value("main/tvtype",6).toUInt();
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

bool SettingsManager::espresso()
{

    return this->general->value("main/espresso",true).toBool();
}

bool SettingsManager::bar()
{

    return this->general->value("main/bar",true).toBool();
}

bool SettingsManager::ceilingscreen()
{
    return this->general->value("main/ceilingscreen",true).toBool();
}

bool SettingsManager::safebox()
{

    return this->general->value("main/safebox",true).toBool();
}

bool SettingsManager::dvdplayer()
{
    return this->general->value("main/dvdplayer",true).toBool();
}

bool SettingsManager::curtains()
{
    return this->general->value("main/curtains",true).toBool();
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

bool SettingsManager::amp()
{
    return this->general->value("media/amp",false).toBool();
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
    return this->general->value("main/mindiff",1).toInt();
}

int SettingsManager::hourdiff()
{
    return this->general->value("main/hourdiff",1).toInt();
}


void SettingsManager::setTimeDiff(int mndf, int hrdf)
{
    if(this->mindiff() != mndf || this->hourdiff() != hrdf)
    {
        this->general->setValue("main/mindiff",mndf);
        this->general->setValue("main/hourdiff",hrdf);
    }
}

void SettingsManager::setVersion(int major, int minor)
{
    this->general->setValue("update/version",QString::number(major) + "." + QString::number(minor));
}

void SettingsManager::setLastVersion(QString lversion)
{
    this->general->setValue("update/lastversion",lversion);
}

QString SettingsManager::version()
{
    return this->general->value("update/version").toString();
}

QString SettingsManager::lastversion()
{
    return this->general->value("update/lastversion").toString();
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
    if(proto_exist && settings_exist)
    {
        return true;
    }
    if(!settings_exist)
    {
    this->general->beginGroup("main");
    this->general->setValue("lang",Langs::ENG);
    this->general->setValue("actype",1);
    this->general->setValue("mindiff",0);
    this->general->setValue("hourdiff",0);
    this->general->setValue("mediaplayertype",1);
    this->general->setValue("tvtype",6);
    this->general->setValue("playstation",false);
    this->general->setValue("dockingstation",false);
    this->general->setValue("twodoor",false);
    this->general->setValue("regrigerator",false);
    this->general->setValue("radio",false);
    this->general->setValue("sunroof",false);
    this->general->setValue("espresso",false);
    this->general->setValue("bar",false);
    this->general->setValue("ceilingscreen",false);
    this->general->setValue("safebox",false);
    this->general->setValue("dvdplayer",true);
    this->general->setValue("curtains",true);
    general->setValue("auto_connect",true);
    general->setValue("auto_connect_timeout",5000);
    general->setValue("demo_mode",true);
    general->setValue("intro",true);
    this->general->endGroup();

    this->general->beginGroup("media");
    this->general->setValue("url","ws://192.168.1.38:9090");
    this->general->setValue("amp",true);
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
    this->general->setValue("heating", true );
    this->general->setValue("cooling", true );
    this->general->setValue("massage", true );
    this->general->setValue("thigh", false );
    this->general->setValue("drawer", false );
    this->general->endGroup();


    this->general->beginGroup("seattwo");
    this->general->setValue("heating", true );
    this->general->setValue("cooling", true );
    this->general->setValue("massage", true );
    this->general->setValue("thigh", false );
    this->general->setValue("drawer", false );
    this->general->endGroup();

    this->general->beginGroup("seatthree");
    this->general->setValue("heating", true );
    this->general->setValue("cooling", true );
    this->general->setValue("massage", true );
    this->general->setValue("thigh", true );
    this->general->setValue("drawer", true );
    this->general->endGroup();

    this->general->beginGroup("seatfour");
    this->general->setValue("heating", true );
    this->general->setValue("cooling", true );
    this->general->setValue("massage", true );
    this->general->setValue("thigh", true );
    this->general->setValue("drawer", true );
    this->general->endGroup();

    general->beginGroup("lights");
    general->setValue("mem1_ceiling","#FFFFFF");
    general->setValue("mem2_ceiling","#FFFFFF");
    general->setValue("mem3_ceiling","#FFFFFF");
    general->setValue("mem1_side","#FFFFFF");
    general->setValue("mem2_side","#FFFFFF");
    general->setValue("mem3_side","#FFFFFF");
    general->setValue("mem1_inside","#FFFFFF");
    general->setValue("mem2_inside","#FFFFFF");
    general->setValue("mem3_inside","#FFFFFF");
    general->setValue("white","#FFFFFF");
    general->setValue("sunlight","#FF9B2E");
    general->setValue("sidelight","true");
    general->endGroup();

    this->general->beginGroup("logging");
    this->general->setValue("fileName", "dizaynvip.log");
    this->general->setValue("maxSize", 1024);
    this->general->setValue("maxBackups", 2);
    this->general->setValue("msgFormat", "{timestamp} {type} {msg}");
    this->general->setValue("timestampFormat", "yyyy-MM-dd hh:mm:ss.zzz");
    this->general->setValue("minLevel", 0);
    this->general->endGroup();

    this->general->beginGroup("update");
    this->general->setValue("update_server", "31.210.65.230");
    this->general->setValue("username", "gokhan");
    this->general->setValue("password", "g0khan111");
    this->general->setValue("version", "1.0");
    this->general->setValue("lastversion", "1.0");
    this->general->endGroup();

    }

    if(!proto_exist)
    {
        m_proto->beginGroup("main");
        m_proto->setValue("start_code","Ax/");
        m_proto->setValue("end_code","\n");
        m_proto->setValue("delay",100);
        m_proto->setValue("system_request","27/50");
        m_proto->setValue("system_onoff","27/21");
        m_proto->setValue("setclock","100/77");

        m_proto->endGroup();

        m_proto->beginGroup("feedbacks");
        m_proto->setValue("start_code","");
        m_proto->setValue("end_code","");
        m_proto->setValue("aircondition","26");
        m_proto->setValue("ceiling_light","77");
        m_proto->setValue("side_light","78");
        m_proto->setValue("inside_light","79");
        m_proto->setValue("first_seat","15");
        m_proto->setValue("second_seat","14");
        m_proto->setValue("third_seat","10");
        m_proto->setValue("fourth_seat","9");
        m_proto->setValue("system","42");
        m_proto->endGroup();

        //şimdilik planlanma aşamasında belki aşağıdan değil ilgili yerden çağrılır
        /*
        m_proto->beginGroup("requests");
        m_proto->setValue("first_seat","15/22");
        m_proto->setValue("second_seat","14/22");
        m_proto->setValue("third_seat","10/22");
        m_proto->setValue("fourth_seat","9/22");
        m_proto->setValue("system","27/50");
        m_proto->endGroup();
        */

        m_proto->beginGroup("seats");
        m_proto->setValue("first_seat","15");
        m_proto->setValue("second_seat","14");
        m_proto->setValue("third_seat","10");
        m_proto->setValue("fourth_seat","9");
        m_proto->setValue("seats_feedback","9");
        m_proto->endGroup();

        m_proto->beginGroup("first_seat");
        m_proto->setValue("stop","15/99");
        m_proto->setValue("pagepass","15/22");

        m_proto->setValue("head_up","15/0");
        m_proto->setValue("head_down","15/1");
        m_proto->setValue("head_stop","15/99");

        m_proto->setValue("back_forward","15/2");
        m_proto->setValue("back_backward","15/3");
        m_proto->setValue("back_stop","15/99");

        m_proto->setValue("seat_forward","15/8");
        m_proto->setValue("seat_backward","15/9");
        m_proto->setValue("seat_stop","15/99");


        m_proto->setValue("footrest_open","00/00");
        m_proto->setValue("footrest_close","00/00");
        m_proto->setValue("footrest_stop","00/00");

        m_proto->setValue("thigh_up","15/6");
        m_proto->setValue("thigh_down","15/7");
        m_proto->setValue("thigh_stop","15/99");

        m_proto->setValue("massage_onoff","15/16");
        m_proto->setValue("massage_mode","15/17");

        m_proto->setValue("heating","15/12");
        m_proto->setValue("cooling","15/13");


        m_proto->setValue("mem1","00/00");
        m_proto->setValue("mem2","00/00");
        m_proto->setValue("mem3","00/00");


        m_proto->setValue("mem_m1","00/00");
        m_proto->setValue("mem_m2","00/00");
        m_proto->setValue("mem_m3","00/00");

        m_proto->setValue("curtain_open","15/34");
        m_proto->setValue("curtain_close","15/35");
        m_proto->setValue("curtain_stop","15/99");


        m_proto->setValue("drawer_open","15/10");
        m_proto->setValue("drawer_close","15/11");
        m_proto->setValue("drawer_stop","15/99");

        m_proto->endGroup();


        m_proto->beginGroup("second_seat");
        m_proto->setValue("stop","14/99");
        m_proto->setValue("pagepass","14/22");

        m_proto->setValue("head_up","14/0");
        m_proto->setValue("head_down","14/1");
        m_proto->setValue("head_stop","14/99");

        m_proto->setValue("back_forward","14/2");
        m_proto->setValue("back_backward","14/3");
        m_proto->setValue("back_stop","14/99");

        m_proto->setValue("seat_forward","14/8");
        m_proto->setValue("seat_backward","14/9");
        m_proto->setValue("seat_stop","14/9");


        m_proto->setValue("footrest_open","00/00");
        m_proto->setValue("footrest_close","00/00");
        m_proto->setValue("footrest_stop","00/00");

        m_proto->setValue("thigh_up","14/6");
        m_proto->setValue("thigh_down","14/7");
        m_proto->setValue("thigh_stop","14/99");

        m_proto->setValue("massage_onoff","14/16");
        m_proto->setValue("massage_mode","14/17");


        m_proto->setValue("table_open","00/00");
        m_proto->setValue("table_close","00/00");
        m_proto->setValue("table_stop","00/00");

        m_proto->setValue("heating","14/12");
        m_proto->setValue("cooling","14/13");

        m_proto->setValue("mem1","00/00");
        m_proto->setValue("mem2","00/00");
        m_proto->setValue("mem3","00/00");


        m_proto->setValue("mem_m1","00/00");
        m_proto->setValue("mem_m2","00/00");
        m_proto->setValue("mem_m3","00/00");


        m_proto->setValue("curtain_open","14/34");
        m_proto->setValue("curtain_close","14/35");
        m_proto->setValue("curtain_stop","14/99");


        m_proto->setValue("drawer_open","14/10");
        m_proto->setValue("drawer_close","14/11");
        m_proto->setValue("drawer_stop","14/99");



        m_proto->endGroup();

        m_proto->beginGroup("third_seat");
        m_proto->setValue("stop","10/99");
        m_proto->setValue("pagepass","10/22");

        m_proto->setValue("head_up","10/0");
        m_proto->setValue("head_down","10/1");
        m_proto->setValue("head_stop","10/99");

        m_proto->setValue("back_forward","10/2");
        m_proto->setValue("back_backward","10/3");
        m_proto->setValue("back_stop","10/99");

        m_proto->setValue("seat_forward","10/8");
        m_proto->setValue("seat_backward","10/9");
        m_proto->setValue("seat_stop","10/9");

        m_proto->setValue("footrest_open","10/202");
        m_proto->setValue("footrest_close","10/203");
        m_proto->setValue("footrest_stop","10/204");

        m_proto->setValue("thigh_up","00/00");
        m_proto->setValue("thigh_down","00/00");
        m_proto->setValue("thigh_stop","00/00");

        m_proto->setValue("massage_onoff","10/16");
        m_proto->setValue("massage_mode","10/17");

        m_proto->setValue("table_open","10/216");
        m_proto->setValue("table_close","10/217");
        m_proto->setValue("table_stop","10/218");

        m_proto->setValue("heating","10/211");
        m_proto->setValue("cooling","10/212");

        m_proto->setValue("mem1","10/12");
        m_proto->setValue("mem2","10/13");
        m_proto->setValue("mem3","10/14");


        m_proto->setValue("mem_m1","10/15");
        m_proto->setValue("mem_m2","10/16");
        m_proto->setValue("mem_m3","10/17");

        m_proto->setValue("curtain_open","10/219");
        m_proto->setValue("curtain_close","10/220");
        m_proto->setValue("curtain_stop","10/221");

        m_proto->setValue("drawer_open","00/00");
        m_proto->setValue("drawer_close","00/00");
        m_proto->setValue("drawer_stop","00/00");


        m_proto->endGroup();

        m_proto->beginGroup("fourth_seat");
        m_proto->setValue("stop","9/99");
        m_proto->setValue("pagepass","9/22");

        m_proto->setValue("head_up","9/0");
        m_proto->setValue("head_down","9/1");
        m_proto->setValue("head_stop","9/99");

        m_proto->setValue("back_forward","9/2");
        m_proto->setValue("back_backward","9/3");
        m_proto->setValue("back_stop","9/99");

        m_proto->setValue("seat_forward","9/8");
        m_proto->setValue("seat_backward","9/9");
        m_proto->setValue("seat_stop","9/99");

        m_proto->setValue("footrest_open","00/00");
        m_proto->setValue("footrest_close","00/00");
        m_proto->setValue("footrest_stop","00/00");

        m_proto->setValue("thigh_up","9/6");
        m_proto->setValue("thigh_down","9/7");
        m_proto->setValue("thigh_stop","9/99");

        m_proto->setValue("massage_mode","9/201");
        m_proto->setValue("massage_onoff","9/200");


        m_proto->setValue("table_open","9/216");
        m_proto->setValue("table_close","9/217");
        m_proto->setValue("table_stop","9/218");

        m_proto->setValue("heating","9/211");
        m_proto->setValue("cooling","9/212");

        m_proto->setValue("mem1","9/12");
        m_proto->setValue("mem2","9/13");
        m_proto->setValue("mem3","9/14");


        m_proto->setValue("mem_m1","9/15");
        m_proto->setValue("mem_m2","9/16");
        m_proto->setValue("mem_m3","9/17");

        m_proto->setValue("footrest_open","9/202");
        m_proto->setValue("footrest_close","9/203");
        m_proto->setValue("footrest_stop","9/204");

        m_proto->setValue("curtain_open","9/219");
        m_proto->setValue("curtain_close","9/220");
        m_proto->setValue("curtain_stop","9/221");



        m_proto->endGroup();

        m_proto->beginGroup("lights");

        m_proto->setValue("ceiling_red","3");
        m_proto->setValue("ceiling_green","4");
        m_proto->setValue("ceiling_blue","5");


        m_proto->setValue("side_red","22");
        m_proto->setValue("side_green","23");
        m_proto->setValue("side_blue","24");

        m_proto->setValue("inside_red","90");
        m_proto->setValue("inside_green","91");
        m_proto->setValue("inside_blue","92");

        m_proto->setValue("ceiling_request","777/1");
        m_proto->setValue("inside_request","777/2");
        m_proto->setValue("side_request","777/3");
        m_proto->setValue("request_delay",300);

        m_proto->setValue("leftreading_onoff","100/21");
        m_proto->setValue("rightreading_onoff","100/22");


        m_proto->endGroup();

        m_proto->beginGroup("media");

        m_proto->setValue("back_monitor","27/42");
        m_proto->setValue("back_monitor_src","84/2");
        m_proto->setValue("back_monitor_ok","84/1");
        /*
         * bakınız screen_up screen_down
            m_proto->setValue("tv_up","32/32");
            m_proto->setValue("tv_down","32/33");
        */
        m_proto->setValue("screen_divider","27/27");
        m_proto->setValue("dvd_player","27/23");
        m_proto->setValue("hdmi","6/82");
        m_proto->setValue("ready_divide","6/86");
        m_proto->setValue("delay_divide",300);
        m_proto->setValue("front_camera","27/25");
        m_proto->setValue("rear_camera","27/26");
        m_proto->setValue("play_station","6/82");
        m_proto->setValue("dockingstation","6/82");

        m_proto->endGroup();

        m_proto->beginGroup("controls");
        m_proto->setValue("right_door","11/2");
        m_proto->setValue("left_door","00/00");
        m_proto->setValue("right_door_stop","00/00");
        m_proto->setValue("left_door_stop","00/00");

        m_proto->setValue("can_ai_fan_up","18/2");
        m_proto->setValue("can_ai_fan_down","18/3");
        m_proto->setValue("can_ai_degree_up","18/4");
        m_proto->setValue("can_ai_degree_down","18/5");
        m_proto->setValue("can_ai_feedback","18/6");

        m_proto->setValue("airconditioner_cat_modbus","60");
        m_proto->setValue("modbus_ai_fan_up","60/1");
        m_proto->setValue("modbus_ai_fan_down","60/2");
        m_proto->setValue("modbus_ai_degree_up","60/3");
        m_proto->setValue("modbus_ai_degree_down","60/4");
        m_proto->setValue("modbus_ai_feedback","60/6");

        /* Eskiden kalmış olabilir
        m_proto->setValue("airconditioner_cat_can","18");
        m_proto->setValue("airconditioner_fan_up","18/2");
        m_proto->setValue("airconditioner_fan_down","18/3");
        m_proto->setValue("airconditioner_degree_up","18/4");
        m_proto->setValue("airconditioner_degree_down","18/5");
        */

        m_proto->setValue("smokefan_onoff","27/39");

        m_proto->setValue("leftwindow_open","12/1");
        m_proto->setValue("leftwindow_close","12/0");
        m_proto->setValue("rightwindow_open","13/0");
        m_proto->setValue("rightwindow_close","13/1");

        m_proto->setValue("espresso_close","32/26");
        m_proto->setValue("espresso_open","32/25");
        m_proto->setValue("espresso_stop","32/29");

        m_proto->setValue("back_curtain_up","9/222");
        m_proto->setValue("back_curtain_down","9/223");
        m_proto->setValue("back_curtain_stop","9/224");

        m_proto->setValue("bar_up","32/30");
        m_proto->setValue("bar_down","32/31");
        m_proto->setValue("bar_stop","32/98");


        m_proto->setValue("refrigerator_up","32/34");
        m_proto->setValue("refrigerator_down","32/35");
        m_proto->setValue("refrigerator_stop","32/98");


        m_proto->setValue("safebox_open","101/1");
        m_proto->setValue("safebox_close","101/2");


        m_proto->setValue("sunroof_up","63/4");
        m_proto->setValue("sunroof_down","64/5");
        m_proto->setValue("sunroof_stop","00/00");

        m_proto->setValue("intercom","27/10");

        m_proto->setValue("mute","88/5");
        m_proto->setValue("volume_up","88/1");
        m_proto->setValue("volume_up_stop","7/0");
        m_proto->setValue("volume_down_stop","7/0");
        m_proto->setValue("volume_mute_stop","7/0");
        m_proto->setValue("audio_source","88/4");

        m_proto->setValue("screen_up","32/32");
        m_proto->setValue("screen_down","32/33");
        m_proto->setValue("screen_stop","32/98");

        m_proto->setValue("window_leftopen","12/1");
        m_proto->setValue("window_leftclose","12/0");
        m_proto->setValue("window_rightopen","13/1");
        m_proto->setValue("window_rightclose","13/0");




        m_proto->endGroup();

        m_proto->beginGroup("feedbacks");
        m_proto->endGroup();

        m_proto->beginGroup("apple_tv");
        m_proto->setValue("stop_code","7/0");
        m_proto->setValue("altbtn","00/00");
        m_proto->setValue("microphone","00/00");
        m_proto->setValue("source","6/83");
        m_proto->setValue("delay",100);
        m_proto->setValue("up","89/0");
        m_proto->setValue("down","89/1");
        m_proto->setValue("left","89/2");
        m_proto->setValue("right","89/3");
        m_proto->setValue("menu","89/4");
        m_proto->setValue("play_pause","89/5");
        m_proto->setValue("volume_up","89/8");
        m_proto->setValue("volume_down","89/9");
        m_proto->setValue("click","89/10");

        m_proto->endGroup();

        m_proto->beginGroup("samsung_tv");
        m_proto->setValue("delay",100);
        m_proto->setValue("stop_code","7/0");
        m_proto->setValue("pause","00/00");
        m_proto->setValue("power","6/99");
        m_proto->setValue("home","6/56");
        m_proto->setValue("source","6/51");
        m_proto->setValue("zero","6/15");
        m_proto->setValue("one","6/5");
        m_proto->setValue("two","6/6");
        m_proto->setValue("three","6/7");
        m_proto->setValue("four","6/8");
        m_proto->setValue("five","6/9");
        m_proto->setValue("six","6/10");
        m_proto->setValue("seven","6/11");
        m_proto->setValue("eight","6/12");
        m_proto->setValue("nine","6/13");
        m_proto->setValue("volume_up","6/17");
        m_proto->setValue("volume_down","6/18");
        m_proto->setValue("channel_up","6/22");
        m_proto->setValue("channel_down","6/23");
        m_proto->setValue("a","6/35");
        m_proto->setValue("b","6/36");
        m_proto->setValue("c","6/37");
        m_proto->setValue("d","6/38");
        m_proto->setValue("ttx_mx","6/53");
        m_proto->setValue("prc_ch","6/54");
        m_proto->setValue("sport","6/58");
        m_proto->setValue("extra","6/60");
        m_proto->setValue("info","6/3");
        m_proto->setValue("mute","6/21");
        m_proto->setValue("setting","6/57");
        m_proto->setValue("channel_list","6/55");
        m_proto->setValue("subtitle","6/65");
        m_proto->setValue("return","6/59");
        m_proto->setValue("exit","6/34");
        m_proto->setValue("guide","6/14");
        m_proto->setValue("rec","6/47");
        m_proto->setValue("up_arrow","6/27");
        m_proto->setValue("left_arrow","6/28");
        m_proto->setValue("right_arrow","6/29");
        m_proto->setValue("down_arrow","6/30");
        m_proto->setValue("play","6/43");
        m_proto->setValue("display","00/00");
        m_proto->setValue("stop","6/42");
        m_proto->setValue("backward","6/45");  // geri al
        m_proto->setValue("forward","6/46"); // ileri al

        /////
        m_proto->setValue("res","6/87");
        m_proto->setValue("clear","6/88");
        m_proto->setValue("title","6/89");
        m_proto->setValue("menu","6/90");
        m_proto->setValue("prog","6/91");
        m_proto->setValue("bmark","6/92");
        m_proto->setValue("okey","6/93");
        m_proto->setValue("zoom","6/94");
        m_proto->setValue("random","6/95");
        m_proto->setValue("media","6/96");
        m_proto->setValue("audio","6/97");
        m_proto->setValue("osc","6/98");
        m_proto->setValue("previous","6/100");
        m_proto->setValue("next","6/101");
        /////

        m_proto->endGroup();

        m_proto->beginGroup("lg_tv");
        m_proto->setValue("delay",100);
        m_proto->setValue("stop_code","7/0");
        m_proto->setValue("power","7/99");
        m_proto->setValue("home","7/56");
        m_proto->setValue("source","7/51");
        m_proto->setValue("zero","7/15");
        m_proto->setValue("one","7/5");
        m_proto->setValue("two","7/6");
        m_proto->setValue("three","7/7");
        m_proto->setValue("four","7/8");
        m_proto->setValue("five","7/9");
        m_proto->setValue("six","7/10");
        m_proto->setValue("seven","7/11");
        m_proto->setValue("eight","7/12");
        m_proto->setValue("nine","7/13");
        m_proto->setValue("volume_up","7/17");
        m_proto->setValue("volume_down","7/18");
        m_proto->setValue("channel_up","7/22");
        m_proto->setValue("channel_down","7/23");
        m_proto->setValue("a","7/35");
        m_proto->setValue("b","7/36");
        m_proto->setValue("c","7/37");
        m_proto->setValue("d","7/38");
        m_proto->setValue("ttx_mx","7/53");
        m_proto->setValue("prc_ch","7/54");
        m_proto->setValue("sport","7/58");
        m_proto->setValue("extra","7/60");
        m_proto->setValue("info","7/3");
        m_proto->setValue("mute","7/21");
        m_proto->setValue("setting","7/57");
        m_proto->setValue("channel_list","7/55");
        m_proto->setValue("subtitle","7/65");
        m_proto->setValue("return","7/59");
        m_proto->setValue("exit","7/34");
        m_proto->setValue("guide","7/14");
        m_proto->setValue("rec","7/47");
        m_proto->setValue("up_arrow","7/27");
        m_proto->setValue("left_arrow","7/28");
        m_proto->setValue("right_arrow","7/29");
        m_proto->setValue("down_arrow","7/30");
        m_proto->setValue("play","7/43");
        m_proto->setValue("stop","7/42");
        m_proto->setValue("backward","7/45");  // geri al
        m_proto->setValue("forward","7/46"); // ileri al

        ////
        m_proto->setValue("res","7/87");
        m_proto->setValue("clear","7/88");
        m_proto->setValue("title","7/89");
        m_proto->setValue("menu","7/90");
        m_proto->setValue("prog","7/91");
        m_proto->setValue("bmark","7/92");
        m_proto->setValue("okey","7/93");
        m_proto->setValue("zoom","7/94");
        m_proto->setValue("random","7/95");
        m_proto->setValue("media","7/96");
        m_proto->setValue("audio","7/97");
        m_proto->setValue("osc","7/98");
        m_proto->setValue("previous","7/100");
        m_proto->setValue("next","7/101");
        ////

        m_proto->endGroup();

        m_proto->beginGroup("dvdplayer");
        m_proto->setValue("source_delay",100);
        m_proto->setValue("delay",100);
        m_proto->setValue("off","102/99");
        m_proto->setValue("mute","102/98");
        m_proto->setValue("monitor_off","102/97");
        m_proto->setValue("audio","102/96");
        m_proto->setValue("subtitle","102/95");
        m_proto->setValue("angle","102/94");
        m_proto->setValue("position","102/93");
        m_proto->setValue("eq","102/92");
        m_proto->setValue("up","102/91");
        m_proto->setValue("volume_up","102/90");
        m_proto->setValue("left","102/89");
        m_proto->setValue("enter","102/87");
        m_proto->setValue("right","102/86");
        m_proto->setValue("down","102/85");
        m_proto->setValue("volume_down","102/84");
        m_proto->setValue("topmenu","102/83");
        m_proto->setValue("menu","102/82");
        m_proto->setValue("pscan","102/81");
        m_proto->setValue("src","102/80");
        m_proto->setValue("change","102/79");
        m_proto->setValue("mode","102/78");
        m_proto->setValue("clear","102/76");
        m_proto->setValue("zero","102/0");
        m_proto->setValue("one","102/1");
        m_proto->setValue("two","102/2");
        m_proto->setValue("three","102/3");
        m_proto->setValue("four","102/4");
        m_proto->setValue("five","102/5");
        m_proto->setValue("six","102/6");
        m_proto->setValue("seven","102/7");
        m_proto->setValue("eight","102/8");
        m_proto->setValue("nine","102/9");
        m_proto->setValue("dvdcommandstop","105/88/0");
        m_proto->endGroup();

        m_proto->beginGroup("calibration");

        m_proto->setValue("bar_stop","100/32/100");
        m_proto->setValue("bar_reset","100/32/101");
        m_proto->setValue("bar_up","100/32/102");
        m_proto->setValue("bar_down","100/32/103");
        m_proto->setValue("bar_min","100/32/104");
        m_proto->setValue("bar_max","100/32/105");

        m_proto->setValue("tv_stop","100/32/100");
        m_proto->setValue("tv_reset","100/32/106");
        m_proto->setValue("tv_up","100/32/107");
        m_proto->setValue("tv_down","100/32/108");
        m_proto->setValue("tv_min","100/32/109");
        m_proto->setValue("tv_max","100/32/110");

        m_proto->setValue("es1_stop","100/32/100");
        m_proto->setValue("es1_reset","100/32/111");
        m_proto->setValue("es1_up","100/32/112");
        m_proto->setValue("es1_down","100/32/113");
        m_proto->setValue("es1_min","100/32/114");
        m_proto->setValue("es1_max","100/32/115");


        m_proto->setValue("es2_stop","100/32/100");
        m_proto->setValue("es2_reset","100/32/116");
        m_proto->setValue("es2_up","100/32/117");
        m_proto->setValue("es2_down","100/32/118");
        m_proto->setValue("es2_min","100/32/119");
        m_proto->setValue("es2_max","100/32/120");

        m_proto->setValue("first_drawer_stop","101/15/100");
        m_proto->setValue("first_drawer_reset","101/15/101");
        m_proto->setValue("first_drawer_up","101/15/102");
        m_proto->setValue("first_drawer_down","101/15/103");
        m_proto->setValue("first_drawer_min","101/15/104");
        m_proto->setValue("first_drawer_max","101/15/105");


        m_proto->setValue("second_drawer_stop","102/14/100");
        m_proto->setValue("second_drawer_reset","102/14/101");
        m_proto->setValue("second_drawer_up","102/14/102");
        m_proto->setValue("second_drawer_down","102/14/103");
        m_proto->setValue("second_drawer_min","102/14/104");
        m_proto->setValue("second_drawer_max","102/14/105");

        m_proto->setValue("third_drawer_stop","103/10/100");
        m_proto->setValue("third_drawer_reset","103/10/116");
        m_proto->setValue("third_drawer_up","103/10/117");
        m_proto->setValue("third_drawer_down","103/10/118");
        m_proto->setValue("third_drawer_min","103/10/119");
        m_proto->setValue("third_drawer_max","103/10/120");

        m_proto->setValue("fourth_drawer_stop","104/9/100");
        m_proto->setValue("fourth_drawer_reset","104/9/116");
        m_proto->setValue("fourth_drawer_up","104/9/117");
        m_proto->setValue("fourth_drawer_down","104/9/118");
        m_proto->setValue("fourth_drawer_min","104/9/119");
        m_proto->setValue("fourth_drawer_max","104/9/120");


        m_proto->setValue("third_footrest1_stop","103/10/100");
        m_proto->setValue("third_footrest1_reset","103/10/101");
        m_proto->setValue("third_footrest1_up","103/10/102");
        m_proto->setValue("third_footrest1_down","103/10/103");
        m_proto->setValue("third_footrest1_min","103/10/104");
        m_proto->setValue("third_footrest1_max","103/10/105");


        m_proto->setValue("third_footrest2_stop","103/10/100");
        m_proto->setValue("third_footrest2_reset","103/10/106");
        m_proto->setValue("third_footrest2_up","103/10/107");
        m_proto->setValue("third_footrest2_down","103/10/108");
        m_proto->setValue("third_footrest2_min","103/10/109");
        m_proto->setValue("third_footrest2_max","103/10/110");


        m_proto->setValue("fourth_footrest1_stop","104/9/100");
        m_proto->setValue("fourth_footrest1_reset","104/9/101");
        m_proto->setValue("fourth_footrest1_up","104/9/102");
        m_proto->setValue("fourth_footrest1_down","104/9/103");
        m_proto->setValue("fourth_footrest1_min","104/9/104");
        m_proto->setValue("fourth_footrest1_max","104/9/105");


        m_proto->setValue("fourth_footrest2_stop","104/9/100");
        m_proto->setValue("fourth_footrest2_reset","104/9/106");
        m_proto->setValue("fourth_footrest2_up","104/9/107");
        m_proto->setValue("fourth_footrest2_down","104/9/108");
        m_proto->setValue("fourth_footrest2_min","104/9/109");
        m_proto->setValue("fourth_footrest2_max","104/9/110");


        m_proto->setValue("third_table_stop","103/10/100");
        m_proto->setValue("third_table_reset","103/10/111");
        m_proto->setValue("third_table_up","103/10/112");
        m_proto->setValue("third_table_down","103/10/113");
        m_proto->setValue("third_table_min","103/10/114");
        m_proto->setValue("third_table_max","103/10/115");


        m_proto->setValue("fourth_table_stop","104/9/100");
        m_proto->setValue("fourth_table_reset","104/9/111");
        m_proto->setValue("fourth_table_up","104/9/112");
        m_proto->setValue("fourth_table_down","104/9/113");
        m_proto->setValue("fourth_table_min","104/9/114");
        m_proto->setValue("fourth_table_max","104/9/115");

        m_proto->setValue("first_head_set","101/111");
        m_proto->setValue("first_head_forward","101/111");
        m_proto->setValue("first_head_backward","101/111");
        m_proto->setValue("first_head_min","101/111");
        m_proto->setValue("first_head_max","101/111");

        m_proto->setValue("second_head_set","102/111");
        m_proto->setValue("second_head_forward","102/111");
        m_proto->setValue("second_head_backward","102/111");
        m_proto->setValue("second_head_min","102/111");
        m_proto->setValue("second_head_max","102/111");

        m_proto->endGroup();

        m_proto->beginGroup("macro_variables");
        //ti means time interval
        m_proto->setValue("table_ti",9000);
        m_proto->setValue("footrest_ti",10000);
        m_proto->setValue("curtain_ti",5000);
        m_proto->setValue("espresso_ti",5000);
        m_proto->setValue("tv_ti",10000);
        m_proto->setValue("samsung_tv_ti",100);
        m_proto->setValue("media_ti",300);
        m_proto->setValue("drawer_ti",10000);
        m_proto->setValue("screen_ti",10000);
        m_proto->setValue("bar_ti",10000);

        m_proto->setValue("seatback_one_ti",4000);
        m_proto->setValue("seatback_two_ti",8000);
        m_proto->setValue("seatback_last_ti",12000);

        m_proto->setValue("seat_one_ti",4000);
        m_proto->setValue("seat_two_ti",8000);
        m_proto->setValue("seat_last_ti",12000);

        m_proto->setValue("seathead_one_ti",4000);
        m_proto->setValue("seathead_two_ti",8000);
        m_proto->setValue("seathead_last_ti",12000);
        m_proto->setValue("sunroof_ti",10000);


        m_proto->endGroup();

        m_proto->beginGroup("macros");

        m_proto->setValue("first_table_open","1:1:key:first_seat/table_open:wait_key:table_ti:key:first_seat/table_stop");
        m_proto->setValue("first_table_close","2:1:key:first_seat/table_close:wait_key:table_ti:key:first_seat/table_stop");

        m_proto->setValue("second_table_open","3:1:key:second_seat/table_open:wait_key:table_ti:key:second_seat/table_stop");
        m_proto->setValue("second_table_close","4:1:key:second_seat/table_close:wait_key:table_ti:key:second_seat/table_stop");

        m_proto->setValue("third_table_open","5:1:key:third_seat/table_open:wait_key:table_ti:key:third_seat/table_stop");
        m_proto->setValue("third_table_close","6:1:key:third_seat/table_close:wait_key:table_ti:key:third_seat/table_stop");


        m_proto->setValue("fourth_table_open","7:1:key:fourth_seat/table_open:wait_key:table_ti:key:fourth_seat/table_stop");
        m_proto->setValue("fourth_table_close","8:1:key:fourth_seat/table_close:wait_key:table_ti:key:fourth_seat/table_stop");

        m_proto->setValue("fifth_table_open","9:1:key:fifth_seat/table_open:wait_key:table_ti:key:fifth_seat/table_stop");
        m_proto->setValue("fifth_table_close","10:1:key:fifth_seat/table_close:wait_key:table_ti:key:fifth_seat/table_stop");

        m_proto->setValue("sixth_table_open","11:0");
        m_proto->setValue("sixth_table_close","12:0");


        m_proto->setValue("left_table_open","13:1:key:third_seat/table_open:wait_key:table_ti:key:third_seat/table_stop");
        m_proto->setValue("left_table_close","14:1:key:third_seat/table_close:wait_key:table_ti:key:third_seat/table_stop");

        m_proto->setValue("right_table_open","15:1:key:fourth_seat/table_open:wait_key:table_ti:key:fourth_seat/table_stop");
        m_proto->setValue("right_table_close","16:1:key:fourth_seat/table_close:wait_key:table_ti:key:fourth_seat/table_stop");

        m_proto->setValue("first_seat_footrest_open","17:1:key:first_seat/footrest_open:wait_key:footrest_ti:key:first_seat/footrest_stop");
        m_proto->setValue("first_seat_footrest_close","18:1:key:first_seat/footrest_close:wait_key:footrest_ti:key:first_seat/footrest_stop");

        m_proto->setValue("second_seat_footrest_open","19:1:key:second_seat/footrest_open:wait_key:footrest_ti:key:second_seat/footrest_stop");
        m_proto->setValue("second_seat_footrest_close","20:1:key:second_seat/footrest_close:wait_key:footrest_ti:key:second_seat/footrest_stop");

        m_proto->setValue("third_seat_footrest_open","21:1:key:third_seat/footrest_open:wait_key:footrest_ti:key:third_seat/footrest_stop");
        m_proto->setValue("third_seat_footrest_close","22:1:key:third_seat/footrest_close:wait_key:footrest_ti:key:thrid_seat/footrest_stop");

        m_proto->setValue("fourth_seat_footrest_open","23:1:key:fourth_seat/footrest_open:wait_key:footrest_ti:key:fourth_seat/footrest_stop");
        m_proto->setValue("fourth_seat_footrest_close","24:1:key:fourth_seat/footrest_close:wait_key:footrest_ti:key:fourth_seat/footrest_stop");

        m_proto->setValue("fifth_seat_footrest_open","25:1:key:fifth_seat/footrest_open:wait_key:footrest_ti:key:fifth_seat/footrest_stop");
        m_proto->setValue("fifth_seat_footrest_close","26:1:key:fifth_seat/footrest_close:wait_key:footrest_ti:key:fifth_seat/footrest_stop");

        m_proto->setValue("sixth_seat_footrest_open","27:1:key:sixth_seat/footrest_open:wait_key:footrest_ti:key:sixth_seat/footrest_stop");
        m_proto->setValue("sixth_seat_footrest_close","28:1:key:sixth_seat/footrest_close:wait_key:footrest_ti:key:sixth_seat/footrest_stop");

        m_proto->setValue("left_seat_footrest_open","29:1:key:first_seat/footrest_open:wait_key:footrest_ti:key:first_seat/footrest_stop");
        m_proto->setValue("left_seat_footrest_close","30:1:key:first_seat/footrest_close:wait_key:footrest_ti:key:first_seat/footrest_stop");

        m_proto->setValue("right_seat_footrest_open","31:1:key:second_seat/footrest_open:wait_key:footrest_ti:key:second_seat/footrest_stop");
        m_proto->setValue("right_seat_footrest_close","32:1:key:second_seat/footrest_close:wait_key:footrest_ti:key:second_seat/footrest_stop");

        m_proto->setValue("first_curtain_open","33:1:key:first_seat/curtain_open:wait_key:curtain_ti:key:first_seat/curtain_stop");
        m_proto->setValue("first_curtain_close","34:1:key:first_seat/curtain_close:wait_key:curtain_ti:key:first_seat/curtain_stop");

        m_proto->setValue("second_curtain_open","35:1:key:second_seat/curtain_open:wait_key:curtain_ti:key:second_seat/curtain_stop");
        m_proto->setValue("second_curtain_close","36:1:key:second_seat/curtain_close:wait_key:curtain_ti:key:second_seat/curtain_stop");

        m_proto->setValue("third_curtain_open","37:1:key:third_seat/curtain_open:wait_key:curtain_ti:key:third_seat/curtain_stop");
        m_proto->setValue("third_curtain_close","38:1:key:third_seat/curtain_close:wait_key:curtain_ti:key:third_seat/curtain_stop");

        m_proto->setValue("fourth_curtain_open","39:1:key:fourth_seat/curtain_open:wait_key:curtain_ti:key:fourth_seat/curtain_stop");
        m_proto->setValue("fourth_curtain_close","40:1:key:fourth_seat/curtain_close:wait_key:curtain_ti:key:fourth_seat/curtain_stop");

        m_proto->setValue("fifth_curtain_open","41:1:key:fifth_seat/curtain_open:wait_key:curtain_ti:key:fifth_seat/curtain_stop");
        m_proto->setValue("fifth_curtain_close","42:1:key:fifth_seat/curtain_close:wait_key:curtain_ti:key:fifth_seat/curtain_stop");

        m_proto->setValue("sixth_curtain_open","43:1:key:sixth_seat/curtain_open:wait_key:curtain_ti:key:fifth_seat/curtain_stop");
        m_proto->setValue("sixth_curtain_close","44:1:key:sixth_seat/curtain_close:wait_key:curtain_ti:key:sixth_seat/curtain_stop");

        m_proto->setValue("right_curtain_open","45:1:key:first_seat/curtain_open:wait_key:curtain_ti:key:first_seat/curtain_stop");
        m_proto->setValue("right_curtain_close","46:1:key:first_seat/curtain_close:wait_key:curtain_ti:key:first_seat/curtain_stop");

        m_proto->setValue("left_curtain_open","47:1:key:second_seat/curtain_open:wait_key:curtain_ti:key:second_seat/curtain_stop");
        m_proto->setValue("left_curtain_close","48:1:key:second_seat/curtain_close:wait_key:curtain_ti:key:second_seat/curtain_stop");


        m_proto->setValue("first_seat_massage_open","49:1:key:first_seat/massage_onoff");
        m_proto->setValue("first_seat_massage_close","50:1:key:first_seat/massage_onoff");


        m_proto->setValue("second_seat_massage_open","51:1:key:second_seat/massage_onoff");
        m_proto->setValue("second_seat_massage_close","52:1:key:second_seat/massage_onoff");

        m_proto->setValue("third_seat_massage_open","53:1:key:third_seat/massage_onoff");
        m_proto->setValue("thrid_seat_massage_close","54:1:key:third_seat/massage_onoff");

        m_proto->setValue("fourth_seat_massage_open","55:1:key:fourth_seat/massage_onoff");
        m_proto->setValue("fourth_seat_massage_close","56:1:key:fourth_seat/massage_onoff");

        m_proto->setValue("fifth_seat_massage_open","57:1:key:fourth_seat/massage_onoff");
        m_proto->setValue("fifth_seat_massage_close","58:1:key:fourth_seat/massage_onoff");

        m_proto->setValue("sixth_seat_massage_open","59:1:key:sixth_seat/massage_onoff");
        m_proto->setValue("sixth_seat_massage_close","60:1:key:sixth_seat/massage_onoff");

        m_proto->setValue("right_seat_massage_open","61:1:key:first_seat/massage_onoff");
        m_proto->setValue("right_seat_massage_close","62:1:key:first_seat/massage_onoff");

        m_proto->setValue("left_seat_massage_open","63:1:key:second_seat/massage_onoff");
        m_proto->setValue("left_seat_massage_close","64:1:key:second_seat/massage_onoff");

        m_proto->setValue("espresso_open","65:1:key:controls/espresso_open:wait_key:espresso_ti:key:controls/espresso_stop");
        m_proto->setValue("espresso_close","66:1:key:controls/espresso_close:wait_key:espresso_ti:key:controls/espresso_stop");

        m_proto->setValue("front_espresso_open","67:0");
        m_proto->setValue("front_espresso_close","68:0");

        m_proto->setValue("rear_espresso_open","69:0");
        m_proto->setValue("rear_espresso_close","70:0");

        m_proto->setValue("door_open","71:1:key:controls/right_door");
        m_proto->setValue("door_close","72:1:key:controls/right_door");

        m_proto->setValue("right_door_open","73:1:key:controls/right_door");
        m_proto->setValue("right_door_close","74:1:key:controls/right_door");

        m_proto->setValue("left_door_open","75:1:key:controls/left_door");
        m_proto->setValue("left_door_close","76:1:key:controls/left_door");

        m_proto->setValue("tv_up","77:1:key:controls/screen_up:wait_key:tv_ti:key:controls/screen_stop");
        m_proto->setValue("tv_down","78:1:key:controls/screen_down:wait_key:tv_ti:key:controls/screen_stop");

        m_proto->setValue("tv_open","79:1:key:controls/screen_up:wait_key:tv_ti:key:controls/screen_stop");
        m_proto->setValue("tv_close","80:1:key:controls/screen_down:wait_key:tv_ti:key:controls/screen_stop");

        m_proto->setValue("tv_volume_up","81:1:key:samsung_tv/volume_up:wait_key:samsung_tv_ti:key:samsung_tv/release_code");
        m_proto->setValue("tv_volume_down","82:1:key:samsung_tv/volumen_down:wait_key:samsung_tv_ti:key:samsung_tv/release_code");

        m_proto->setValue("open_apple_tv","83:1:key:apple_tv/source");

        m_proto->setValue("front_camera_open","84:1:key:media/ready_divide:wait_key:media_ti:key:media/front_camera");
        m_proto->setValue("rear_camera_open","85:1:key:media/ready_divide:wait_key:media_ti:key:media/rear_camera");

        m_proto->setValue("screen_divider_open","86:1:key:media/ready_divide");
        m_proto->setValue("dvd_open","87:1:key:media/ready_divide:wait_key:media_ti:key:media/dvd_player");
        m_proto->setValue("computer_projection","88:1:key:media/hdmi");
        m_proto->setValue("samsung_dock_projection","89:1:key:media/dockingstation");

        //@todo : function keyword kullanımı karar aşamasında
        m_proto->setValue("turn_on_lights_white","90:1:function:white_lights");
        m_proto->setValue("turn_on_lights_red","91:1:function:red_lights");
        m_proto->setValue("turn_on_lights_green","92:1:function:green_lights");
        m_proto->setValue("turn_on_lights_blue","93:1:function:blue_lights");
        m_proto->setValue("turn_off_lights","94:1:function:turnoff_lights");

        m_proto->setValue("ceiling_lights_white_turn_on","95:1:function:cl_white_lights");
        m_proto->setValue("ceiling_lights_red_turn_on","96:1:function:cl_red_lights");
        m_proto->setValue("ceiling_lights_green_turn_on","97:1:function:cl_green_lights");
        m_proto->setValue("ceiling_lights_blue_turn_on","98:1:function:cl_blue_lights");
        m_proto->setValue("ceiling_lights_turn_off","99:1:function:cl_turn_off");

        m_proto->setValue("inside_lights_white_turn_on","100:1:function:il_white_lights");
        m_proto->setValue("inside_lights_red_turn_on","101:1:function:il_red_lights");
        m_proto->setValue("inside_lights_green_turn_on","102:1:function:il_green_lights");
        m_proto->setValue("inside_lights_blue_turn_on","103:1:function:il_blue_lights");
        m_proto->setValue("inside_lights_turn_off","104:1:function:il_turn_off");

        m_proto->setValue("side_lights_white_turn_on","105:1:function:side_white_lights");
        m_proto->setValue("side_lights_red_turn_on","106:1:function:side_red_lights");
        m_proto->setValue("side_lights_green_turn_on","107:1:function:side_green_lights");
        m_proto->setValue("side_lights_blue_turn_on","108:1:function:side_blue_lights");
        m_proto->setValue("side_lights_turn_off","109:1:function:side_turn_off");

        m_proto->setValue("left_make_up_lights_turn_on","110:0");
        m_proto->setValue("left_make_up_lights_turn_off","111:0");
        m_proto->setValue("right_make_up_lights_turn_on","112:0");
        m_proto->setValue("right_make_up_lights_turn_off","113:0");

        m_proto->setValue("right_reading_lights_turn_on","114:0");
        m_proto->setValue("right_reading_lights_turn_off","115:0");
        m_proto->setValue("left_reading_lights_turn_on","116:0");
        m_proto->setValue("left_reading_lights_turn_off","117:0");

        m_proto->setValue("right_drawer_open","118:1:key:second_seat/drawer_open:wait_key/drawer_ti/key:second_seat/drawer_stop");
        m_proto->setValue("right_drawer_close","119:1:key:second_seat/drawer_close:wait_key/drawer_ti/key:second_seat/drawer_stop");
        m_proto->setValue("left_drawer_open","120:1:key:first_seat/drawer_open:wait_key/drawer_ti/key:first_seat/drawer_stop");
        m_proto->setValue("left_drawer_close","121:1:key:first_seat/drawer_close:wait_key/drawer_ti/key:first_seat/drawer_stop");

        m_proto->setValue("airconditioner_turn_on","122:0");
        m_proto->setValue("airconditioner_turn_off","123:0");
        m_proto->setValue("airconditioner_degree_increase","124:1:key:controls/can_ai_degree_up");
        m_proto->setValue("airconditioner_degree_decrease","125:1:key:controls/can_ai_degree_down");
        m_proto->setValue("airconditioner_fan_increase","126:1:key:controls/can_ai_fan_up");
        m_proto->setValue("airconditioner_fan_decrease","127:1:key:controls/can_ai_fan_down");

        m_proto->setValue("fridge_degree_increase","128:0");
        m_proto->setValue("fridge_degree_decrease","129:0");
        m_proto->setValue("front_fridge_degree_increase","130:0");
        m_proto->setValue("front_fridge_degree_decrease","131:0");
        m_proto->setValue("rear_fridge_degree_increase","132:0");
        m_proto->setValue("rear_fridge_degree_decrease","133:0");

        m_proto->setValue("bottles_open","134:0");
        m_proto->setValue("bottles_close","135:0");
        m_proto->setValue("glasses_open","136:0");
        m_proto->setValue("glasses_close","137:0");

        m_proto->setValue("radio_channel_change","138:0");
        m_proto->setValue("radio_channel_forward","139:0");
        m_proto->setValue("radio_channel_backward","140:0");

        m_proto->setValue("roof_monitor_open","141:1:key:media/back_monitor");
        m_proto->setValue("roof_monitor_close","142:1:key:media/back_monitor");
        m_proto->setValue("rear_tv_open","143:0");
        m_proto->setValue("rear_tv_close","144:0");

        m_proto->setValue("bar_open","145:1:key:controls/bar_up:wait_key:bar_ti:key:controls/bar_stop");
        m_proto->setValue("bar_close","146:1:key:controls/bar_down:wait_key:bar_ti:key:controls/bar_stop");


        //First Seat

        m_proto->setValue("first_seat_back_osf","147:1:key:first_seat/back_forward:wait_key:seatback_one_ti:key:first_seat/back_stop");
        m_proto->setValue("first_seat_back_tsf","148:1:key:first_seat/back_forward:wait_key:seatback_two_ti:key:first_seat/back_stop");
        m_proto->setValue("first_seat_back_lsf","149:1:key:first_seat/back_forward:wait_key:seatback_last_ti:key:first_seat/back_stop");

        m_proto->setValue("first_seat_back_osb","150:1:key:first_seat/back_backward:wait_key:seatback_one_ti:key:first_seat/back_stop");
        m_proto->setValue("first_seat_back_tsb","151:1:key:first_seat/back_backward:wait_key:seatback_two_ti:key:first_seat/back_stop");
        m_proto->setValue("first_seat_back_lsb","151:1:key:first_seat/back_backward:wait_key:seatback_last_ti:key:first_seat/back_stop");

        m_proto->setValue("first_seat_osf","153:1:key:first_seat/seat_forward:wait_key:seat_one_ti:key:first_seat/seat_stop");
        m_proto->setValue("first_seat_tsf","154:1:key:first_seat/seat_forward:wait_key:seat_two_ti:key:first_seat/seat_stop");
        m_proto->setValue("first_seat_lsf","155:1:key:first_seat/seat_forward:wait_key:seat_last_ti:key:first_seat/seat_stop");

        m_proto->setValue("first_seat_osb","156:1:key:first_seat/seat_backward:wait_key:seat_one_ti:key:first_seat/seat_stop");
        m_proto->setValue("first_seat_tsb","157:1:key:first_seat/seat_backward:wait_key:seat_two_ti:key:first_seat/seat_stop");
        m_proto->setValue("first_seat_lsb","158:1:key:first_seat/seat_backward:wait_key:seat_last_ti:key:first_seat/seat_stop");

        m_proto->setValue("first_seat_head_osf","159:1:key:first_seat/head_forward:wait_key:seathead_one_ti:key:first_seat/head_stop");
        m_proto->setValue("first_seat_head_tsf","160:1:key:first_seat/head_forward:wait_key:seathead_two_ti:key:first_seat/head_stop");
        m_proto->setValue("first_seat_head_lsf","161:1:key:first_seat/head_forward:wait_key:seathead_last_ti:key:first_seat/head_stop");

        m_proto->setValue("first_seat_head_osb","162:1:key:first_seat/head_backward:wait_key:seathead_one_ti:key:first_seat/head_stop");
        m_proto->setValue("first_seat_head_tsb","163:1:key:first_seat/head_backward:wait_key:seathead_two_ti:key:first_seat/head_stop");
        m_proto->setValue("first_seat_head_lsb","164:1:key:first_seat/head_backward:wait_key:seathead_last_ti:key:first_seat/head_stop");

        // End of First Seat
        //Second Seat

        m_proto->setValue("second_seat_back_osf","165:1:key:second_seat/back_forward:wait_key:seatback_one_ti:key:second_seat/back_stop");
        m_proto->setValue("second_seat_back_tsf","166:1:key:second_seat/back_forward:wait_key:seatback_two_ti:key:second_seat/back_stop");
        m_proto->setValue("second_seat_back_lsf","167:1:key:second_seat/back_forward:wait_key:seatback_last_ti:key:second_seat/back_stop");

        m_proto->setValue("second_seat_back_osb","168:1:key:second_seat/back_backward:wait_key:seatback_one_ti:key:second_seat/back_stop");
        m_proto->setValue("second_seat_back_tsb","169:1:key:second_seat/back_backward:wait_key:seatback_two_ti:key:second_seat/back_stop");
        m_proto->setValue("second_seat_back_lsb","170:1:key:second_seat/back_backward:wait_key:seatback_last_ti:key:second_seat/back_stop");

        m_proto->setValue("second_seat_osf","171:1:key:second_seat/seat_forward:wait_key:seat_one_ti:key:second_seat/seat_stop");
        m_proto->setValue("second_seat_tsf","172:1:key:second_seat/seat_forward:wait_key:seat_two_ti:key:second_seat/seat_stop");
        m_proto->setValue("second_seat_lsf","173:1:key:second_seat/seat_forward:wait_key:seat_last_ti:key:second_seat/seat_stop");

        m_proto->setValue("second_seat_osb","174:1:key:second_seat/seat_backward:wait_key:seat_one_ti:key:second_seat/seat_stop");
        m_proto->setValue("second_seat_tsb","175:1:key:second_seat/seat_backward:wait_key:seat_two_ti:key:second_seat/seat_stop");
        m_proto->setValue("second_seat_lsb","176:1:key:second_seat/seat_backward:wait_key:seat_last_ti:key:second_seat/seat_stop");

        m_proto->setValue("second_seat_head_osf","177:1:key:second_seat/head_forward:wait_key:seathead_one_ti:key:second_seat/head_stop");
        m_proto->setValue("second_seat_head_tsf","178:1:key:second_seat/head_forward:wait_key:seathead_two_ti:key:second_seat/head_stop");
        m_proto->setValue("second_seat_head_lsf","179:1:key:second_seat/head_forward:wait_key:seathead_last_ti:key:second_seat/head_stop");

        m_proto->setValue("second_seat_head_osb","180:1:key:second_seat/head_backward:wait_key:seathead_one_ti:key:second_seat/head_stop");
        m_proto->setValue("second_seat_head_tsb","181:1:key:second_seat/head_backward:wait_key:seathead_two_ti:key:second_seat/head_stop");
        m_proto->setValue("second_seat_head_lsb","182:1:key:second_seat/head_backward:wait_key:seathead_last_ti:key:second_seat/head_stop");

        // End of Second Seat


        //Third Seat

        m_proto->setValue("third_seat_back_osf","183:1:key:third_seat/back_forward:wait_key:seatback_one_ti:key:third_seat/back_stop");
        m_proto->setValue("third_seat_back_tsf","184:1:key:third_seat/back_forward:wait_key:seatback_two_ti:key:third_seat/back_stop");
        m_proto->setValue("third_seat_back_lsf","185:1:key:third_seat/back_forward:wait_key:seatback_last_ti:key:third_seat/back_stop");

        m_proto->setValue("third_seat_back_osb","186:1:key:third_seat/back_backward:wait_key:seatback_one_ti:key:third_seat/back_stop");
        m_proto->setValue("third_seat_back_tsb","187:1:key:third_seat/back_backward:wait_key:seatback_two_ti:key:third_seat/back_stop");
        m_proto->setValue("third_seat_back_lsb","188:1:key:third_seat/back_backward:wait_key:seatback_last_ti:key:third_seat/back_stop");

        m_proto->setValue("third_seat_osf","189:1:key:third_seat/seat_forward:wait_key:seat_one_ti:key:third_seat/seat_stop");
        m_proto->setValue("third_seat_tsf","190:1:key:third_seat/seat_forward:wait_key:seat_two_ti:key:third_seat/seat_stop");
        m_proto->setValue("third_seat_lsf","191:1:key:third_seat/seat_forward:wait_key:seat_last_ti:key:third_seat/seat_stop");

        m_proto->setValue("third_seat_osb","192:1:key:third_seat/seat_backward:wait_key:seat_one_ti:key:third_seat/seat_stop");
        m_proto->setValue("third_seat_tsb","193:1:key:third_seat/seat_backward:wait_key:seat_two_ti:key:third_seat/seat_stop");
        m_proto->setValue("third_seat_lsb","194:1:key:third_seat/seat_backward:wait_key:seat_last_ti:key:third_seat/seat_stop");

        m_proto->setValue("third_seat_head_osf","195:1:key:third_seat/head_forward:wait_key:seathead_one_ti:key:third_seat/head_stop");
        m_proto->setValue("third_seat_head_tsf","196:1:key:third_seat/head_forward:wait_key:seathead_two_ti:key:third_seat/head_stop");
        m_proto->setValue("third_seat_head_lsf","197:1:key:third_seat/head_forward:wait_key:seathead_last_ti:key:third_seat/head_stop");

        m_proto->setValue("third_seat_head_osb","198:1:key:third_seat/head_backward:wait_key:seathead_one_ti:key:third_seat/head_stop");
        m_proto->setValue("third_seat_head_tsb","199:1:key:third_seat/head_backward:wait_key:seathead_two_ti:key:third_seat/head_stop");
        m_proto->setValue("third_seat_head_lsb","200:1:key:third_seat/head_backward:wait_key:seathead_last_ti:key:third_seat/head_stop");

        // End of Third Seat

        //fourth Seat

        m_proto->setValue("fourth_seat_back_osf","201:1:key:fourth_seat/back_forward:wait_key:seatback_one_ti:key:fourth_seat/back_stop");
        m_proto->setValue("fourth_seat_back_tsf","202:1:key:fourth_seat/back_forward:wait_key:seatback_two_ti:key:fourth_seat/back_stop");
        m_proto->setValue("fourth_seat_back_lsf","203:1:key:fourth_seat/back_forward:wait_key:seatback_last_ti:key:fourth_seat/back_stop");

        m_proto->setValue("fourth_seat_back_osb","204:1:key:fourth_seat/back_backward:wait_key:seatback_one_ti:key:fourth_seat/back_stop");
        m_proto->setValue("fourth_seat_back_tsb","205:1:key:fourth_seat/back_backward:wait_key:seatback_two_ti:key:fourth_seat/back_stop");
        m_proto->setValue("fourth_seat_back_lsb","206:1:key:fourth_seat/back_backward:wait_key:seatback_last_ti:key:fourth_seat/back_stop");

        m_proto->setValue("fourth_seat_osf","207:1:key:fourth_seat/seat_forward:wait_key:seat_one_ti:key:fourth_seat/seat_stop");
        m_proto->setValue("fourth_seat_tsf","208:1:key:fourth_seat/seat_forward:wait_key:seat_two_ti:key:fourth_seat/seat_stop");
        m_proto->setValue("fourth_seat_lsf","209:1:key:fourth_seat/seat_forward:wait_key:seat_last_ti:key:fourth_seat/seat_stop");

        m_proto->setValue("fourth_seat_osb","210:1:key:fourth_seat/seat_backward:wait_key:seat_one_ti:key:fourth_seat/seat_stop");
        m_proto->setValue("fourth_seat_tsb","211:1:key:fourth_seat/seat_backward:wait_key:seat_two_ti:key:fourth_seat/seat_stop");
        m_proto->setValue("fourth_seat_lsb","212:1:key:fourth_seat/seat_backward:wait_key:seat_last_ti:key:fourth_seat/seat_stop");

        m_proto->setValue("fourth_seat_head_osf","213:1:key:fourth_seat/head_forward:wait_key:seathead_one_ti:key:fourth_seat/head_stop");
        m_proto->setValue("fourth_seat_head_tsf","214:1:key:fourth_seat/head_forward:wait_key:seathead_two_ti:key:fourth_seat/head_stop");
        m_proto->setValue("fourth_seat_head_lsf","215:1:key:fourth_seat/head_forward:wait_key:seathead_last_ti:key:fourth_seat/head_stop");

        m_proto->setValue("fourth_seat_head_osb","216:1:key:fourth_seat/head_backward:wait_key:seathead_one_ti:key:fourth_seat/head_stop");
        m_proto->setValue("fourth_seat_head_tsb","217:1:key:fourth_seat/head_backward:wait_key:seathead_two_ti:key:fourth_seat/head_stop");
        m_proto->setValue("fourth_seat_head_lsb","218:1:key:fourth_seat/head_backward:wait_key:seathead_last_ti:key:fourth_seat/head_stop");

        // End of fourth Seat

        //fifth Seat

        m_proto->setValue("fifth_seat_back_osf","219:1:key:fifth_seat/back_forward:wait_key:seatback_one_ti:key:fifth_seat/back_stop");
        m_proto->setValue("fifth_seat_back_tsf","220:1:key:fifth_seat/back_forward:wait_key:seatback_two_ti:key:fifth_seat/back_stop");
        m_proto->setValue("fifth_seat_back_lsf","221:1:key:fifth_seat/back_forward:wait_key:seatback_last_ti:key:fifth_seat/back_stop");

        m_proto->setValue("fifth_seat_back_osb","222:1:key:fifth_seat/back_backward:wait_key:seatback_one_ti:key:fifth_seat/back_stop");
        m_proto->setValue("fifth_seat_back_tsb","223:1:key:fifth_seat/back_backward:wait_key:seatback_two_ti:key:fifth_seat/back_stop");
        m_proto->setValue("fifth_seat_back_lsb","224:1:key:fifth_seat/back_backward:wait_key:seatback_last_ti:key:fifth_seat/back_stop");

        m_proto->setValue("fifth_seat_osf","225:1:key:fifth_seat/seat_forward:wait_key:seat_one_ti:key:fifth_seat/seat_stop");
        m_proto->setValue("fifth_seat_tsf","226:1:key:fifth_seat/seat_forward:wait_key:seat_two_ti:key:fifth_seat/seat_stop");
        m_proto->setValue("fifth_seat_lsf","227:1:key:fifth_seat/seat_forward:wait_key:seat_last_ti:key:fifth_seat/seat_stop");

        m_proto->setValue("fifth_seat_osb","228:1:key:fifth_seat/seat_backward:wait_key:seat_one_ti:key:fifth_seat/seat_stop");
        m_proto->setValue("fifth_seat_tsb","229:1:key:fifth_seat/seat_backward:wait_key:seat_two_ti:key:fifth_seat/seat_stop");
        m_proto->setValue("fifth_seat_lsb","230:1:key:fifth_seat/seat_backward:wait_key:seat_last_ti:key:fifth_seat/seat_stop");

        m_proto->setValue("fifth_seat_head_osf","231:1:key:fifth_seat/head_forward:wait_key:seathead_one_ti:key:fifth_seat/head_stop");
        m_proto->setValue("fifth_seat_head_tsf","232:1:key:fifth_seat/head_forward:wait_key:seathead_two_ti:key:fifth_seat/head_stop");
        m_proto->setValue("fifth_seat_head_lsf","233:1:key:fifth_seat/head_forward:wait_key:seathead_last_ti:key:fifth_seat/head_stop");

        m_proto->setValue("fifth_seat_head_osb","234:1:key:fifth_seat/head_backward:wait_key:seathead_one_ti:key:fifth_seat/head_stop");
        m_proto->setValue("fifth_seat_head_tsb","235:1:key:fifth_seat/head_backward:wait_key:seathead_two_ti:key:fifth_seat/head_stop");
        m_proto->setValue("fifth_seat_head_lsb","236:1:key:fifth_seat/head_backward:wait_key:seathead_last_ti:key:fifth_seat/head_stop");

        // End of fifth Seat

        //sixth Seat

        m_proto->setValue("sixth_seat_back_osf","237:1:key:sixth_seat/back_forward:wait_key:seatback_one_ti:key:sixth_seat/back_stop");
        m_proto->setValue("sixth_seat_back_tsf","238:1:key:sixth_seat/back_forward:wait_key:seatback_two_ti:key:sixth_seat/back_stop");
        m_proto->setValue("sixth_seat_back_lsf","239:1:key:sixth_seat/back_forward:wait_key:seatback_last_ti:key:sixth_seat/back_stop");

        m_proto->setValue("sixth_seat_back_osb","240:1:key:sixth_seat/back_backward:wait_key:seatback_one_ti:key:sixth_seat/back_stop");
        m_proto->setValue("sixth_seat_back_tsb","241:1:key:sixth_seat/back_backward:wait_key:seatback_two_ti:key:sixth_seat/back_stop");
        m_proto->setValue("sixth_seat_back_lsb","242:1:key:sixth_seat/back_backward:wait_key:seatback_last_ti:key:sixth_seat/back_stop");

        m_proto->setValue("sixth_seat_osf","243:1:key:sixth_seat/seat_forward:wait_key:seat_one_ti:key:sixth_seat/seat_stop");
        m_proto->setValue("sixth_seat_tsf","244:1:key:sixth_seat/seat_forward:wait_key:seat_two_ti:key:sixth_seat/seat_stop");
        m_proto->setValue("sixth_seat_lsf","245:1:key:sixth_seat/seat_forward:wait_key:seat_last_ti:key:sixth_seat/seat_stop");

        m_proto->setValue("sixth_seat_osb","246:1:key:sixth_seat/seat_backward:wait_key:seat_one_ti:key:sixth_seat/seat_stop");
        m_proto->setValue("sixth_seat_tsb","247:1:key:sixth_seat/seat_backward:wait_key:seat_two_ti:key:sixth_seat/seat_stop");
        m_proto->setValue("sixth_seat_lsb","248:1:key:sixth_seat/seat_backward:wait_key:seat_last_ti:key:sixth_seat/seat_stop");

        m_proto->setValue("sixth_seat_head_osf","249:1:key:sixth_seat/head_forward:wait_key:seathead_one_ti:key:sixth_seat/head_stop");
        m_proto->setValue("sixth_seat_head_tsf","250:1:key:sixth_seat/head_forward:wait_key:seathead_two_ti:key:sixth_seat/head_stop");
        m_proto->setValue("sixth_seat_head_lsf","251:1:key:sixth_seat/head_forward:wait_key:seathead_last_ti:key:sixth_seat/head_stop");

        m_proto->setValue("sixth_seat_head_osb","252:1:key:sixth_seat/head_backward:wait_key:seathead_one_ti:key:sixth_seat/head_stop");
        m_proto->setValue("sixth_seat_head_tsb","253:1:key:sixth_seat/head_backward:wait_key:seathead_two_ti:key:sixth_seat/head_stop");
        m_proto->setValue("sixth_seat_head_lsb","254:1:key:sixth_seat/head_backward:wait_key:seathead_last_ti:key:sixth_seat/head_stop");

        // End of sixth Seat

        m_proto->setValue("luggage_curtain_open","255:1:key:controls/back_curtain_up:wait_key:curtain_ti:key:controls/back_curtain_stop");
        m_proto->setValue("luggage_curtain_open","256:1:key:controls/back_curtain_down:wait_key:curtain_ti:key:controls/back_curtain_stop");
        m_proto->setValue("all_curtain_open",
                          "257:1:"
                          "key:fourt_seat/curtain_open:"
                          "key:controls/back_curtain_up:"
                          "key:third_seat/curtain_open:"
                          "key:second_seat/curtain_open:"
                          "key:first_seat/curtain_open:"
                          "wait_key:curtain_ti:"
                          "key:fourt_seat/curtain_stop:"
                          "key:controls/back_curtain_stop:"
                          "key:third_seat/curtain_stop:"
                          "key:second_seat/curtain_stop:"
                          "key:first_seat/curtain_stop"
                          );
        m_proto->setValue("all_curtain_close",
                          "258:1:"
                          "key:fourt_seat/curtain_close:"
                          "key:controls/back_curtain_down:"
                          "key:third_seat/curtain_close:"
                          "key:second_seat/curtain_close:"
                          "key:first_seat/curtain_close:"
                          "wait_key:curtain_ti:"
                          "key:fourt_seat/curtain_stop:"
                          "key:controls/back_curtain_stop:"
                          "key:third_seat/curtain_stop:"
                          "key:second_seat/curtain_stop:"
                          "key:first_seat/curtain_stop"
                          );

        m_proto->setValue("first_seat_sleep_mode","260:0");
        m_proto->setValue("second_seat_sleep_mode","261:0");
        m_proto->setValue("gather_first_seat","262:0");
        m_proto->setValue("gather_second_seat","263:0");
        m_proto->setValue("cinema_mode","264:0");
        m_proto->setValue("conference_mode","265:0");
        //@todo: sonra bakılacak
        m_proto->setValue("all_tables_open","266:1:function:all_tables_open");
        m_proto->setValue("all_tables_close","267:1:function:all_tables_close");
        //end todo
        m_proto->setValue("gather_all_seats","268:0");
        //@todo: ilgili fonksiyonlar yazılacak
        m_proto->setValue("inside_lights_turn_on","269:1:function:open_inside_lights");
        m_proto->setValue("inside_lights_turn_off","270:1:function:close_inside_lights");
        m_proto->setValue("side_lights_turn_on","271:1:function:open_side_lights");
        m_proto->setValue("side_lights_turn_off","272:1:function:close_side_lights");
        m_proto->setValue("ceiling_lights_turn_on","273:1:function:open_ceiling_lights");
        m_proto->setValue("ceiling_lights_turn_off","274:1:function:close_ceiling_lights");

        m_proto->setValue("sunroof_open","275:1:key:controls/sunroof_up:wait_key:sunroof_ti:key:controls/sunroof_stop");
        m_proto->setValue("sunroof_close","276:1:key:controls/sunroof_down:wait_key:sunroof_ti:key:controls/sunroof_stop");
        m_proto->setValue("close_system","277:1:function:close_system");
        m_proto->setValue("goto_home","278:1:function:goto_home");

        m_proto->endGroup();

    }
    this->general->sync();
    m_proto->sync();

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

QVariant SettingsManager::value(QString key)
{
   return this->general->value(key);
}

