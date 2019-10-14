import QtQuick 2.0
import QtQuick.Layouts 1.1
import ck.gmachine 1.0

Rectangle{
    id: root
    signal clicked
    signal pressed
    signal released
    property alias bgSource : btnImage.source
    property alias text : btnText.text
    property alias textColor : btnText.color
    property alias iWidth: btnImage.width
    property alias iHeight: btnImage.height
    property alias area:marea
    /*
    border.color: "black"
    border.width: 0.5
    radius: 3
    */
    color: "transparent"
    Column{
        //Layout.maximumHeight: parent.height
        //Layout.maximumWidth: parent.width
        width: parent.width
        Image {
            id: btnImage
            fillMode: Image.PreserveAspectFit
            anchors.horizontalCenter: parent.horizontalCenter
            width: root.width
            antialiasing: true
            smooth: true
        }
        Text {
            id: btnText
            font.family:GSystem.centurygothic.name
            font.pixelSize:  21
            color: "white"
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    MouseArea{
        id:marea
        anchors.fill: parent
        onClicked: root.clicked()
        onPressed: {
            //root.color= Qt.rgba(191/255, 63/255, 191/255,0.6);
            root.pressed();
        }
        onReleased:{
            root.color= "transparent";
            //root.released();
        }
        cursorShape: Qt.PointingHandCursor
    }
    Component.onCompleted: {
    }
}
