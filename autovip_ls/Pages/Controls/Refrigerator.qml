import QtQuick 2.4
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import ck.gmachine 1.0
import "../../Components"

BasePage {
    id:root
    caption: qsTr("REFRIGERATOR") + mytrans.emptyString
    pageName:"Refrigerator"
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
                beforecode:"controls/refrigerator_up"
                releasecode:"controls/refrigerator_stop"
            }
            ListElement{
                name: qsTr("Close")
                beforecode:"controls/refrigerator_down"
                releasecode:"controls/refrigerator_stop"
            }
        }

//        Repeater {
//            model:tmodel
//            Text {
//                text: name
//            }
//        }

        Image{
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            source:"qrc:/design/controls/refrigerator.svg"
        }

        }
}
