import QtQuick 2.0
import QtGraphicalEffects 1.0
Item {
    id: root
    property alias text: text
    property alias mouseArea: mouseArea
    property alias image: image
    property bool pressed: false
    property bool inactive: false
    height: 60
    width: 120
    function setInactive(){
//        root.enabled=false
        levelAdjust.maximumOutput= "#ffcccccc"
        text.color="#ffa9a9a9"
    }
    Image{
        id:image
        anchors.fill: parent
        source: "qrc:/design/media/Radio/button_.png"
        LevelAdjust {
            id:levelAdjust
            anchors.fill: image
            source: image
            minimumOutput: "#00000000"
            maximumOutput: "#ff999999"
            visible: root.pressed
        }
    }
    MouseArea{
        id:mouseArea
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: -5
        anchors.leftMargin: -8
        width: parent.width + 16
        height:parent.height + 10
        onPressed: root.pressed=true
        onReleased: root.pressed=false
    }
    Text{
        id:text
        text:""
        font.pixelSize: 34
        font.family:GSystem.centurygothic.name
        color: "white"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -1
    }
}
