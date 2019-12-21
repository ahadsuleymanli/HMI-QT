import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3
import QtGraphicalEffects 1.0
import QtQuick.Extras 1.4
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
        height: parent.height - y - contentBottomMargin
        width: parent.width
//        MouseArea{
//            id: testMA
//            anchors.horizontalCenter: parent.horizontalCenter
//            width: parent.width
//            height: parent.height
//            opacity: 0.5
//            onPressed: radioReference.visible=true
//            onReleased: radioReference.visible=false
//        }
//        Image{
//            id: radioReference
//            anchors.horizontalCenter: parent.horizontalCenter
//            width: parent.width
//            height: parent.height
//            source:"qrc:/design/media/Radio/radio.png"
//            opacity: 0.3
//            visible: false
//            z:100
//        }
        Image{
            id: bg
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            height: parent.height
            source:"qrc:/design/media/Radio/background.png"
        }
        Item {
            id:display
            x:10
            y:8
            height: 210
            width: 1004
            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                height: parent.height
                width: parent.width
                source: "qrc:/design/media/Radio/equalizer.png"
            }

            Text{
                id:frequencyText
                text:"99.1"
                font.pixelSize: 50
                font.family:GSystem.centurygothic.name
                color: "white"
                style: Text.Raised;
                styleColor: "#ffffd700"
                antialiasing: true
                smooth: true
                anchors.right: parent.horizontalCenter
                anchors.rightMargin: -50//-46
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: -2
                Text{
                    text:"MHz"
                    font.pixelSize: 20
                    font.family:GSystem.centurygothic.name
                    color: "white"
                    style: Text.Raised;
                    styleColor: "#ffffd700"
                    antialiasing: true
                    smooth: true
                    anchors.left: parent.right
                    anchors.top: parent.verticalCenter
                    anchors.topMargin: -2
                }
            }
            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                height: 22
                width: parent.width - 48
                source: "qrc:/design/media/Radio/frequency2.png"
            }
            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: -1
                height: 43
                source: "qrc:/design/media/Radio/line.png"
            }
        }

        Buttons{
            y:227
            x:0
            height: parent.height - 227 - 8
            width: parent.width
        }
    }

}
