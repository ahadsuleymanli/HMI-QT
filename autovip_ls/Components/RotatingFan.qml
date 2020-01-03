import QtQuick 2.0

Item {
    Image{
        id:root
        anchors.horizontalCenter: parent.horizontalCenter
        source:"qrc:/design/controls/fan1.png"
        sourceSize.height: 100
        fillMode: Image.PreserveAspectFit
        property alias mouseArea: mouseArea
        property alias rotatingAnimation: rotatingAnimation
        MouseArea{
            id:mouseArea
            anchors.fill: root
            anchors.margins: 4
        }
        NumberAnimation {
            id: rotatingAnimation
            target: root
            properties: "rotation"
            from:0
            to:360
            duration:6000
            running: root.visible
            loops: Animation.Infinite
        }
        LeftButton{
            id:left
            anchors.right: root.left
        }
        LeftButton{
            id:right
            anchors.left: root.right
        }
    }

}
