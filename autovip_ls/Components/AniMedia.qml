import QtQuick 2.0
Item{
    id:root
    property real cscale: 0.4
    property bool running: true
    Image{
        anchors.top: parent.top
        anchors.topMargin: 20
        sourceSize.width : parent.width
        sourceSize.height : parent.height * 208/295
        source:"qrc:/design/media/ani/camera.svg"
    }

    Image{
        id:cw1
        anchors.left: parent.left
        anchors.leftMargin: 20
        sourceSize.width : parent.width / 2.5
        sourceSize.height : parent.width / 2.5
        source:"qrc:/design/media/ani/cark.svg"
        smooth: true
    }
    Image{
        id:cw2
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 20
        anchors.topMargin: 30
        sourceSize.width : parent.width / 3
        sourceSize.height : parent.width / 3
        smooth: true
        source:"qrc:/design/media/ani/cark.svg"
    }
    NumberAnimation {
        targets: [cw1,cw2]
        properties: "rotation"
        from:0
        to:360
        duration:5000
        running: root.running
        loops: Animation.Infinite
    }
}
