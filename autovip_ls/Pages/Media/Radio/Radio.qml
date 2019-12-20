import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import "../../../Components"
import "../Radio"

BasePage {
    caption: qsTr("RADIO") + mytrans.emptyString
    pageName: "Radio"
    Component.onCompleted: {
        console.log(radioReference.height + ", " + radioReference.width)
    }
    Item {
        id: raioArea
        x: 0
        y: contentTopMargin
//        y: contentTopMargin
        height: parent.height - y - contentBottomMargin
        width: parent.width
//        anchors{
//            left: parent.left
//            right: parent.right
//            top: parent.top
//            bottom: parent.bottom
////            topMargin: 43
//        }
        MouseArea{
            id: testMA
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            height: parent.height
            opacity: 0.5
            onPressed: radioReference.visible=true
            onReleased: radioReference.visible=false
        }
        Image{
            id: radioReference
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            height: parent.height
            source:"qrc:/design/media/Radio/radio.png"
            opacity: 0.3
            visible: false
            z:100
        }
        Image{
            id: bg
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            height: parent.height
            source:"qrc:/design/media/Radio/background.png"
        }
        Buttons{
        }
    }

}
