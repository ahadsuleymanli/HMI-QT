import QtQuick 2.0
import QtGraphicalEffects 1.0
import ck.gmachine 1.0

Rectangle {
    id: root
    property alias buttonText: buttonText
    property alias mouseArea: mouseArea
    property bool selection: false

    width:200
    height:75
    color:mouseArea.pressed? GSystem.leftTextMenuItemPressedColor: GSystem.leftTextMenuItemColor
    border.width: 1
    border.color:Qt.rgba(0/255, 108/255, 128/255,0.6)
    Text{
        id:buttonText
        font.family: GSystem.myriadproita.name
        font.italic: true
        font.pixelSize: 24
        color: "white"
        anchors.centerIn: root
    }
    MouseArea{
        id:mouseArea
        anchors.fill: root
    }

}
