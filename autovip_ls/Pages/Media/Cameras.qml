import QtQuick 2.4
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import ck.gmachine 1.0
import "../../Components"

BasePage {
    id:root
    caption: qsTr("CAMERAS") + mytrans.emptyString
    pageName: "Cameras"
    Image{
        x:0
        y:0
        width:parent.width
        height:parent.height

    LeftTextMenu{
            id:leftMenu
            model:cameraModel

            ListModel {
                id: cameraModel

                ListElement {
                   name: qsTr("Front Camera")
                   st: "FrontCamera"
                }
                ListElement {
                   name: qsTr("Rear Camera")
                   st: "RearCamera"
                }
            }

//            Repeater {
//                model:cameraModel
//                Text {
//                    text: name
//                }
//            }

        }


        }

    Image{
        source:"qrc:/design/media/camera.png"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        sourceSize.width: 400
        sourceSize.height: 400

    }
}
