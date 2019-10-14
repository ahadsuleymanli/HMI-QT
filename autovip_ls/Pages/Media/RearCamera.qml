import QtQuick 2.4
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import ck.gmachine 1.0
import "../../Components"

BasePage {
    id:root
    caption: qsTr("REAR CAMERA") + mytrans.emptyString
    pageName: "RearCamera"
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
                beforecode:"media/ready_divide"
                sericode:"media/rear_camera"
            }
        }
//        Repeater {
//            model:tmodel
//            Text {
//                text: name
//            }
//        }
    }

    Image{
        source:"qrc:/design/media/camera.png"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        sourceSize.width: 400
        sourceSize.height: 400
        MouseArea{
            anchors.fill: parent
            onClicked: {
                serial_mng.sendKey("media/ready_divide");
                serial_mng.sendKey("media/rear_camera");
            }
        }
    }

}
