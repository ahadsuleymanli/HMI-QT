import QtQuick 2.0
import QtGraphicalEffects 1.0
import ck.gmachine 1.0

Rectangle {
    id:root
    property alias source: icon.source
    property alias text: btnText.text
    property string presscode
    property  int delay: -1
    width:120
    height: 45
    color:Qt.rgba(0, 0, 0,0.4)
    border.width: 1
    border.color:"black"

    Image{
        anchors.centerIn: parent
        id:icon

    }
    Text{
        anchors.centerIn: parent
        id:btnText
        font.pixelSize: 14
        font.family: GSystem.centurygothic.name
        color:"white"
    }

    MouseArea{
        anchors.fill: parent
        onPressed:{
            root.border.color = GSystem.leftTextMenuItemPressedColor
            serial_mng.sendKey(root.presscode,true,root.delay);
            console.log("pressed")
        }
        onClicked: {
//            serial_mng.sendKey(root.presscode,true,root.delay);
            serial_mng.sendKey("dvdplayer/dvdcommandstop")
            root.border.color="black";
//            console.log("clicked")
        }
    }
    Component.onCompleted: {
        root.delay = serial_mng.getDvdDelay();
    }
}
