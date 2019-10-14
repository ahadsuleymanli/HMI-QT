pragma Singleton
import QtQuick 2.0
import "scripts/mainfuncs.js" as MainMdl
import "scripts/simplex-noise.js" as SimplexMdl
import "scripts/ether.js" as Ether
import QtWebSockets 1.0
import VRService 1.0
import QtQml 2.0
import closx.smanager 1.0
/* Global fonksiyonlar, değişkenler ve durumlar(states) bu sayfada bulunuyor. */


Item {
    id:root
    property string activePage: "Home"
    property string prevPage: "Not"
    property int bottomIconHight: 65 //eski deger: 85
    property int bottomIconWidth: 90 //eski deger: 110
    property string radioMode: "FM"
    property string prevRadioMode: "NONE"
    property int lang: SM.lang

    signal pageChange(string pageName)
    property Item currentPageItm
    property Item prevPageItm
    property Item logoItm
    property alias myriadpro :myriadpro
    property alias myriadproita :myriadpro
    property alias centurygothic :centurygothic
    property alias voice_service:voice_service
    property var phistory
    property int selectedSeat: -1
    property string selectedSeatText:""

    //Icon carousel menu
    property int leftMenuHeight: 480
    property int leftMenuWidth: 246
    property int leftMenuSpacing: 25
    property string leftMenuColor: "transparent"
    //End Icon Carousel Menu

    //text menu
    property int leftTextMenuHeight: 430
    property int leftTextMenuWidth: 246
    property int leftTextMenuSpacing: 20
    property string leftTextMenuColor: "transparent"
    property color leftTextMenuItemColor: Qt.rgba(0,0,0,0.1)
    property color leftTextMenuItemPressedColor: Qt.rgba(0/255, 108/255, 128/255,0.6)
    //end text menu

    property alias oneSeatModel: oneSeatModel
    property alias oneSeatRightModel: oneSeatRightModel
    property alias mediaModel: mediaModel
    property alias infoverlayModel: infoverlayModel
    property alias controlsModel: controlsModel
    property alias lightsModel: lightsModel
    property Item info;
    property Item rstarter;
    property Item infoverlay;

    onLangChanged: function(){
        voice_service.setLang(root.lang);
    }

    function sendSeatCommand(key)
    {
                    switch(root.selectedSeat)
                    {
                    case 1:
                        serial_mng.sendKey("first_seat/"+key);
                        break;
                    case 2:
                        serial_mng.sendKey("second_seat/"+key);
                        break;
                    case 3:
                        serial_mng.sendKey("third_seat/"+key);
                        break;
                    case 4:
                        serial_mng.sendKey("fourth_seat/"+key);
                        break;
                    default:
                        return false;
                    }
                    return true;
    }

    function seatPagePass()
    {
                    switch(root.selectedSeat)
                    {
                    case 1:
                        serial_mng.sendKey("first_seat/pagepass")
                        break;
                    case 2:
                        serial_mng.sendKey("second_seat/pagepass")
                        break;
                    case 3:
                        serial_mng.sendKey("third_seat/pagepass")
                        break;
                    case 4:
                        serial_mng.sendKey("fourth_seat/pagepass")
                        break;
                    }

    }

    function setInfo(p_info)
    {
        info = p_info;
    }
    function setRestarter(p_rstarter){
        rstarter = p_rstarter
    }
    function setInfoverlay(p_infoverlay){
        infoverlay = p_infoverlay
    }

    function selectedSeatToText()
    {
        switch(root.selectedSeat)
        {
        case 1:
            return qsTr("FIRST");
        case 2:
            return qsTr("SECOND");
        case 3:
            return qsTr("THIRD");
        case 4:
            return qsTr("FOURTH");
        case 5:
            return qsTr("Unknown");
        }
    }

    SettingsManager{
        id:smngr
    }


    function systemOnOff()
    {
        if(SM.demomode)
        {
        serial_mng.sendKey("main/setclock",false,root.delay,(Qt.formatDateTime(new Date(), "h")*1 + smngr.value("main/hourdiff")*1)+ ":" + (Qt.formatDateTime(new Date(), "m")*1 + smngr.value("main/mindiff")*1));
            switch(serial_mng.systemstate)
            {
                case -1:
                    serial_mng.systemstate = 1;
                break;
                case 0:
                    serial_mng.systemstate = 1;
                    break;
                case 1:
                    serial_mng.systemstate = 0;
                    break;
                default:
            }
            return;

        }else{
            serial_mng.sendKey("main/setclock",false,root.delay,(Qt.formatDateTime(new Date(), "h")*1 + smngr.value("main/hourdiff")*1)+ ":" + (Qt.formatDateTime(new Date(), "m")*1 + smngr.value("main/mindiff")*1));
                        serial_mng.sendKey("main/system_onoff");
                        serial_mng.sendKey("main/system_feedback");
        }


    }

    function systemFeedback()
    {
        if(SM.demomode)
        {
            switch(serial_mng.system_state)
            {
                case -1:
                    serial_mng.system_state = 1;
                break;
                case 0:
                    serial_mng.system_state = 1;
                    break;
                case 1:
                    serial_mng.system_state = 0;
                    break;
                default:
            }
            return;
        }

    }

    property bool aniInited : false;
   FontLoader {
        id: myriadpro
        source: "qrc:/design/fonts/myriad-pro/MYRIADPRO-REGULAR.OTF"
    }
   FontLoader {
        id: myriadproita
        source: "qrc:/design/fonts/myriad-pro/MYRIADPRO-CONDIT.OTF"
    }
   FontLoader {
        id: centurygothic
        source: "qrc:/design/fonts/century-gothic/CenturyGothic.ttf"
    }
    onSelectedSeatChanged: {
        oneSeatModel.clear();
        oneSeatRightModel.clear();
        oneSeatModel.append({name:qsTr("Head"),st:"SeatHead",isvis:true});
        oneSeatModel.append({name:qsTr("SeatBack"),st:"SeatBack",isvis:true});
        oneSeatModel.append({name:qsTr("Seat"),st:"SeatPart",isvis:true});
        if(SM.seatDrawer(selectedSeat) === true)
        {
            oneSeatModel.append({name:qsTr("Drawer"),st:"SeatDrawer",isvis:true});
        }
        if(SM.seatFootrest(selectedSeat) === true)
        {
            oneSeatModel.append({name:qsTr("Foot Rest"),st:"SeatFeet",isvis:true});
        }
        if(SM.seatThigh(selectedSeat) === true)
        {
            oneSeatRightModel.append({name:qsTr("Thigh"),st:"SeatThigh",isvis:true});
        }
        if( SM.seatHeating(selectedSeat) === true)
        {
            oneSeatRightModel.append({name:qsTr("Seat Heating"),st:"SeatHeating"});
        }
        if( SM.seatCooling(selectedSeat) === true)
        {
            oneSeatRightModel.append({name:qsTr("Seat Cooling"),st:"SeatCooling"});
        }
        if( SM.seatMassage(selectedSeat) === true)
        {
            oneSeatRightModel.append({name:qsTr("Seat Massage"),st:"SeatMassage"});
        }
    }

    function createLightsModel(){
        lightsModel.clear();
        lightsModel.append({name:qsTr("Ceiling Light"),target:1,selected:false});
        lightsModel.append({name:qsTr("Inside Light"),target:2,selected:false});
        if(SM.slboolean === true){
            lightsModel.append({name:qsTr("Side Light"),target:3,selected:false});
        }
    }

    function createMediaModel()
    {
        mediaModel.clear();
        if(SM.mediaplayertype === 1)
        {
        mediaModel.append(
                    {
            name: qsTr("Kodi Player"),
            st: "KodiMediaPlayer",
            bg: "qrc:/design/media/leftmenu/kodiplayer.png"
                    }
                    );
        }
        if(SM.mediaplayertype === 2)
        {
        mediaModel.append(
                    {
                    name: qsTr("Apple Tv"),
                    st: "AppleTv",
                    bg: "qrc:/design/media/leftmenu/appletv.png"
                    }
                    );
        }
        if(SM.playstation === true)
        {
        mediaModel.append(
                    {

                    name: qsTr("Playstation"),
                    st: "PlayStation",
                    bg: "qrc:/design/media/leftmenu/playstation.png"

                    }
                    );
        }

        if(SM.dockingstation === true)
        {
        mediaModel.append(
                   {
                    name: qsTr("Docking Stations"),
                    st: "DockingStation",
                    bg: "qrc:/design/media/leftmenu/dockingstation.png"
                    }
                    );
        }
        mediaModel.append(
                   {
                        name: qsTr("Screen Divider"),
                        st: "ScreenDivider",
                        bg: "qrc:/design/media/leftmenu/screendivider.png"
                    }
                    );
        mediaModel.append(
                   {
                    name: qsTr("Television"),
                    st: "Television",
                    bg: "qrc:/design/media/leftmenu/tv.png"
                    }
                    );
        if(SM.radio === true)
        {
        mediaModel.append(
                   {
                    name: qsTr("Radio"),
                    st: "Radio",
                    bg: "qrc:/design/media/leftmenu/radio.png"
                    }
                    );
        }
        mediaModel.append(
                   {
                    name: qsTr("Pc Hdmi"),
                    st: "PcHdmi",
                    bg: "qrc:/design/media/leftmenu/hdmipc.png"
                    }
                    );
        if(SM.ceilingscreen)
        {
            mediaModel.append(
                   {
                    name: qsTr("Ceiling Screen"),
                    st: "CeilingScreen",
                    bg: "qrc:/design/media/leftmenu/ceiling_screen.png"
                    }
                    );

        }
        if(SM.dvdplayer)
        {
            mediaModel.append(
                   {
                    name: qsTr("DVD Player"),
                    st: "DVDPlayer",
                    bg: "qrc:/design/media/leftmenu/dvdplayer.png"
                    }
                    );

        }
    }
    function createControlsModel()
    {
        controlsModel.clear();
        controlsModel.append(
                    {
                     name:qsTr("Tables"),
                     st:"Tables",
                     bg: "qrc:/design/controls/leftmenu/tables.png"
                    }
                 );
    if(SM.curtains)
    {
        controlsModel.append(
    {
        name: qsTr("Curtains"),
        st: "Curtains",
        bg: "qrc:/design/controls/leftmenu/curtains.png"
    }
                    );
    }
     if(SM.refrigerator)
     {
        controlsModel.append(
        {
        name: qsTr("Refrigerator"),
        st: "Refrigerator",
        bg: "qrc:/design/controls/leftmenu/refrigerator.png"
        }
                    );
     }
     if(SM.safebox)
     {
        controlsModel.append(
        {
        name: qsTr("Safe Box"),
        st: "SafeBox",
        bg: "qrc:/design/controls/leftmenu/safebox.png"
        }
                    );

     }

        controlsModel.append(
    {
        name: qsTr("Air Condition"),
        st: "AirConditioner",
        bg: "qrc:/design/controls/leftmenu/airconditioner.png"
    }
                    );
        controlsModel.append(
    {
        name: qsTr("Smoke Fan"),
        st: "SmokeFan",
        bg: "qrc:/design/controls/leftmenu/smokefan.png"
    }
                    );

        controlsModel.append(
    {
        name: qsTr("Windows"),
        st: "Windows",
        bg: "qrc:/design/controls/leftmenu/windows.png"
    }
    );
     if(SM.bar)
     {
        controlsModel.append(
                    {
        name: qsTr("Bar"),
        st: "Bar",
        bg: "qrc:/design/controls/leftmenu/bar.png"
                    }
                    );
     }
    if(SM.espresso)
    {
        controlsModel.append(
                    {
                    name: qsTr("Espresso"),
                    st: "Espresso",
                    bg: "qrc:/design/controls/leftmenu/espresso.png"
                    }
                    );
    }
     if(SM.smokefan)
        controlsModel.append(
                   {
        name: qsTr("Roof"),
        st: "Roof",
        bg: "qrc:/design/controls/leftmenu/roof.png"
                    }
                    );

    }
    function seat2com(seatno)
    {
        switch(seatno)
        {
            case 1:
            return 10;
            case 2:
            return 9;
            case 3:
            return 15;
            case 4:
            return 14;
        }
        return -1;
    }
    function com2seat(com)
    {
        switch(com)
        {
            case 10:
            return 1;
            case 9:
            return 2;
            case 15:
            return 3;
            case 14:
            return 4;
        }
        return -1;
    }

    function initAnim(a,b)
    {
        Ether.setup(a,b);
        aniInited = true;
    }
    function isContextReady(a,b)
    {
        var acon = a.getContext("2d");
        var bcon = b.getContext("2d");
        if(acon && bcon)
        {
            return true;
        }
        return false;
    }
    function drawAnim()
    {
        Ether.draw();
    }
    function randRect(item)
    {
            var ctx = item.getContext("2d");
            ctx.fillStyle = Qt.rgba(1, 0, 0, 1);
            ctx.clearRect(0,0,item.width,item.height);
            ctx.fillRect( (Math.random() * 1000) % item.width, (Math.random() * 1000) % item.height, 100, 100);
            item.requestAnimationFrame(item.requestPaint);
    }

    function changePage(pageName,saveHistory)
    {
        if(pageSwipe.running)
        {
            return;
        }
        if(typeof saveHistory === "undefined") saveHistory = true;
            console.log("SGlobal.changePage("+pageName+")");

        if(root.activePage !== pageName)
        {
            root.prevPage = root.activePage
            if(saveHistory)
            {
                phistory.push(root.prevPage);
                if(phistory.length > 10)
                {
                phistory.shift();
                }
            nvidia_conn_manager.setUsersLastPage(pageName);
            }
            root.activePage = pageName;
            root.currentPageItm = getPageItem(pageName);
            root.prevPageItm = getPageItem(root.prevPage);
            pageSwipe.start();
            if(root.currentPageItm.init)
            {
                root.currentPageItm.init();
            }
            if(root.prevPageItm.end)
            {
                root.prevPageItm.end();
            }
            //root.pageChange(pageName);
        }

    }

    function goBack()
    {
        if(phistory.length > 0)
        {
            var page = phistory.pop();
            changePage(page,false);
        }else{
           changePage("Home");
        }
    }

    function getPageItem(pageName)
    {
        var pageItem = MainMdl.getPage(pageName);
        if(typeof pageItem !== "undefined") return pageItem;
    }

    function addPageItem(pageName,item)
    {
        MainMdl.addPage(pageName,item);
    }
    property var pageAry

    state: "Home"

    states: [
                "Home"
            ,
                "Seats"
            ,
                "Controls"
            ,
                "Media"
            ,
                "Lights"
            ,
                "Radio"
            ,
                "RadioManual"
            ,
                "Tables"
            ,
                "Refrigerator"
            ,
                "SafeBox"
            ,
                "AirConditioner"
            ,
                "SmokeFan"
            ,
                "Curtains"
            ,
                "LeftCurtain"
            ,
                "RightCurtain"
            ,
                "LeftCurtain2"
            ,
                "RightCurtain2"
            ,
                "LuggageCurtain"
            ,
                "OneSeat"
            ,
                "SeatHead"
            ,
                "SeatBack"
            ,
                "SeatPart"
            ,
                "SeatFeet"
            ,
                "SeatDrawer"
            ,
                "SeatThigh"
            ,
                "SeatCooling"
            ,
                "SeatHeating"
            ,
                "SeatMassage"
            ,
                "Espresso"
            ,
                "Bar"
            ,
                "Roof"
            ,
                "Cameras"
            ,
                "FrontCamera"
            ,
                "RearCamera"
            ,
                "DockingStation"
            ,
                "ScreenDivider"
            ,
                "KodiMediaPlayer"
            ,
                "PlayStation"
            ,
                "Television"
            ,
                "PcHdmi"
            ,
                "Windows"
            ,
                "Settings"
            ,
                "GeneralSettings"
            ,
                "Calibration"
            ,
                "BarMotorCalibration"
            ,
                "DrawerMotor1"
            ,
                "DrawerMotor2"
            ,
                "EspressoMotor1"
            ,
                "EspressoMotor2"
            ,
                "FootrestMotor1"
            ,
                "FootrestMotor2"
            ,
                "FirstSeatHead"
            ,
                "SecondSeatHead"
            ,
                "TvMotorCalibration"
            ,
                "MediaSettings"
            ,
                "SerialSettings"
            ,
                "AppleTv"
            ,
                "CeilingScreen"
            ,
                "DVDPlayer"

            ]
    ListModel {
                id: oneSeatModel

                ListElement {
                   name: qsTr("Head")
                   st: "SeatHead"
                   isvis: true
                }
                ListElement {
                   name: qsTr("Back")
                   isvis: true
                   st: "SeatBack"
                }
                ListElement {
                   name: qsTr("Seat")
                   isvis: true
                   st: "SeatPart"
                }
                ListElement {
                   name: qsTr("Foot Rest")
                   isvis: false
                   st: "SeatFeet"
                }
                ListElement {
                   name: qsTr("Drawer")
                   isvis: false
                   st: "SeatDrawer"
                }
            }
    ListModel {
                id: oneSeatRightModel
            }

ListModel {
    id: controlsModel
    ListElement {
       name: QT_TR_NOOP("Tables")
       st: "Tables"
       bg: "qrc:/design/controls/leftmenu/tables.png"
    }
    ListElement {
        name: QT_TR_NOOP("Curtains")
        st: "Curtains"
        bg: "qrc:/design/controls/leftmenu/curtains.png"
    }
    ListElement {
        name: QT_TR_NOOP("Refrigerator")
        st: "Refrigerator"
        bg: "qrc:/design/controls/leftmenu/refrigerator.png"
    }
    ListElement {
        name: QT_TR_NOOP("Safe Box")
        st: "SafeBox"
        bg: "qrc:/design/controls/leftmenu/safebox.png"
    }
    ListElement {
        name: QT_TR_NOOP("Air Condition")
        st: "AirConditioner"
        bg: "qrc:/design/controls/leftmenu/airconditioner.png"
    }
    ListElement {
        name: QT_TR_NOOP("Smoke Fan")
        st: "SmokeFan"
        bg: "qrc:/design/controls/leftmenu/smokefan.png"
    }
    ListElement {
        name: QT_TR_NOOP("Windows")
        st: "Windows"
        bg: "qrc:/design/controls/leftmenu/windows.png"
    }
    ListElement {
        name: QT_TR_NOOP("Bar")
        st: "Bar"
        bg: "qrc:/design/controls/leftmenu/bar.png"
    }
    ListElement {
        name: QT_TR_NOOP("Espresso")
        st: "Espresso"
        bg: "qrc:/design/controls/leftmenu/espresso.png"
    }
    ListElement {
        name: QT_TR_NOOP("Roof")
        st: "Roof"
        bg: "qrc:/design/controls/leftmenu/roof.png"
    }
}
    ListView {
        model: controlsModel
        delegate: Text {
            text: qsTr(model.name) + mytrans.emptyString
        }
    }

ListModel{
    id: lightsModel
    ListElement{
        name:QT_TR_NOOP("Ceiling Light")
        target:1
        selected:false
    }
    ListElement{
        name:QT_TR_NOOP("Inside Light")
        target:2
        selected:false
    }
    ListElement{
        name:QT_TR_NOOP("Side Light")
        target:3
        selected:false
    }
}

ListModel {
    id: mediaModel
    ListElement {
       name: qsTr("Kodi Player")
        st: "KodiMediaPlayer"
       bg: "qrc:/design/media/leftmenu/kodiplayer.png"
    }
    ListElement {
        name: qsTr("Playstation")
        st: "PlayStation"
        bg: "qrc:/design/media/leftmenu/playstation.png"
    }
    ListElement {
        name: qsTr("Docking Stations")
        st: "DockingStation"
        bg: "qrc:/design/media/leftmenu/dockingstation.png"
    }
    ListElement {
        name: qsTr("Screen Divider")
        st: "ScreenDivider"
        bg: "qrc:/design/media/leftmenu/screendivider.png"
    }
    ListElement {
        name: qsTr("Television")
        st: "Television"
        bg: "qrc:/design/media/leftmenu/tv.png"
    }
    ListElement {
        name: qsTr("Radio")
        st: "Radio"
        bg: "qrc:/design/media/leftmenu/radio.png"
    }
    ListElement {
        name: qsTr("Pc Hdmi")
        st: "PcHdmi"
        bg: "qrc:/design/media/leftmenu/hdmipc.png"
    }
}




    ListModel {
        id: infoverlayModel
        ListElement {
            command: qsTr("First table open")
            action: qsTr("Opens the First Table")
        }
        ListElement {
            command: qsTr("First table close")
            action: qsTr("Closes the First Table")
        }
        ListElement {
            command: qsTr("Second table open")
            action: qsTr("Opens the Second Table")
        }
        ListElement {
            command: qsTr("Second table close")
            action: qsTr("Closes the Second Table")
        }
        ListElement {
            command: qsTr("Third table open")
            action: qsTr("Opens the Third Table")
        }
        ListElement {
            command: qsTr("Third table close")
            action: qsTr("Closes the Third Table")
        }
        ListElement {
            command: qsTr("Fourth table open")
            action: qsTr("Opens the Fourth Table")
        }
        ListElement {
            command: qsTr("Fourth table close")
            action: qsTr("Closes the Fourth Table")
        }
        ListElement {
            command: qsTr("Fifth table open")
            action: qsTr("Opens the Fifth Table")
        }
        ListElement {
            command: qsTr("Fifth table close")
            action: qsTr("Closes the Fifth Table")
        }
        ListElement {
            command: qsTr("Sixth table open")
            action: qsTr("Opens the Sixth Table")
        }
        ListElement {
            command: qsTr("Sixth table close")
            action: qsTr("Closes the Sixth Table")
        }
        ListElement {
            command: qsTr("Left table open")
            action: qsTr("Opens the Left Table")
        }
        ListElement {
            command: qsTr("Left table close")
            action: qsTr("Closes the Left Table")
        }
        ListElement {
            command: qsTr("Right table open")
            action: qsTr("Opens the Right Table")
        }
        ListElement {
            command: qsTr("Right table close")
            action: qsTr("Closes the Right Table")
        }




        ListElement {
            command: qsTr("First seat footrest open")
            action: qsTr("Opens the First seat footrest")
        }
        ListElement {
            command: qsTr("First seat footrest close")
            action: qsTr("Closes the First seat footrest")
        }
        ListElement {
            command: qsTr("Second seat footrest open")
            action: qsTr("Opens the Second seat footrest")
        }
        ListElement {
            command: qsTr("Second seat footrest close")
            action: qsTr("Closes the Second seat footrest")
        }
        ListElement {
            command: qsTr("Third seat footrest open")
            action: qsTr("Opens the Third seat footrest")
        }
        ListElement {
            command: qsTr("Third seat footrest close")
            action: qsTr("Closes the Third seat footrest")
        }
        ListElement {
            command: qsTr("Fourth seat footrest open")
            action: qsTr("Opens the Fourth seat footrest")
        }
        ListElement {
            command: qsTr("Fourth seat footrest close")
            action: qsTr("Closes the Fourth seat footrest")
        }
        ListElement {
            command: qsTr("Fifth seat footrest open")
            action: qsTr("Opens the Fifth seat footrest")
        }
        ListElement {
            command: qsTr("Fifth seat footrest close")
            action: qsTr("Closes the Fifth seat footrest")
        }
        ListElement {
            command: qsTr("Sixth seat footrest open")
            action: qsTr("Opens the Sixth seat footrest")
        }
        ListElement {
            command: qsTr("Sixth seat footrest close")
            action: qsTr("Closes the Sixth seat footrest")
        }
        ListElement {
            command: qsTr("Right seat footrest open")
            action: qsTr("Opens the Right seat footrest")
        }
        ListElement {
            command: qsTr("Right seat footrest close")
            action: qsTr("Closes the Right seat footrest")
        }
        ListElement {
            command: qsTr("Left seat footrest open")
            action: qsTr("Opens the Left seat footrest")
        }
        ListElement {
            command: qsTr("Left seat footrest close")
            action: qsTr("Closes the Left seat footrest")
        }




        ListElement {
            command: qsTr("First Curtain open")
            action: qsTr("Opens the First Curtain")
        }
        ListElement {
            command: qsTr("First Curtain close")
            action: qsTr("Closes the First Curtain")
        }
        ListElement {
            command: qsTr("Second Curtain open")
            action: qsTr("Opens the Second Curtain")
        }
        ListElement {
            command: qsTr("Second Curtain close")
            action: qsTr("Closes the Second Curtain")
        }
        ListElement {
            command: qsTr("Third Curtain open")
            action: qsTr("Opens the Third Curtain")
        }
        ListElement {
            command: qsTr("Third Curtain close")
            action: qsTr("Closes the Third Curtain")
        }
        ListElement {
            command: qsTr("Fourth Curtain open")
            action: qsTr("Opens the Fourth Curtain")
        }
        ListElement {
            command: qsTr("Fourth Curtain close")
            action: qsTr("Closes the Fourth Curtain")
        }
        ListElement {
            command: qsTr("Fifth Curtain open")
            action: qsTr("Opens the Fifth Curtain")
        }
        ListElement {
            command: qsTr("Fifth Curtain close")
            action: qsTr("Closes the Fifth Curtain")
        }
        ListElement {
            command: qsTr("Sixth Curtain open")
            action: qsTr("Opens the Sixth Curtain")
        }
        ListElement {
            command: qsTr("Sixth Curtain close")
            action: qsTr("Closes the Sixth Curtain")
        }
        ListElement {
            command: qsTr("Right Curtain open")
            action: qsTr("Opens the Right Curtain")
        }
        ListElement {
            command: qsTr("Right Curtain close")
            action: qsTr("Closes the Right Curtain")
        }
        ListElement {
            command: qsTr("Left Curtain open")
            action: qsTr("Opens the Left Curtain")
        }
        ListElement {
            command: qsTr("Left Curtain close")
            action: qsTr("Closes the Left Curtain")
        }





        ListElement {
            command: qsTr("First Seat Massage open")
            action: qsTr("Opens the First Seat Massage")
        }
        ListElement {
            command: qsTr("First Seat Massage close")
            action: qsTr("Closes the First Seat Massage")
        }
        ListElement {
            command: qsTr("Second Seat Massage open")
            action: qsTr("Opens the Second Seat Massage")
        }
        ListElement {
            command: qsTr("Second Seat Massage close")
            action: qsTr("Closes the Second Seat Massage")
        }
        ListElement {
            command: qsTr("Third Seat Massage open")
            action: qsTr("Opens the Third Seat Massage")
        }
        ListElement {
            command: qsTr("Third Seat Massage close")
            action: qsTr("Closes the Third Seat Massage")
        }
        ListElement {
            command: qsTr("Fourth Seat Massage open")
            action: qsTr("Opens the Fourth Seat Massage")
        }
        ListElement {
            command: qsTr("Fourth Seat Massage close")
            action: qsTr("Closes the Fourth Seat Massage")
        }
        ListElement {
            command: qsTr("Fifth Seat Massage open")
            action: qsTr("Opens the Fifth Seat Massage")
        }
        ListElement {
            command: qsTr("Fifth Seat Massage close")
            action: qsTr("Closes the Fifth Seat Massage")
        }
        ListElement {
            command: qsTr("Sixth Seat Massage open")
            action: qsTr("Opens the Sixth Seat Massage")
        }
        ListElement {
            command: qsTr("Sixth Seat Massage close")
            action: qsTr("Closes the Sixth Seat Massage")
        }
        ListElement {
            command: qsTr("Right Seat Massage open")
            action: qsTr("Opens the Right Seat Massage")
        }
        ListElement {
            command: qsTr("Right Seat Massage close")
            action: qsTr("Closes the Right Seat Massage")
        }
        ListElement {
            command: qsTr("Left Seat Massage open")
            action: qsTr("Opens the Left Seat Massage")
        }
        ListElement {
            command: qsTr("Left Seat Massage close")
            action: qsTr("Closes the Left Seat Massage")
        }





        ListElement {
            command: qsTr("Nespresso open")
            action: qsTr("Opens the Nespresso")
        }
        ListElement {
            command: qsTr("Nespresso close")
            action: qsTr("Closes the Nespresso")
        }
        ListElement {
            command: qsTr("Front Nespresso open")
            action: qsTr("Opens the Front Nespresso")
        }
        ListElement {
            command: qsTr("Front Nespresso close")
            action: qsTr("Closes the Front Nespresso")
        }
        ListElement {
            command: qsTr("Rear Nespresso open")
            action: qsTr("Opens the Rear Nespresso")
        }
        ListElement {
            command: qsTr("Rear Nespresso close")
            action: qsTr("Closes the Rear Nespresso")
        }



        ListElement {
            command: qsTr("Door open")
            action: qsTr("Opens the Door")
        }
        ListElement {
            command: qsTr("Door close")
            action: qsTr("Closes the Door")
        }
        ListElement {
            command: qsTr("Right Door open")
            action: qsTr("Opens the Right Door")
        }
        ListElement {
            command: qsTr("Right Door close")
            action: qsTr("Closes the Right Door")
        }
        ListElement {
            command: qsTr("Left Door open")
            action: qsTr("Opens the Left Door")
        }
        ListElement {
            command: qsTr("Left Door close")
            action: qsTr("Closes the Left Door")
        }




        ListElement {
            command: qsTr("TV up")
            action: qsTr("Puts the TV up")
        }
        ListElement {
            command: qsTr("Tv down")
            action: qsTr("Puts the TV down")
        }
        ListElement {
            command: qsTr("Turn on TV")
            action: qsTr("Turns the TV on")
        }
        ListElement {
            command: qsTr("Turn on TV")
            action: qsTr("Turns the TV off")
        }
        ListElement {
            command: qsTr("TV Volume up")
            action: qsTr("Increases the TV volume")
        }
        ListElement {
            command: qsTr("TV Volume down")
            action: qsTr("Decreases the TV volume")
        }




        ListElement {
            command: qsTr("Open Apple TV")
            action: qsTr("Opens the Apple TV")
        }





        ListElement {
            command: qsTr("Front camera open")
            action: qsTr("Opens the Front Camera")
        }
        ListElement {
            command: qsTr("Rear camera open")
            action: qsTr("Opens the Rear Camera")
        }
        ListElement {
            command: qsTr("Screen divider open")
            action: qsTr("Opens the the Screen Divider")
        }
        ListElement {
            command: qsTr("DVD open")
            action: qsTr("Opens the DVD")
        }
        ListElement {
            command: qsTr("Computer projection")
            action: qsTr("Enables Computer Projection")
        }
        ListElement {
            command: qsTr("Samsung dock projection")
            action: qsTr("Enables Samsung Dock Projection")
        }




        ListElement {
            command: qsTr("Turn on lights white")
            action: qsTr("Turns white lights on")
        }
        ListElement {
            command: qsTr("Turn on lights red")
            action: qsTr("Turns red lights on")
        }
        ListElement {
            command: qsTr("Turn on lights green")
            action: qsTr("Turns green lights on")
        }
        ListElement {
            command: qsTr("Turn on lights blue")
            action: qsTr("Turns blue lights on")
        }
        ListElement {
            command: qsTr("Turn off lights")
            action: qsTr("Turns the lights off")
        }




        ListElement {
            command: qsTr("Ceiling lights white turn on")
            action: qsTr("Turns white ceiling lights on")
        }
        ListElement {
            command: qsTr("Ceiling lights red turn on")
            action: qsTr("Turns red ceiling lights on")
        }
        ListElement {
            command: qsTr("Ceiling lights green turn on")
            action: qsTr("Turns green ceiling lights on")
        }
        ListElement {
            command: qsTr("Ceiling lights blue turn on")
            action: qsTr("Turns blue ceiling lights on")
        }
        ListElement {
            command: qsTr("Ceiling lights turn off")
            action: qsTr("Turns ceiling lights off")
        }




        ListElement {
            command: qsTr("Interior lights white turn on")
            action: qsTr("Turns white Interior lights on")
        }
        ListElement {
            command: qsTr("Interior lights red turn on")
            action: qsTr("Turns red Interior lights on")
        }
        ListElement {
            command: qsTr("Interior lights green turn on")
            action: qsTr("Turns green Interior lights on")
        }
        ListElement {
            command: qsTr("Interior lights blue turn on")
            action: qsTr("Turns blue Interior lights on")
        }
        ListElement {
            command: qsTr("Interior lights turn off")
            action: qsTr("Turns Interior lights off")
        }




        ListElement {
            command: qsTr("Side lights white turn on")
            action: qsTr("Turns white Side lights on")
        }
        ListElement {
            command: qsTr("Side lights red turn on")
            action: qsTr("Turns red Side lights on")
        }
        ListElement {
            command: qsTr("Side lights green turn on")
            action: qsTr("Turns green Side lights on")
        }
        ListElement {
            command: qsTr("Side lights blue turn on")
            action: qsTr("Turns blue Side lights on")
        }
        ListElement {
            command: qsTr("Side lights turn off")
            action: qsTr("Turns Side lights off")
        }



        ListElement {
            command: qsTr("Left Make Up Lights turn on")
            action: qsTr("Turns Left Make Up Light on")
        }
        ListElement {
            command: qsTr("Left Make Up Light turn off")
            action: qsTr("Turns Left Make Up Light off")
        }
        ListElement {
            command: qsTr("Right Make Up Light turn on")
            action: qsTr("Turns Right Make Up Light on")
        }
        ListElement {
            command: qsTr("Right Make Up Light turn off")
            action: qsTr("Turns Right Make Up Light off")
        }



        ListElement {
            command: qsTr("Left Reading Lights turn on")
            action: qsTr("Turns Left Reading Light on")
        }
        ListElement {
            command: qsTr("Left Reading Light turn off")
            action: qsTr("Turns Left Reading Light off")
        }
        ListElement {
            command: qsTr("Right Reading Light turn on")
            action: qsTr("Turns Right Reading Light on")
        }
        ListElement {
            command: qsTr("Right Reading Light turn off")
            action: qsTr("Turns Right Reading Light off")
        }


        ListElement {
            command: qsTr("Right Drawer Open")
            action: qsTr("Opens the Right Drawer")
        }
        ListElement {
            command: qsTr("Right Drawer Close")
            action: qsTr("Closes the Right Drawer")
        }
        ListElement {
            command: qsTr("Left Drawer Open")
            action: qsTr("Opens the Left Drawer")
        }
        ListElement {
            command: qsTr("Left Drawer Close")
            action: qsTr("Closes the Left Drawer")
        }




        ListElement {
            command: qsTr("Air conditioner turn on")
            action: qsTr("Turns on the Air Conditioner")
        }
        ListElement {
            command: qsTr("Air conditioner turn off")
            action: qsTr("Turns off the Air Conditioner")
        }
        ListElement {
            command: qsTr("Air conditioner Degree Increase")
            action: qsTr("Increases the heat degree of AC")
        }
        ListElement {
            command: qsTr("Air conditioner Degree Decrease")
            action: qsTr("Decreases the heat degree of AC")
        }
        ListElement {
            command: qsTr("Air conditioner Fan Increase")
            action: qsTr("Increases the Fan Speed of AC")
        }
        ListElement {
            command: qsTr("Air conditioner Fan Decrease")
            action: qsTr("Decreases the Fan Speed of AC")
        }




        ListElement {
            command: qsTr("Fridge degree increase")
            action: qsTr("Increases heat of Fridge")
        }
        ListElement {
            command: qsTr("Fridge degree decrease")
            action: qsTr("Decreases heat of Fridge")
        }
        ListElement {
            command: qsTr("Front Fridge degree increase")
            action: qsTr("Increases heat of Front Fridge")
        }
        ListElement {
            command: qsTr("Front Fridge degree decrease")
            action: qsTr("Decreases heat of Front Fridge")
        }
        ListElement {
            command: qsTr("Rear Fridge degree increase")
            action: qsTr("Increases heat of Rear Fridge")
        }
        ListElement {
            command: qsTr("Rear Fridge degree decrease")
            action: qsTr("Decreases heat of Rear Fridge")
        }




        ListElement {
            command: qsTr("Bottles Open")
            action: qsTr("Opens the Bottles")
        }
        ListElement {
            command: qsTr("Bottles Close")
            action: qsTr("Closes the Bottles")
        }
        ListElement {
            command: qsTr("Glasses Open")
            action: qsTr("Opens the Glasses")
        }
        ListElement {
            command: qsTr("Glasses Close")
            action: qsTr("Closes the Glasses")
        }



        ListElement {
            command: qsTr("Radio Channel Change")
            action: qsTr("Changes the Radio Channel")
        }
        ListElement {
            command: qsTr("Radio Channel Forward")
            action: qsTr("Forwards the Radio Channel")
        }
        ListElement {
            command: qsTr("Radio Channel Backward")
            action: qsTr("Backwards the Radio Channel")
        }



        ListElement {
            command: qsTr("Roof Monitor Open")
            action: qsTr("Opens the Roof Monitor")
        }
        ListElement {
            command: qsTr("Roof Monitor Close")
            action: qsTr("Closes the Roof Monitor")
        }
        ListElement {
            command: qsTr("Rear TV Open")
            action: qsTr("Opens the Rear TV")
        }
        ListElement {
            command: qsTr("Rear TV Close")
            action: qsTr("Closes the Rear TV")
        }



        ListElement {
            command: qsTr("Bar Open")
            action: qsTr("Opens the Bar")
        }
        ListElement {
            command: qsTr("Bar Close")
            action: qsTr("Closes the Bar")
        }




        ListElement {
            command: qsTr("First seat back take one step forward")
            action: qsTr("Takes First Seat back one step forward")
        }
        ListElement {
            command: qsTr("First seat back take two step forward")
            action: qsTr("Takes First Seat back two step forward")
        }
        ListElement {
            command: qsTr("First seat back take last point forward")
            action: qsTr("Takes First Seat back last point forward")
        }
        ListElement {
            command: qsTr("First seat back take one step backward")
            action: qsTr("Takes First Seat back one step backward")
        }
        ListElement {
            command: qsTr("First seat back take two step backward")
            action: qsTr("Takes First Seat back two step backward")
        }
        ListElement {
            command: qsTr("First seat back take last point backward")
            action: qsTr("Takes First Seat back last point backward")
        }



        ListElement {
            command: qsTr("First Seat take one step forward")
            action: qsTr("Takes First Seat one step forward")
        }
        ListElement {
            command: qsTr("First Seat take two step forward")
            action: qsTr("Takes First Seat two step forward")
        }
        ListElement {
            command: qsTr("First Seat take last point forward")
            action: qsTr("Takes First Seat last point forward")
        }
        ListElement {
            command: qsTr("First Seat take one step backward")
            action: qsTr("Takes First Seat one step backward")
        }
        ListElement {
            command: qsTr("First Seat take two step backward")
            action: qsTr("Takes First Seat two step backward")
        }
        ListElement {
            command: qsTr("First Seat take last point backward")
            action: qsTr("Takes First Seat last point backward")
        }



        ListElement {
            command: qsTr("First Seat take one step forward")
            action: qsTr("Takes First Seat one step forward")
        }
        ListElement {
            command: qsTr("First Seat take two step forward")
            action: qsTr("Takes First Seat two step forward")
        }
        ListElement {
            command: qsTr("First Seat take last point forward")
            action: qsTr("Takes First Seat last point forward")
        }
        ListElement {
            command: qsTr("First Seat take one step backward")
            action: qsTr("Takes First Seat one step backward")
        }
        ListElement {
            command: qsTr("First Seat take two step backward")
            action: qsTr("Takes First Seat two step backward")
        }
        ListElement {
            command: qsTr("First Seat take last point backward")
            action: qsTr("Takes First Seat last point backward")
        }




        ListElement {
            command: qsTr("First Seat Head take one step forward")
            action: qsTr("Takes First Seat Head one step forward")
        }
        ListElement {
            command: qsTr("First Seat Head take two step forward")
            action: qsTr("Takes First Seat Head two step forward")
        }
        ListElement {
            command: qsTr("First Seat Head take last point forward")
            action: qsTr("Takes First Seat Head last point forward")
        }
        ListElement {
            command: qsTr("First Seat Head take one step backward")
            action: qsTr("Takes First Seat Head one step backward")
        }
        ListElement {
            command: qsTr("First Seat Head take two step backward")
            action: qsTr("Takes First Seat Head two step backward")
        }
        ListElement {
            command: qsTr("First Seat Head take last point backward")
            action: qsTr("Takes First Seat Head last point backward")
        }




        ListElement {
            command: qsTr("Second seat back take one step forward")
            action: qsTr("Takes Second Seat back one step forward")
        }
        ListElement {
            command: qsTr("Second seat back take two step forward")
            action: qsTr("Takes Second Seat back two step forward")
        }
        ListElement {
            command: qsTr("Second seat back take last point forward")
            action: qsTr("Takes Second Seat back last point forward")
        }
        ListElement {
            command: qsTr("Second seat back take one step backward")
            action: qsTr("Takes Second Seat back one step backward")
        }
        ListElement {
            command: qsTr("Second seat back take two step backward")
            action: qsTr("Takes Second Seat back two step backward")
        }
        ListElement {
            command: qsTr("Second seat back take last point backward")
            action: qsTr("Takes Second Seat back last point backward")
        }



        ListElement {
            command: qsTr("Second Seat take one step forward")
            action: qsTr("Takes Second Seat one step forward")
        }
        ListElement {
            command: qsTr("Second Seat take two step forward")
            action: qsTr("Takes Second Seat two step forward")
        }
        ListElement {
            command: qsTr("Second Seat take last point forward")
            action: qsTr("Takes Second Seat last point forward")
        }
        ListElement {
            command: qsTr("Second Seat take one step backward")
            action: qsTr("Takes Second Seat one step backward")
        }
        ListElement {
            command: qsTr("Second Seat take two step backward")
            action: qsTr("Takes Second Seat two step backward")
        }
        ListElement {
            command: qsTr("Second Seat take last point backward")
            action: qsTr("Takes Second Seat last point backward")
        }



        ListElement {
            command: qsTr("Second Seat take one step forward")
            action: qsTr("Takes Second Seat one step forward")
        }
        ListElement {
            command: qsTr("Second Seat take two step forward")
            action: qsTr("Takes Second Seat two step forward")
        }
        ListElement {
            command: qsTr("Second Seat take last point forward")
            action: qsTr("Takes Second Seat last point forward")
        }
        ListElement {
            command: qsTr("Second Seat take one step backward")
            action: qsTr("Takes Second Seat one step backward")
        }
        ListElement {
            command: qsTr("Second Seat take two step backward")
            action: qsTr("Takes Second Seat two step backward")
        }
        ListElement {
            command: qsTr("Second Seat take last point backward")
            action: qsTr("Takes Second Seat last point backward")
        }




        ListElement {
            command: qsTr("Second Seat Head take one step forward")
            action: qsTr("Takes Second Seat Head one step forward")
        }
        ListElement {
            command: qsTr("Second Seat Head take two step forward")
            action: qsTr("Takes Second Seat Head two step forward")
        }
        ListElement {
            command: qsTr("Second Seat Head take last point forward")
            action: qsTr("Takes Second Seat Head last point forward")
        }
        ListElement {
            command: qsTr("Second Seat Head take one step backward")
            action: qsTr("Takes Second Seat Head one step backward")
        }
        ListElement {
            command: qsTr("Second Seat Head take two step backward")
            action: qsTr("Takes Second Seat Head two step backward")
        }
        ListElement {
            command: qsTr("Second Seat Head take last point backward")
            action: qsTr("Takes Second Seat Head last point backward")
        }




        ListElement {
            command: qsTr("Third seat back take one step forward")
            action: qsTr("Takes Third Seat back one step forward")
        }
        ListElement {
            command: qsTr("Third seat back take two step forward")
            action: qsTr("Takes Third Seat back two step forward")
        }
        ListElement {
            command: qsTr("Third seat back take last point forward")
            action: qsTr("Takes Third Seat back last point forward")
        }
        ListElement {
            command: qsTr("Third seat back take one step backward")
            action: qsTr("Takes Third Seat back one step backward")
        }
        ListElement {
            command: qsTr("Third seat back take two step backward")
            action: qsTr("Takes Third Seat back two step backward")
        }
        ListElement {
            command: qsTr("Third seat back take last point backward")
            action: qsTr("Takes Third Seat back last point backward")
        }



        ListElement {
            command: qsTr("Third Seat take one step forward")
            action: qsTr("Takes Third Seat one step forward")
        }
        ListElement {
            command: qsTr("Third Seat take two step forward")
            action: qsTr("Takes Third Seat two step forward")
        }
        ListElement {
            command: qsTr("Third Seat take last point forward")
            action: qsTr("Takes Third Seat last point forward")
        }
        ListElement {
            command: qsTr("Third Seat take one step backward")
            action: qsTr("Takes Third Seat one step backward")
        }
        ListElement {
            command: qsTr("Third Seat take two step backward")
            action: qsTr("Takes Third Seat two step backward")
        }
        ListElement {
            command: qsTr("Third Seat take last point backward")
            action: qsTr("Takes Third Seat last point backward")
        }



        ListElement {
            command: qsTr("Third Seat take one step forward")
            action: qsTr("Takes Third Seat one step forward")
        }
        ListElement {
            command: qsTr("Third Seat take two step forward")
            action: qsTr("Takes Third Seat two step forward")
        }
        ListElement {
            command: qsTr("Third Seat take last point forward")
            action: qsTr("Takes Third Seat last point forward")
        }
        ListElement {
            command: qsTr("Third Seat take one step backward")
            action: qsTr("Takes Third Seat one step backward")
        }
        ListElement {
            command: qsTr("Third Seat take two step backward")
            action: qsTr("Takes Third Seat two step backward")
        }
        ListElement {
            command: qsTr("Third Seat take last point backward")
            action: qsTr("Takes Third Seat last point backward")
        }




        ListElement {
            command: qsTr("Third Seat Head take one step forward")
            action: qsTr("Takes Third Seat Head one step forward")
        }
        ListElement {
            command: qsTr("Third Seat Head take two step forward")
            action: qsTr("Takes Third Seat Head two step forward")
        }
        ListElement {
            command: qsTr("Third Seat Head take last point forward")
            action: qsTr("Takes Third Seat Head last point forward")
        }
        ListElement {
            command: qsTr("Third Seat Head take one step backward")
            action: qsTr("Takes Third Seat Head one step backward")
        }
        ListElement {
            command: qsTr("Third Seat Head take two step backward")
            action: qsTr("Takes Third Seat Head two step backward")
        }
        ListElement {
            command: qsTr("Third Seat Head take last point backward")
            action: qsTr("Takes Third Seat Head last point backward")
        }




        ListElement {
            command: qsTr("Fourth seat back take one step forward")
            action: qsTr("Takes Fourth Seat back one step forward")
        }
        ListElement {
            command: qsTr("Fourth seat back take two step forward")
            action: qsTr("Takes Fourth Seat back two step forward")
        }
        ListElement {
            command: qsTr("Fourth seat back take last point forward")
            action: qsTr("Takes Fourth Seat back last point forward")
        }
        ListElement {
            command: qsTr("Fourth seat back take one step backward")
            action: qsTr("Takes Fourth Seat back one step backward")
        }
        ListElement {
            command: qsTr("Fourth seat back take two step backward")
            action: qsTr("Takes Fourth Seat back two step backward")
        }
        ListElement {
            command: qsTr("Fourth seat back take last point backward")
            action: qsTr("Takes Fourth Seat back last point backward")
        }



        ListElement {
            command: qsTr("Fourth Seat take one step forward")
            action: qsTr("Takes Fourth Seat one step forward")
        }
        ListElement {
            command: qsTr("Fourth Seat take two step forward")
            action: qsTr("Takes Fourth Seat two step forward")
        }
        ListElement {
            command: qsTr("Fourth Seat take last point forward")
            action: qsTr("Takes Fourth Seat last point forward")
        }
        ListElement {
            command: qsTr("Fourth Seat take one step backward")
            action: qsTr("Takes Fourth Seat one step backward")
        }
        ListElement {
            command: qsTr("Fourth Seat take two step backward")
            action: qsTr("Takes Fourth Seat two step backward")
        }
        ListElement {
            command: qsTr("Fourth Seat take last point backward")
            action: qsTr("Takes Fourth Seat last point backward")
        }



        ListElement {
            command: qsTr("Fourth Seat take one step forward")
            action: qsTr("Takes Fourth Seat one step forward")
        }
        ListElement {
            command: qsTr("Fourth Seat take two step forward")
            action: qsTr("Takes Fourth Seat two step forward")
        }
        ListElement {
            command: qsTr("Fourth Seat take last point forward")
            action: qsTr("Takes Fourth Seat last point forward")
        }
        ListElement {
            command: qsTr("Fourth Seat take one step backward")
            action: qsTr("Takes Fourth Seat one step backward")
        }
        ListElement {
            command: qsTr("Fourth Seat take two step backward")
            action: qsTr("Takes Fourth Seat two step backward")
        }
        ListElement {
            command: qsTr("Fourth Seat take last point backward")
            action: qsTr("Takes Fourth Seat last point backward")
        }




        ListElement {
            command: qsTr("Fourth Seat Head take one step forward")
            action: qsTr("Takes Fourth Seat Head one step forward")
        }
        ListElement {
            command: qsTr("Fourth Seat Head take two step forward")
            action: qsTr("Takes Fourth Seat Head two step forward")
        }
        ListElement {
            command: qsTr("Fourth Seat Head take last point forward")
            action: qsTr("Takes Fourth Seat Head last point forward")
        }
        ListElement {
            command: qsTr("Fourth Seat Head take one step backward")
            action: qsTr("Takes Fourth Seat Head one step backward")
        }
        ListElement {
            command: qsTr("Fourth Seat Head take two step backward")
            action: qsTr("Takes Fourth Seat Head two step backward")
        }
        ListElement {
            command: qsTr("Fourth Seat Head take last point backward")
            action: qsTr("Takes Fourth Seat Head last point backward")
        }




        ListElement {
            command: qsTr("Fifth seat back take one step forward")
            action: qsTr("Takes Fifth Seat back one step forward")
        }
        ListElement {
            command: qsTr("Fifth seat back take two step forward")
            action: qsTr("Takes Fifth Seat back two step forward")
        }
        ListElement {
            command: qsTr("Fifth seat back take last point forward")
            action: qsTr("Takes Fifth Seat back last point forward")
        }
        ListElement {
            command: qsTr("Fifth seat back take one step backward")
            action: qsTr("Takes Fifth Seat back one step backward")
        }
        ListElement {
            command: qsTr("Fifth seat back take two step backward")
            action: qsTr("Takes Fifth Seat back two step backward")
        }
        ListElement {
            command: qsTr("Fifth seat back take last point backward")
            action: qsTr("Takes Fifth Seat back last point backward")
        }



        ListElement {
            command: qsTr("Fifth Seat take one step forward")
            action: qsTr("Takes Fifth Seat one step forward")
        }
        ListElement {
            command: qsTr("Fifth Seat take two step forward")
            action: qsTr("Takes Fifth Seat two step forward")
        }
        ListElement {
            command: qsTr("Fifth Seat take last point forward")
            action: qsTr("Takes Fifth Seat last point forward")
        }
        ListElement {
            command: qsTr("Fifth Seat take one step backward")
            action: qsTr("Takes Fifth Seat one step backward")
        }
        ListElement {
            command: qsTr("Fifth Seat take two step backward")
            action: qsTr("Takes Fifth Seat two step backward")
        }
        ListElement {
            command: qsTr("Fifth Seat take last point backward")
            action: qsTr("Takes Fifth Seat last point backward")
        }



        ListElement {
            command: qsTr("Fifth Seat take one step forward")
            action: qsTr("Takes Fifth Seat one step forward")
        }
        ListElement {
            command: qsTr("Fifth Seat take two step forward")
            action: qsTr("Takes Fifth Seat two step forward")
        }
        ListElement {
            command: qsTr("Fifth Seat take last point forward")
            action: qsTr("Takes Fifth Seat last point forward")
        }
        ListElement {
            command: qsTr("Fifth Seat take one step backward")
            action: qsTr("Takes Fifth Seat one step backward")
        }
        ListElement {
            command: qsTr("Fifth Seat take two step backward")
            action: qsTr("Takes Fifth Seat two step backward")
        }
        ListElement {
            command: qsTr("Fifth Seat take last point backward")
            action: qsTr("Takes Fifth Seat last point backward")
        }




        ListElement {
            command: qsTr("Fifth Seat Head take one step forward")
            action: qsTr("Takes Fifth Seat Head one step forward")
        }
        ListElement {
            command: qsTr("Fifth Seat Head take two step forward")
            action: qsTr("Takes Fifth Seat Head two step forward")
        }
        ListElement {
            command: qsTr("Fifth Seat Head take last point forward")
            action: qsTr("Takes Fifth Seat Head last point forward")
        }
        ListElement {
            command: qsTr("Fifth Seat Head take one step backward")
            action: qsTr("Takes Fifth Seat Head one step backward")
        }
        ListElement {
            command: qsTr("Fifth Seat Head take two step backward")
            action: qsTr("Takes Fifth Seat Head two step backward")
        }
        ListElement {
            command: qsTr("Fifth Seat Head take last point backward")
            action: qsTr("Takes Fifth Seat Head last point backward")
        }




        ListElement {
            command: qsTr("Sixth seat back take one step forward")
            action: qsTr("Takes Sixth Seat back one step forward")
        }
        ListElement {
            command: qsTr("Sixth seat back take two step forward")
            action: qsTr("Takes Sixth Seat back two step forward")
        }
        ListElement {
            command: qsTr("Sixth seat back take last point forward")
            action: qsTr("Takes Sixth Seat back last point forward")
        }
        ListElement {
            command: qsTr("Sixth seat back take one step backward")
            action: qsTr("Takes Sixth Seat back one step backward")
        }
        ListElement {
            command: qsTr("Sixth seat back take two step backward")
            action: qsTr("Takes Sixth Seat back two step backward")
        }
        ListElement {
            command: qsTr("Sixth seat back take last point backward")
            action: qsTr("Takes Sixth Seat back last point backward")
        }



        ListElement {
            command: qsTr("Sixth Seat take one step forward")
            action: qsTr("Takes Sixth Seat one step forward")
        }
        ListElement {
            command: qsTr("Sixth Seat take two step forward")
            action: qsTr("Takes Sixth Seat two step forward")
        }
        ListElement {
            command: qsTr("Sixth Seat take last point forward")
            action: qsTr("Takes Sixth Seat last point forward")
        }
        ListElement {
            command: qsTr("Sixth Seat take one step backward")
            action: qsTr("Takes Sixth Seat one step backward")
        }
        ListElement {
            command: qsTr("Sixth Seat take two step backward")
            action: qsTr("Takes Sixth Seat two step backward")
        }
        ListElement {
            command: qsTr("Sixth Seat take last point backward")
            action: qsTr("Takes Sixth Seat last point backward")
        }



        ListElement {
            command: qsTr("Sixth Seat take one step forward")
            action: qsTr("Takes Sixth Seat one step forward")
        }
        ListElement {
            command: qsTr("Sixth Seat take two step forward")
            action: qsTr("Takes Sixth Seat two step forward")
        }
        ListElement {
            command: qsTr("Sixth Seat take last point forward")
            action: qsTr("Takes Sixth Seat last point forward")
        }
        ListElement {
            command: qsTr("Sixth Seat take one step backward")
            action: qsTr("Takes Sixth Seat one step backward")
        }
        ListElement {
            command: qsTr("Sixth Seat take two step backward")
            action: qsTr("Takes Sixth Seat two step backward")
        }
        ListElement {
            command: qsTr("Sixth Seat take last point backward")
            action: qsTr("Takes Sixth Seat last point backward")
        }




        ListElement {
            command: qsTr("Sixth Seat Head take one step forward")
            action: qsTr("Takes Sixth Seat Head one step forward")
        }
        ListElement {
            command: qsTr("Sixth Seat Head take two step forward")
            action: qsTr("Takes Sixth Seat Head two step forward")
        }
        ListElement {
            command: qsTr("Sixth Seat Head take last point forward")
            action: qsTr("Takes Sixth Seat Head last point forward")
        }
        ListElement {
            command: qsTr("Sixth Seat Head take one step backward")
            action: qsTr("Takes Sixth Seat Head one step backward")
        }
        ListElement {
            command: qsTr("Sixth Seat Head take two step backward")
            action: qsTr("Takes Sixth Seat Head two step backward")
        }
        ListElement {
            command: qsTr("Sixth Seat Head take last point backward")
            action: qsTr("Takes Sixth Seat Head last point backward")
        }




        ListElement {
            command: qsTr("Luggage Curtain Open")
            action: qsTr("Opens the Luggage Curtain")
        }
        ListElement {
            command: qsTr("Luggage Curtain Close")
            action: qsTr("Closes the Luggage Curtain")
        }
        ListElement {
            command: qsTr("All Curtain Open")
            action: qsTr("Opens all the Curtain")
        }
        ListElement {
            command: qsTr("All Curtain Close")
            action: qsTr("Closes all the Curtain")
        }




        ListElement {
            command: qsTr("Take the first seat in sleep mode")
            action: qsTr("Takes the first seat in sleep mode")
        }
        ListElement {
            command: qsTr("Take the second seat in sleep mode")
            action: qsTr("Takes the second seat in sleep mode")
        }
        ListElement {
            command: qsTr("Gather first seat")
            action: qsTr("Gathers first seat")
        }
        ListElement {
            command: qsTr("Gather second seat")
            action: qsTr("Gathers second seat")
        }
        ListElement {
            command: qsTr("Take cinema mode")
            action: qsTr("Takes cinema mode")
        }
        ListElement {
            command: qsTr("Take conference mode")
            action: qsTr("Takes conference mode")
        }
        ListElement {
            command: qsTr("All tables open")
            action: qsTr("Opens all tables")
        }
        ListElement {
            command: qsTr("All tables close")
            action: qsTr("Closes all tables")
        }
        ListElement {
            command: qsTr("Gather all seats")
            action: qsTr("Gathers all seats")
        }



        ListElement {
            command: qsTr("In lights turn on")
            action: qsTr("Turns on in lights")
        }
        ListElement {
            command: qsTr("In lights turn off")
            action: qsTr("Turns off in lights")
        }
        ListElement {
            command: qsTr("Side lights turn on")
            action: qsTr("Turns on Side lights")
        }
        ListElement {
            command: qsTr("Side lights turn off")
            action: qsTr("Turns off Side lights")
        }
        ListElement {
            command: qsTr("Ceiling lights turn on")
            action: qsTr("Turns on Ceiling lights")
        }
        ListElement {
            command: qsTr("Ceiling lights turn off")
            action: qsTr("Turns off Ceiling lights")
        }
        ListElement {
            command: qsTr("System off")
            action: qsTr("Turns the System off")
        }


        ListElement {
            command: qsTr("Return to The Homepage")
            action: qsTr("Returns to The Homepage")
        }




    }

    SequentialAnimation{
        id:pageSwipe
        running: false
        NumberAnimation {
            target: logoItm
            property: "y"
            to:(typeof logoItm != "undefined" && logoItm)?(-logoItm.height):0
            duration: 200
            easing.type: Easing.InOutQuad
        }
        ParallelAnimation{
            NumberAnimation {
                target: currentPageItm
                property: "x"
                from:1024
                to:0
                duration: 200
                easing.type: Easing.InOutQuad
            }

            NumberAnimation {
                target: prevPageItm
                property: "x"
                from:0
                to:-1024
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }
        NumberAnimation {
            target: logoItm
            property: "y"
            from:(logoItm)?(-logoItm.height):0
            to:20
            duration: 200
            easing.type: Easing.InOutQuad
        }
    }
    VRService{
        id : voice_service
        onVoiceCode: function(code)
        {
            console.log("voice message :"+code);
            serial_mng.sendVoiceCommandById(code);
        }
        onNotdetected: function(message)
        {
            console.log("voice message :"+message);
        }
    }

    function white_lights()
    {
        var pageItem = MainMdl.getPage("Lights");
        pageItem.turn_on_lights_white();
    }
    function red_lights()
    {
        var pageItem = MainMdl.getPage("Lights");
        pageItem.turn_on_lights_red();
    }
    function green_lights()
    {
        var pageItem = MainMdl.getPage("Lights");
        pageItem.turn_on_lights_green();
    }
    function blue_lights()
    {
        var pageItem = MainMdl.getPage("Lights");
        pageItem.turn_on_lights_blue();
    }

    function turnoff_lights()
    {
        var pageItem = MainMdl.getPage("Lights");
        pageItem.turn_off_lights();
    }

    function cl_white_lights()
    {
        var pageItem = MainMdl.getPage("Lights");
        pageItem.cl_white_lights();
    }
    function cl_red_lights()
    {
        var pageItem = MainMdl.getPage("Lights");
        pageItem.cl_red_lights();
    }
    function cl_green_lights()
    {
        var pageItem = MainMdl.getPage("Lights");
        pageItem.cl_green_lights();
    }
    function cl_blue_lights()
    {
        var pageItem = MainMdl.getPage("Lights");
        pageItem.cl_blue_lights();
    }
    function cl_turnoff_lights()
    {
        var pageItem = MainMdl.getPage("Lights");
        pageItem.cl_turnoff_lights();
    }

    function il_white_lights()
    {
        var pageItem = MainMdl.getPage("Lights");
        pageItem.il_white_lights();
    }
    function il_red_lights()
    {
        var pageItem = MainMdl.getPage("Lights");
        pageItem.il_red_lights();
    }
    function il_green_lights()
    {
        var pageItem = MainMdl.getPage("Lights");
        pageItem.il_green_lights();
    }
    function il_blue_lights()
    {
        var pageItem = MainMdl.getPage("Lights");
        pageItem.il_blue_lights();
    }
    function il_turnoff_lights()
    {
        var pageItem = MainMdl.getPage("Lights");
        pageItem.il_turnoff_lights();
    }


    function side_white_lights()
    {
        var pageItem = MainMdl.getPage("Lights");
        pageItem.side_white_lights();
    }
    function side_red_lights()
    {
        var pageItem = MainMdl.getPage("Lights");
        pageItem.side_red_lights();
    }
    function side_green_lights()
    {
        var pageItem = MainMdl.getPage("Lights");
        pageItem.side_green_lights();
    }
    function side_blue_lights()
    {
        var pageItem = MainMdl.getPage("Lights");
        pageItem.side_blue_lights();
    }
    function side_turnoff_lights()
    {
        var pageItem = MainMdl.getPage("Lights");
        pageItem.side_turnoff_lights();
    }
    Timer {
        id:ccheck
        interval: 7000;
        running: true;
        repeat: false
        onTriggered: function(){
            if(serial_mng.systemstate !== 1)
            {
                serial_mng.sendKey("main/setclock",false,root.delay,(Qt.formatDateTime(new Date(), "h")*1 + smngr.value("main/hourdiff")*1)+ ":" + (Qt.formatDateTime(new Date(), "m")*1 + smngr.value("main/mindiff")*1));

            }

        }
    }
    Timer {
        id:syscheck
        interval: 500;
        running: true;
        repeat: true;
        onTriggered: function(){
            if(serial_mng.systemstate !== 1)
            {
                serial_mng.sendKey("main/system_request");
//                console.log("feedback request sent")
            }

        }
    }
        Connections{
            target:serial_mng
            onRunFunction:function(fname){
                if(typeof root[fname] == "function")
                {
                    root[fname]();
                }
            }
            onConnectionChanged:function(st)
            {
            }
            onSystemstateChanged:function(st)
            {
                if(st!=1)
                {
                    ccheck.running=true;
                }else{
                    ccheck.running=false;
                }
            }

        }

}
