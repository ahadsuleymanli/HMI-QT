import QtQuick 2.4
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import ck.gmachine 1.0
import "../../Components"

BasePage {
    id:root
    caption: qsTr("CEILING SCREEN") + mytrans.emptyString
    pageName: "CeilingScreen"
    property int cwidth: (width - oneseat.width) / 2
    property int cheight: (height - oneseat.height) / 2
    function init()
    {
    }
    function end(){
    }
    Column{
        anchors.centerIn: parent
    Image{
        id:img
        source:"qrc:/design/media/ceiling_screen.png"
    }
        Row{
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10
        Rectangle{
            id:onoff
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
                    onoff.color=GSystem.leftTextMenuItemPressedColor;
                    serial_mng.sendKey("media/back_monitor");
                }
                onReleased: {
                    onoff.color=GSystem.leftTextMenuItemColor;

                }
            }
        }
        Rectangle{
            id:source
            width:120
            height:50
            color:GSystem.leftTextMenuItemColor
            border.width: 1
            border.color:Qt.rgba(0/255, 108/255, 128/255,0.6)
            Text{
                anchors.centerIn: parent
                text:qsTr("Source")
                color:"white"
                font.pixelSize: 22
                horizontalAlignment: Text.AlignHCenter
                font.family: GSystem.centurygothic.name
            }
            MouseArea{
                anchors.fill: parent
                onPressed: {
                    source.color=GSystem.leftTextMenuItemPressedColor;
                    serial_mng.sendKey("media/back_monitor_src");
                }
                onReleased: {
                    source.color=GSystem.leftTextMenuItemColor;

                }
            }
        }
        Rectangle{
            id:ok
            width:120
            height:50
            color:GSystem.leftTextMenuItemColor
            border.width: 1
            border.color:Qt.rgba(0/255, 108/255, 128/255,0.6)
            Text{
                anchors.centerIn: parent
                text:qsTr("Ok")
                color:"white"
                font.pixelSize: 22
                horizontalAlignment: Text.AlignHCenter
                font.family: GSystem.centurygothic.name

            }
            MouseArea{
                anchors.fill: parent
                onPressed: {
                    ok.color=GSystem.leftTextMenuItemPressedColor;
                    serial_mng.sendKey("media/back_monitor_ok");
                }
                onReleased: {
                    ok.color=GSystem.leftTextMenuItemColor;

                }
            }
        }
    }
    }

}
