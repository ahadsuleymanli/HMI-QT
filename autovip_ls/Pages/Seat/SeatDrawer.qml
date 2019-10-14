import QtQuick 2.0
import QtQuick.Controls 2.3
import ck.gmachine 1.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "../../Components"


BasePage {
    id:root
    caption: qsTr(GSystem.selectedSeatToText()) + " "+ qsTr("SEAT DRAWER") + mytrans.emptyString
    Image{
        id: back
        anchors.centerIn: parent
        source:"qrc:/design/seats/seatdrawer.png"
        smooth: true
        Image{
            id:forward
            x:-120
            y:190
            smooth: true
            source:"qrc:/design/seats/seatbackforward.svg"

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onPressed:function(){
                    co1.visible=true;
                    GSystem.sendSeatCommand("drawer_open");
                }
                onReleased: {
                    co1.visible = false;
                    GSystem.sendSeatCommand("drawer_stop");
                }
                onClicked : function()
                {
                    co1.visible=false;
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
            x:parent.width - width - 30
            y:190
            smooth: true
            source:"qrc:/design/seats/seatbackbw.svg"
            MouseArea{
                cursorShape: Qt.PointingHandCursor
                anchors.fill: parent
                onPressed:function(){
                    co2.visible=true;
                    GSystem.sendSeatCommand("drawer_close");
                }
                onReleased: {
                    co2.visible=false;
                    GSystem.sendSeatCommand("drawer_stop");
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

}
