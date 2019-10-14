import QtQuick 2.0
import ck.gmachine 1.0
import "Pages" as Pages
import "Pages/Seat" as SeatPages
import "Pages/Curtains" as CurtainPages
import "Pages/Controls" as ControlPages
import "Pages/Media" as MediaPages
import "Pages/Settings" as SettingsPages
import "Pages/Lights" as LightPages
import "Components"

/* Tüm sayfalar ve sayfa kayıtları bu dosyada bulunuyor */

Item {
    id: root
    width: 1024
    height: 668

   Logo{
        id:logo
        z:333
   }

    Pages.Home{
        id:home
        x:0
    }

    ControlPages.Controls{
        id:controls
    }


    SeatPages.Seats{
        id:seats
    }

    MediaPages.Media{
        id:media
    }

    LightPages.Lights{
        id:lights
    }

    MediaPages.Radio{
        id:radio
    }

    MediaPages.RadioManual{
        id:radiomanual
    }
    MediaPages.DVDPlayer{
        id:dvdplayer
    }

    ControlPages.Tables{
        id:tables
    }

    ControlPages.Refrigerator{
        id:refrigerator
    }

    ControlPages.SafeBox{
        id:safebox
    }


    ControlPages.AirConditioner{
        id:airconditioner
    }

    ControlPages.SmokeFan{
        id:smokefan
    }

    CurtainPages.Curtains{
        id:curtains
    }

    CurtainPages.LeftCurtain{
        id:leftcurtain
    }

    CurtainPages.RightCurtain{
        id:rightcurtain
    }
    CurtainPages.LeftCurtain2{
        id:leftcurtain2
    }

    CurtainPages.RightCurtain2{
        id:rightcurtain2
    }
    CurtainPages.LuggageCurtain{
        id:luggagecurtain
    }

    SeatPages.OneSeat{
        id:oneseat
    }

    SeatPages.SeatHead
    {
        id:seathead
    }

    SeatPages.SeatBack
    {
        id:seatback
    }

    SeatPages.SeatPart
    {
        id:seatpart
    }

    SeatPages.SeatFeet
    {
        id:seatfeet
    }
    SeatPages.SeatDrawer
    {
        id:seatdrawer
    }
    SeatPages.SeatCooling
    {
        id:seatcooling
    }
    SeatPages.SeatHeating
    {
        id:seatheating
    }
    SeatPages.SeatMassage
    {
        id:seatmassage
    }
    SeatPages.SeatThigh
    {
        id:seatthigh
    }

    ControlPages.Espresso
    {
        id:espresso
    }

    ControlPages.Bar
    {
        id:bar
    }

    ControlPages.Roof
    {
        id:roof
    }

    ControlPages.Windows{
        id:windows
    }

    MediaPages.Cameras
    {
        id:cameras
    }

    MediaPages.FrontCamera
    {
        id:frontcamera
    }

    MediaPages.RearCamera
    {
        id:rearcamera
    }

    MediaPages.DockingStation
    {
        id:dockingstation
    }

    MediaPages.ScreenDivider
    {
        id:screendivider
    }

    MediaPages.Playstation
    {
        id:playstation
    }

    MediaPages.Television
    {
        id:television
    }
    MediaPages.HdmiInput
    {
        id:hdmiinput
    }
    MediaPages.PcHdmi{
        id:pchdmi
    }
    MediaPages.KodiMediaPlayer{
        id:kodimediaplayer
    }

    MediaPages.AppleTv{
        id:appletv
    }

    MediaPages.CeilingScreen
    {
        id:ceilingscreen
    }

    SettingsPages.Settings{
        id:settings
    }
    SettingsPages.MediaSettings{
        id:mediasettings
    }
    SettingsPages.SerialSettings{
        id:serialsettings
    }
    SettingsPages.GeneralSettings{
        id:generalsettings
    }
    SettingsPages.CalibrationSettings{
        id:calibration
    }
    SettingsPages.BarMotorCalibration{
        id:barmotorcalibration
    }
    SettingsPages.TvMotorCalibration{
        id:tvmotorcalibration
    }
    SettingsPages.EspressoMotor1{
        id:espressomotor1
    }
    SettingsPages.EspressoMotor2{
        id:espressomotor2
    }
    SettingsPages.FirstSeatHead{
        id:firstseathead
    }
    SettingsPages.SecondSeatHead{
        id:secondseathead
    }
    SettingsPages.DrawerMotor1{
        id:drawermotor1
    }
    SettingsPages.DrawerMotor2{
        id:drawermotor2
    }
    SettingsPages.DrawerMotor3{
        id:drawermotor3
    }
    SettingsPages.DrawerMotor4{
        id:drawermotor4
    }
    SettingsPages.ThirdFootrestM1{
        id:thirdfootrestm1
    }
    SettingsPages.ThirdFootrestM2{
        id:thirdfootrestm2
    }
    SettingsPages.FourthFootrest1{
        id:fourthfootrest1
    }
    SettingsPages.FourthFootrest2{
        id:fourthfootrest2
    }
    SettingsPages.ThirdTableCalibration{
        id:thirdtablecalibration
    }
    SettingsPages.FourthTableCalibration{
        id:fourthtablecalibration
    }
    SettingsPages.RestoreOlderVersion{
        id:restoreolderversion
    }





    Component.onCompleted: {
        GSystem.logoItm = logo;
        GSystem.addPageItem("Home",home);
        GSystem.addPageItem("Seats",seats);
        GSystem.addPageItem("Controls",controls);
        GSystem.addPageItem("Media",media);
        GSystem.addPageItem("Lights",lights);
        GSystem.addPageItem("Radio",radio);
        GSystem.addPageItem("RadioManual",radiomanual);
        GSystem.addPageItem("Tables",tables);
        GSystem.addPageItem("Refrigerator",refrigerator);
        GSystem.addPageItem("SafeBox",safebox);
        GSystem.addPageItem("AirConditioner",airconditioner);
        GSystem.addPageItem("SmokeFan",smokefan);
        GSystem.addPageItem("Curtains",curtains);
        GSystem.addPageItem("LeftCurtain",leftcurtain);
        GSystem.addPageItem("RightCurtain",rightcurtain);
        GSystem.addPageItem("LuggageCurtain",luggagecurtain);
        GSystem.addPageItem("OneSeat",oneseat);
        GSystem.addPageItem("SeatHead",seathead);
        GSystem.addPageItem("SeatBack",seatback);
        GSystem.addPageItem("SeatPart",seatpart);
        GSystem.addPageItem("SeatFeet",seatfeet);
        GSystem.addPageItem("SeatHeating",seatheating);
        GSystem.addPageItem("SeatCooling",seatcooling);
        GSystem.addPageItem("SeatMassage",seatmassage);
        GSystem.addPageItem("SeatDrawer",seatdrawer);
        GSystem.addPageItem("SeatThigh",seatthigh);
        GSystem.addPageItem("LeftCurtain2",leftcurtain2);
        GSystem.addPageItem("RightCurtain2",rightcurtain2);
        GSystem.addPageItem("Espresso",espresso);
        GSystem.addPageItem("Bar",bar);
        GSystem.addPageItem("Roof",roof);
        GSystem.addPageItem("Cameras",cameras);
        GSystem.addPageItem("FrontCamera",frontcamera);
        GSystem.addPageItem("RearCamera",rearcamera);
        GSystem.addPageItem("DockingStation",dockingstation);
        GSystem.addPageItem("ScreenDivider",screendivider);
        GSystem.addPageItem("KodiMediaPlayer",kodimediaplayer);
        GSystem.addPageItem("CeilingScreen",ceilingscreen);
        GSystem.addPageItem("PlayStation",playstation);
        GSystem.addPageItem("Television",television);
        GSystem.addPageItem("PcHdmi",pchdmi);
        GSystem.addPageItem("Windows",windows);
        GSystem.addPageItem("Settings",settings);
        GSystem.addPageItem("GeneralSettings",generalsettings);
        GSystem.addPageItem("Calibration",calibration);
        GSystem.addPageItem("BarMotorCalibration",barmotorcalibration);
        GSystem.addPageItem("TvMotorCalibration",tvmotorcalibration);
        GSystem.addPageItem("EspressoMotor1",espressomotor1);
        GSystem.addPageItem("EspressoMotor2",espressomotor2);
        GSystem.addPageItem("DrawerMotor1",drawermotor1);
        GSystem.addPageItem("DrawerMotor2",drawermotor2);
        GSystem.addPageItem("DrawerMotor3",drawermotor3);
        GSystem.addPageItem("DrawerMotor4",drawermotor4);
        GSystem.addPageItem("ThirdFootrestM1",thirdfootrestm1);
        GSystem.addPageItem("ThirdFootrestM2",thirdfootrestm2);
        GSystem.addPageItem("FourthFootrest1",fourthfootrest1);
        GSystem.addPageItem("FourthFootrest2",fourthfootrest2);
        GSystem.addPageItem("ThirdTableCalibration",thirdtablecalibration);
        GSystem.addPageItem("FourthTableCalibration",fourthtablecalibration);
        GSystem.addPageItem("RestoreOlderVersion",restoreolderversion);
        GSystem.addPageItem("MediaSettings",mediasettings);
        GSystem.addPageItem("SerialSettings",serialsettings);
        GSystem.addPageItem("AppleTv",appletv);
        GSystem.addPageItem("DVDPlayer",dvdplayer);
        GSystem.addPageItem("FirstSeatHead",firstseathead);
        GSystem.addPageItem("SecondSeatHead",secondseathead);
    }

}
