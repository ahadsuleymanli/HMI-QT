import QtQuick 2.4
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import ck.gmachine 1.0

Rectangle{
    id:root
    width:275
    height:75
    color:(mouseArea.pressed||toggled)?(blinkingAnimation.running?"#ffff0000":Qt.rgba(0/255, 108/255, 128/255,0.6)):Qt.rgba(0, 0, 0,0.4)
    border.width: 1
    border.color:Qt.rgba(0/255, 108/255, 128/255,0.6)
    property alias text:text
    property alias mouseArea:mouseArea
    property alias blinkingAnimation:blinkingAnimation
    property bool toggled: false
    signal blinkEnded
    Text{
        id:text
        font.family: GSystem.myriadproita.name
        font.italic: true
        font.pixelSize: 24
        text: root.text
        color: "white"
        anchors.centerIn: parent
    }
    MouseArea{
        id:mouseArea
        anchors.fill: parent
    }
    Rectangle{
        id:blinkRectangle
        radius:8; anchors.fill:parent; z:-1; visible: true; opacity: 0; color: "#aaff0000";
        SequentialAnimation{
            id:blinkingAnimation
            running: false
            loops: 1
            onRunningChanged: {
                if (!running){
                    blinkRectangle.opacity=0;
                    root.blinkEnded();
                }
            }
            PropertyAnimation{property: "opacity";target: blinkRectangle;from: 0;to: 1; duration: 300;}
//            PropertyAction { target: blinkRectangle; property: "opacity"; value: 1 }
//            PauseAnimation {duration: 400}
//            PropertyAction { target: blinkRectangle; property: "opacity"; value: 0 }
//            PauseAnimation {duration: 400}
            PauseAnimation {duration: 9000}
        }
    }
}
