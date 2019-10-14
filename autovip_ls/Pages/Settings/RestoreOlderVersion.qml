import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import ck.gmachine 1.0
import MyLang 1.0
import QtGraphicalEffects 1.0
import "../../Components"
import QtQuick.Extras 1.4
import QtGraphicalEffects 1.0
import closx.restarter 1.0

BasePage{
    id:root
    caption: qsTr("Restore Older Version") + mytrans.emptyString
    pageName: "RestoreOlderVersion"
    function init()
    {
    }

    Restarter{
        id:restarter
    }

    ColumnLayout{
        anchors.centerIn: parent
        width: 550
        height: 100

        RowLayout {
            width:550
            height: 300
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 15

            Text { color:"white"; text: qsTr("Restore to the Older Version: ") + mytrans.emptyString; font.bold: true;  }
            Rectangle {
                id:restoreButton
                width:150
                height: 45
                color:Qt.rgba(0, 0, 0,0.4)
                border.width: 1
                border.color:Qt.rgba(0/255, 108/255, 128/255,0.6)
                Text{
                    anchors.centerIn: parent
                    id: btnText
                    text: qsTr("Restore") + mytrans.emptyString
                    font.pixelSize: 14
                    font.family: GSystem.centurygothic.name
                    color:"white"
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed:{
                        restoreButton.color = GSystem.leftTextMenuItemPressedColor
                    }
                    onReleased: {
                        restoreButton.color = GSystem.leftTextMenuItemColor
                        restarter.restoreOlderVersion()
                    }
                }
            }
        }

        Rectangle{
            anchors.horizontalCenter: parent.horizontalCenter
            width: 550
            height: 100
            color: "transparent"
            Text{
                anchors.centerIn: parent
                text: qsTr("You can update the system again after rebooting.") + mytrans.emptyString
                font.pixelSize: 14
                font.family: GSystem.centurygothic.name
                color:"white"
            }
        }
    }

}
