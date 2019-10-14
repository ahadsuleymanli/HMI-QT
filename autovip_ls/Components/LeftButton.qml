import QtQuick 2.0
import QtGraphicalEffects 1.0
import ck.gmachine 1.0

Item{
    id: root
    signal clicked
    signal holded
    signal released
    property alias text : btnText.text
    property alias textColor : btnText.color
    property alias bgsource: bgimage.source
    width:200
    height:200
    anchors.horizontalCenter: parent.horizontalCenter
    Image{
        id: bgimage
        fillMode: Image.PreserveAspectFit
        antialiasing: true
    }
    Text {
        id: btnText
        font.family: GSystem.myriadproita.name
        font.italic: true
        font.pixelSize: 24
        color: "white"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 7
    }

    Item{
        width:parent.width
        height:5
        anchors.top: btnText.bottom
        RadialGradient {
            id:grad
            anchors.fill: parent
            horizontalRadius:parent.width * 1/3
            verticalRadius: parent.height * 2/3
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#FFFFFFFF"}
                GradientStop { position: 1.0; color: "#00FFFFFF" }
            }
        }
    }

    MouseArea{
        id:marea
        anchors.fill: parent
        onClicked: root.clicked()
        onPressAndHold: root.holded()
        onReleased: root.released()
        cursorShape: Qt.PointingHandCursor
    }
}


