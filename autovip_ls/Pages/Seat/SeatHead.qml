import QtQuick 2.0
import QtQuick.Controls 2.3
import ck.gmachine 1.0
import QtGraphicalEffects 1.0
import "../../Components"


BasePage {
    id:root
    caption: qsTr(GSystem.selectedSeatToText())+ " "+ qsTr("SEAT HEADSET") + mytrans.emptyString
    Image{
        id: head
        anchors.centerIn: parent
        source:"qrc:/design/seats/head.svg"
    }
    Image{
        id:head_down
        anchors.left: head.right
        anchors.verticalCenter: parent.verticalCenter
        source:"qrc:/design/seats/downhead.svg"
        smooth: true
            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onPressed:function(){
                    co.visible=true;
                    GSystem.sendSeatCommand("head_down");
                }
                onReleased: {
                    co.visible=false;
                    GSystem.sendSeatCommand("head_stop");
                }
                onClicked: function()
                {
                    co.visible=false;
                }
        }

    }

         ColorOverlay {
                        id:co
                        visible: false
                        anchors.fill: head_down
                        source: head_down
                        color: GSystem.leftTextMenuItemPressedColor
                        smooth: true
         }
    Image{
        id:head_up
        anchors.right: head.left
        anchors.verticalCenter: parent.verticalCenter
        source:"qrc:/design/seats/uphead.svg"
        smooth: true
            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onPressed:function(){
                        co2.visible=true;
                        GSystem.sendSeatCommand("head_up");
                }
                onReleased: {
                        co2.visible=false;
                        GSystem.sendSeatCommand("head_stop");
                }
                onClicked: function()
                {
                        co2.visible=false;
                }
        }
    }
         ColorOverlay {
                        id:co2
                        visible: false
                        anchors.fill: head_up
                        source: head_up
                        color: GSystem.leftTextMenuItemPressedColor
                        smooth: true
         }


}
