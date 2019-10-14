import QtQuick 2.4
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import ck.gmachine 1.0
import "../../Components"

BasePage {
    id:root
    caption: qsTr("SMOKE FAN") + mytrans.emptyString
    pageName: "SmokeFan"
    Item{
        anchors.centerIn: parent
        width:300
        height:369
        Image{
            id:fan
            anchors.horizontalCenter: parent.horizontalCenter
            source:"qrc:/design/controls/fan1.png"
            sourceSize.height: 329
            fillMode: Image.PreserveAspectFit
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    serial_mng.sendKey("controls/smokefan_onoff");
                }
            }
        }
        NumberAnimation {
            target: fan
            properties: "rotation"
            from:0
            to:360
            duration:6000
            running: true
            loops: Animation.Infinite
        }
        Rectangle{
            anchors.top:fan.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            id:bg
            width:120
            height:50
            color:GSystem.leftTextMenuItemColor
            border.width: 1
            border.color:Qt.rgba(0/255, 108/255, 128/255,0.6)
            Text{
                anchors.centerIn: parent
                text:qsTr("On/Off")
                color:"white"
                font.pixelSize: 22
                horizontalAlignment: Text.AlignHCenter
                font.family: GSystem.centurygothic.name
            }
            MouseArea{
                anchors.fill: parent
                onPressed: {
                    bg.color=GSystem.leftTextMenuItemPressedColor;
                    serial_mng.sendKey("controls/smokefan_onoff");
                }
                onReleased: {
                    bg.color=GSystem.leftTextMenuItemColor;

                }
            }
        }

        }
}
