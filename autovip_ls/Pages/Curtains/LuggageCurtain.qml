import QtQuick 2.4
import QtQuick.Controls 2.3
//import QtQuick.Layouts
import ck.gmachine 1.0
import "../../Components"

BasePage {
    id:root
    caption: qsTr("LUGGAGE CURTAIN") + mytrans.emptyString
    pageName: "LuggageCurtain"
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
                beforecode:"controls/back_curtain_up"
                releasecode:"controls/back_curtain_stop"
            }
            ListElement{
                name: qsTr("Close")
                beforecode:"controls/back_curtain_down"
                releasecode:"controls/back_curtain_stop"
            }
        }

//        Repeater {
//            model:tmodel
//            Text {
//                text: name
//            }
//        }

            Image{
                x:308
                width: 650
                height: 400
                anchors.verticalCenterOffset: 0
                anchors.verticalCenter: parent.verticalCenter
                source:"qrc:/design/controls/luggagecurtain.png"
            }

        }
}
