import QtQuick 2.0
import QtQuick.Controls 2.3
import ck.gmachine 1.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "../../Components"

BasePage {
    id:root
    caption: qsTr(GSystem.selectedSeatToText()) + " "+ qsTr("SEAT THIGH") + mytrans.emptyString
    Image{
        id: back
        anchors.centerIn: parent
        source:"qrc:/design/seats/seatpart.png"
        Image{
            id:up
            smooth: true
            x:64
            y:-91
            source:"qrc:/design/seats/uphead.svg"

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onPressed:function(){
                    co1.visible = true;
                    GSystem.sendSeatCommand("thigh_up");
                }
                onReleased: {
                    co1.visible = false;
                    GSystem.sendSeatCommand("thigh_stop");
                }
                onClicked : function()
                {
                    co1.visible = false;
                }
                }
        }

         ColorOverlay {
                        id:co1
                        visible: false
                        anchors.fill: up
                        source: up
                        color: GSystem.leftTextMenuItemPressedColor
                        smooth: true
         }
        Image{
            id:down
            smooth: true
            x:64
            y:123
            rotation:180
            source:"qrc:/design/seats/uphead.svg"
            MouseArea{
                cursorShape: Qt.PointingHandCursor
                anchors.fill: parent
                onPressed:function(){
                    co2.visible=true;
                    GSystem.sendSeatCommand("thigh_down");
                }
                onReleased: {
                    co2.visible = false;
                    GSystem.sendSeatCommand("thigh_stop");
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
                        rotation:180
                        anchors.fill: down
                        source: down
                        color: GSystem.leftTextMenuItemPressedColor
                        smooth: true
         }
    }

}
