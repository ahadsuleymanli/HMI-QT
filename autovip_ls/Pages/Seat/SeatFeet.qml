import QtQuick 2.0
import QtQuick.Controls 2.3
import ck.gmachine 1.0
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3
import "../../Components"


BasePage {
    id:root
    caption: qsTr(GSystem.selectedSeatToText()) + " "+ qsTr("SEAT FOOT REST") + mytrans.emptyString
    Image{
        id: back
        anchors.centerIn: parent
        source:"qrc:/design/seats/seatfootrest.svg"
        Image{
            id:up
            smooth: true
            x:0
            y:90
            source:"qrc:/design/seats/footrestup.svg"

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onPressed:function(){
                    co1.visible=true;
                    GSystem.sendSeatCommand("footrest_open");
                }
                onReleased: {
                    co1.visible = false;
                    GSystem.sendSeatCommand("footrest_stop");
                }
                onClicked: function()
                {
                    co1.visible=false;

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
            x:parent.width - width
            y:340
            smooth: true
            source:"qrc:/design/seats/footrestdown.svg"

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onPressed:function(){
                    co2.visible=true;
                    GSystem.sendSeatCommand("footrest_close");
                }
                onReleased: function()
                {
                    co2.visible=false;
                    GSystem.sendSeatCommand("footrest_stop");
                }
                onClicked: {
                    co2.visible = false;
                }
        }
        }
         ColorOverlay {
                        id:co2
                        visible: false
                        anchors.fill: down
                        source: down
                        color: GSystem.leftTextMenuItemPressedColor
                        smooth: true
         }
    }

}
