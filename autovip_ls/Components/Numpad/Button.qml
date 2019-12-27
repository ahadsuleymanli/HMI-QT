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
    function setDisabled(){
        root.enabled=false;
        root.color = "#884c4c4c";
        text.color = "#88939393"
    }
    MouseArea{
        id: mouseArea
        anchors.fill: parent
    }
    Text {
        id: text
        text: ""
        wrapMode: Text.WordWrap

        anchors.centerIn: parent
        font.pixelSize: 34
        color: "#ffd3d3d3"
    }
}
