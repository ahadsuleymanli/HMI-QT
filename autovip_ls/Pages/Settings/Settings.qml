import QtQuick 2.4
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import ck.gmachine 1.0
import "../../Components"

BasePage {
    id:root
    caption: qsTr("SETTINGS") + mytrans.emptyString
    pageName: "Settings"
    Item{
        x:0
        y:0
        width:parent.width
        height:parent.height
        SettingsMenu{
                id:leftMenu
                x:0
                y:200
            }
        }

        Image{
            //x: (root.width + leftMenu.width - width) /2
            //anchors.verticalCenter: root.verticalCenter
            anchors.centerIn: root
            source:"qrc:/design/general/Settings.svg"
            sourceSize.width: 300
            fillMode: Image.PreserveAspectFit
            antialiasing: true
            smooth: true
        }
}
