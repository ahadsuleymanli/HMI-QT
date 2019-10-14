import QtQuick 2.4
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import ck.gmachine 1.0
import "../../Components"

BasePage {
    id:root
    caption: qsTr("SAFE BOX") + mytrans.emptyString
    pageName: "SafeBox"
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
                beforecode:"controls/safebox_open"
            }
            ListElement{
                name: qsTr("Close")
                beforecode:"controls/safebox_close"
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
            anchors.horizontalCenter:  parent.horizontalCenter
            height: 329
            fillMode: Image.PreserveAspectFit
            source:"qrc:/design/controls/safebox.svg"
        }

        }
}
