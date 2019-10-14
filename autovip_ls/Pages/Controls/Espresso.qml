import QtQuick 2.4
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import ck.gmachine 1.0
import "../../Components"

BasePage {
    id:root
    caption: qsTr("ESPRESSO") + mytrans.emptyString
    pageName: "Espresso"
    Image{
        x:0
        y:0
        width:parent.width
        height:parent.height
        LeftTextMenu
        {
            id: leftMenu
            model:tmodel
        }
        ListModel{
            id: tmodel
            ListElement{
                name: qsTr("Open")
                beforecode:"controls/espresso_open"
                releasecode:"controls/espresso_stop"
            }
            ListElement{
                name: qsTr("Close")
                beforecode:"controls/espresso_close"
                releasecode:"controls/espresso_stop"
            }
        }
//        Repeater {
//            model:tmodel
//            Text {
//                text: name
//            }
//        }

        Image{
            id:main
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            height: 329
            fillMode: Image.PreserveAspectFit
            source:"qrc:/design/controls/espresso.png"
        }
        Text{
            id:warning
            anchors.top:main.bottom
            anchors.topMargin: -15
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: GSystem.myriadpro.name
            color:"white"
            font.pixelSize: 18
            text:qsTr("You can't open espresso when first seat ahead") + mytrans.emptyString
            horizontalAlignment: Text.Center
        }
        Rectangle{
            anchors.top:warning.bottom
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            id:bg
            width:180
            height:50
            color:GSystem.leftTextMenuItemColor
            border.width: 1
            border.color:Qt.rgba(0/255, 108/255, 128/255,0.6)
            Text{
                anchors.centerIn: parent
                text:qsTr("First Seat Back") + mytrans.emptyString
                color:"white"
                font.pixelSize: 22
                horizontalAlignment: Text.AlignHCenter
                font.family: GSystem.centurygothic.name
            }
            MouseArea{
                anchors.fill: parent
                onPressed: {
                    bg.color=GSystem.leftTextMenuItemPressedColor;
                    serial_mng.sendKey("first_seat/seat_backward");
                }
                onReleased: {
                    bg.color=GSystem.leftTextMenuItemColor;
                    serial_mng.sendKey("first_seat/seat_stop");

                }
            }
        }

        }
}
