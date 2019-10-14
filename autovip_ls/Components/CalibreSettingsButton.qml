import QtQuick 2.0
import QtQuick.Layouts 1.1
import ck.gmachine 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Rectangle {
    id:root
    property alias source: icon.source
    property alias text: btnText.text
    property string presscode
    property  int delay: -1
    property string pressedKey;
    property string releaseKey;
    width:150
    height: 45
    color:Qt.rgba(0, 0, 0,0.4)
    border.width: 1
    border.color:Qt.rgba(0/255, 108/255, 128/255,0.6)
    text: "A button"
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
            root.color = GSystem.leftTextMenuItemPressedColor
            serial_mng.sendKey(root.pressedKey);
        }
        onReleased: {
            root.color = GSystem.leftTextMenuItemColor
            if(root.releaseKey) { serial_mng.sendKey(root.releaseKey); }
        }
        onClicked: {
            root.color = GSystem.leftTextMenuItemColor
        }
    }
}
