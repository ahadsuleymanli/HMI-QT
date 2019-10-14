import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import ck.gmachine 1.0
import "../../Components"

BasePage {
    id:root
    caption: qsTr("DVD Player") + mytrans.emptyString
    pageName: "DVDPlayer"
    property int cwidth: (width - oneseat.width) / 2
    property int cheight: (height - oneseat.height) / 2
    property int delay: -1
    function init()
    {
        serial_mng.sendKey("media/ready_divide",true,root.delay);
        serial_mng.sendKey("media/dvd_player",true,root.delay);
    }
    function end(){
    }
    GridLayout{
//        anchors.centerIn: parent
        anchors.horizontalCenter: parent.horizontalCenter
        y:200
        rows:8
        columns:5
        DVDButton{
            text:qsTr("OFF") + mytrans.emptyString
            color:"#c3452c"
            Layout.column: 0
            Layout.row: 0
            presscode:"dvdplayer/off"
        }
        DVDButton{
            text:qsTr("MUTE") + mytrans.emptyString
            color:"#294247"
            Layout.column: 4
            Layout.row: 0
            presscode:"dvdplayer/mute"
        }
        DVDButton{
            Layout.column: 0
            Layout.row: 2
            text:qsTr("MONITOR OFF") + mytrans.emptyString
            presscode:"dvdplayer/monitor_off"
        }
        DVDButton{
            text:qsTr("AUDIO") + mytrans.emptyString
            presscode:"dvdplayer/audio"
        }
        DVDButton{
            text:qsTr("SUBTITLE") + mytrans.emptyString
            presscode:"dvdplayer/subtitle"
        }
        DVDButton{
            text:qsTr("ANGLE") + mytrans.emptyString
            presscode:"dvdplayer/angle"
        }
        DVDButton{
            text:qsTr("POSITION") + mytrans.emptyString
            presscode:"dvdplayer/position"
        }
        DVDButton{
            text:qsTr("EQ") + mytrans.emptyString
            presscode:"dvdplayer/eq"
        }
        DVDButton{
            text:qsTr("UP") + mytrans.emptyString
            Layout.column:2
            Layout.row:3
            color:"#294247"
            presscode:"dvdplayer/up"
        }
        DVDButton{
            text:qsTr("VOL+") + mytrans.emptyString
            Layout.column:4
            Layout.row:3
            color:"#294247"
            presscode:"dvdplayer/volume_up"
        }
        DVDButton{
            text:qsTr("LEFT") + mytrans.emptyString
            Layout.column:1
            Layout.row:4
            color:"#294247"
            presscode:"dvdplayer/left"
        }
        DVDButton{
            text:qsTr("ENTER") + mytrans.emptyString
            presscode:"dvdplayer/enter"
            color:"#294247"
        }
        DVDButton{
            text:qsTr("RIGHT") + mytrans.emptyString
            color:"#294247"
            presscode:"dvdplayer/right"
        }
        DVDButton{
            text:qsTr("DOWN") + mytrans.emptyString
            Layout.column:2
            Layout.row:5
            color:"#294247"
            presscode:"dvdplayer/down"
        }
        DVDButton{
            text:qsTr("VOL-") + mytrans.emptyString
            Layout.column:4
            Layout.row:5
            color:"#294247"
            presscode:"dvdplayer/volume_down"
        }
        DVDButton{
            text:qsTr("1") + mytrans.emptyString
            color:"#005da2"
            presscode:"dvdplayer/one"
        }
        DVDButton{
            text:qsTr("2") + mytrans.emptyString
            color:"#005da2"
            presscode:"dvdplayer/two"
        }
        DVDButton{
            text:qsTr("3") + mytrans.emptyString
            color:"#005da2"
            presscode:"dvdplayer/third"
        }
        DVDButton{
            text:qsTr("TOP MENU") + mytrans.emptyString
            presscode:"dvdplayer/topmenu"
        }
        DVDButton{
            text:qsTr("MENU") + mytrans.emptyString
            presscode:"dvdplayer/menu"
        }
        DVDButton{
            text:qsTr("4") + mytrans.emptyString
            color:"#005da2"
            presscode:"dvdplayer/four"
        }
        DVDButton{
            text:qsTr("5") + mytrans.emptyString
            color:"#005da2"
            presscode:"dvdplayer/five"
        }
        DVDButton{
            text:qsTr("6") + mytrans.emptyString
            color:"#005da2"
            presscode:"dvdplayer/six"
        }
        DVDButton{
            text:qsTr("P.SCAN") + mytrans.emptyString
            presscode:"dvdplayer/pscan"
        }
        DVDButton{
            text:qsTr("SRC") + mytrans.emptyString
            presscode:"dvdplayer/src"
        }
        DVDButton{
            text:qsTr("7") + mytrans.emptyString
            color:"#005da2"
            presscode:"dvdplayer/seven"
        }
        DVDButton{
            text:qsTr("8") + mytrans.emptyString
            color:"#005da2"
            presscode:"dvdplayer/eight"
        }
        DVDButton{
            text:qsTr("9") + mytrans.emptyString
            color:"#005da2"
            presscode:"dvdplayer/nine"
        }
        DVDButton{
            text:qsTr("CHANGE") + mytrans.emptyString
            presscode:"dvdplayer/change"
        }
        DVDButton{
            text:qsTr("MODE") + mytrans.emptyString
            presscode:"dvdplayer/mode"
        }
        DVDButton{
            text:qsTr("CLEAR") + mytrans.emptyString
            presscode:"dvdplayer/clear"
        }
        DVDButton{
            text:qsTr("0") + mytrans.emptyString
            color:"#005da2"
            presscode:"dvdplayer/zero"
        }
    }
    Component.onCompleted: {

        root.delay = serial_mng.getDvdDelay();
    }
}
