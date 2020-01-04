import QtQuick 2.0
import ck.gmachine 1.0

Item {
    id:root
    property alias mouseArea: mouseArea
    property alias rotatingAnimation: rotatingAnimation
    property alias leftButton: leftButton
    property alias rightButton: rightButton
    property alias captionText: captionText
    property bool bottomCaption: false
    implicitHeight: image.height
    implicitWidth: image.width
    Image{
        id:image
        anchors.horizontalCenter: parent.horizontalCenter
        source:"qrc:/design/controls/fan1.png"
        sourceSize.height: 100
        fillMode: Image.PreserveAspectFit

        MouseArea{
            id:mouseArea
            anchors.fill: image
            anchors.margins: 4
        }
        NumberAnimation {
            id: rotatingAnimation
            target: image
            properties: "rotation"
            from:0
            to:360
            duration:6000
            running: image.visible
            loops: Animation.Infinite
        }
    }
    Text {
        id: captionText
        anchors.verticalCenter: bottomCaption?root.bottom:root.top
        anchors.horizontalCenter: root.horizontalCenter
        font.family: GSystem.myriadproita.name
        font.italic: true
        font.pixelSize: 22
        color: "white"
    }
    Button{
        id:leftButton
        height: 50
        width: 90
        anchors.right: root.horizontalCenter
        anchors.rightMargin: 34+10
        anchors.verticalCenter: root.verticalCenter
        border.width: 2
        z:-1
        buttonText.text: qsTr("close")
    }
    Button{
        id:rightButton
        height: 50
        width: 90
        anchors.left: root.horizontalCenter
        anchors.leftMargin: 34+10
        anchors.verticalCenter: root.verticalCenter
        border.width: 2
        z:-1
        buttonText.text: qsTr("open")

    }

}
