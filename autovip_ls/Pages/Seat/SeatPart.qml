import QtQuick 2.0
import QtQuick.Controls 2.3
import ck.gmachine 1.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "../../Components"


BasePage {
    id:root
    caption: qsTr(GSystem.selectedSeatToText()) + " " + qsTr("SEAT") + mytrans.emptyString
    Image{
        id: back
        anchors.centerIn: parent
        source:"qrc:/design/seats/seatpart.png"
        Image{
            id:forward
            smooth: true
            x:0
            y:0
            source:"qrc:/design/seats/seatpartfw.svg"
            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onPressed:function(){
                    co1.visible=true;
                    GSystem.sendSeatCommand("seat_forward");
                }
                onReleased: {
                    co1.visible = false;
                    GSystem.sendSeatCommand("seat_stop");
                }
                onClicked: {
                    co1.visible = false;
                }
        }
        }

         ColorOverlay {
                        id:co1
                        visible: false
                        anchors.fill: forward
                        source: forward
                        color: GSystem.leftTextMenuItemPressedColor
                        smooth: true
         }
        Image{
            id:backward
            smooth: true
            x:parent.width - width + 50
            y:parent.height - height - 50
            source:"qrc:/design/seats/seatspartbw.svg"
            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onPressed:function(){
                    co2.visible=true;
                    GSystem.sendSeatCommand("seat_backward");
                }
                onReleased: {
                    co2.visible = false;
                    GSystem.sendSeatCommand("seat_stop");
                }
                onClicked : function()
                {
                    co2.visible=false;
                }
        }
        }

         ColorOverlay {
                        id:co2
                        visible: false
                        anchors.fill: backward
                        source: backward
                        color: GSystem.leftTextMenuItemPressedColor
                        smooth: true
         }
    }
    Item{
        visible:(GSystem.selectedSeat === 1)?true:false
        anchors.top:back.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width:400
        height:200
        Text{
            id:warning
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: GSystem.myriadpro.name
            color:"white"
            font.pixelSize: 18
            text:qsTr("When the espresso cover is open, you cannot take the first seat forward.") + mytrans.emptyString
            horizontalAlignment: Text.Center
        }
        Rectangle{
            anchors.top:warning.bottom
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            id:bg
            width:180
            height:50
            radius: 10
            color:GSystem.leftTextMenuItemColor
            border.width: 4
            border.color: "white"
            Text{
                anchors.centerIn: parent
                text:qsTr("Espresso Close") + mytrans.emptyString
                color:"white"
                font.pixelSize: 22
                horizontalAlignment: Text.AlignHCenter
                font.family: GSystem.centurygothic.name
            }
            MouseArea{
                anchors.fill: parent
                onPressed: {
                    bg.color=GSystem.leftTextMenuItemPressedColor;
                    serial_mng.sendKey("controls/espresso_close");
                }
                onReleased: {
                    bg.color=GSystem.leftTextMenuItemColor;
                    serial_mng.sendKey("controls/espresso_stop");

                }
            }
        }
    }


}
