import QtQuick 2.0

Rectangle{
    id:root
    property alias mouseArea: mouseArea
    property alias text: text
    height: 60
    width: 120
    border.color: "#ff0c0c0c"
    border.width: 2
    color: mouseArea.pressed?"#ff1c1c1c":"#ff383838"
    radius: 10
    antialiasing: true
    MouseArea{
        id: mouseArea
        anchors.fill: parent
    }
    Text {
        id: text
        text: ""
        anchors.centerIn: parent
        font.pixelSize: 34
        color: "#ffd3d3d3"
    }
}
