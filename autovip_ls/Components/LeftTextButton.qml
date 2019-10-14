import QtQuick 2.0
import ck.gmachine 1.0

Rectangle {
    id: root
    property alias text: caption.text
    property alias area: marea
    property color clickbg: GSystem.leftTextMenuItemPressedColor
    property color bgcolor: GSystem.leftTextMenuItemColor
    property bool selection: false

    width:200
    height:75
    anchors.horizontalCenter: parent.horizontalCenter
    color:bgcolor
    border.width: 1
    border.color:Qt.rgba(0/255, 108/255, 128/255,0.6)
    Text{
        id:caption
        font.family: GSystem.myriadproita.name
        font.italic: true
        font.pixelSize: 24
        color: "white"
        anchors.centerIn: parent
    }
    MouseArea{
        id:marea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
//        onPressed: color = clickbg;
//        onReleased: color = bgcolor;
    }

}
