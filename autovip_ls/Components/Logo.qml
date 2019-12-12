import QtQuick 2.0
import ck.gmachine 1.0

Image{
            id:logo
            anchors.left: parent.left
            anchors.leftMargin: 20
            y:20
            width: 210
            height: 130
            source : "qrc:/design/general/logo.png"
            MouseArea{
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.topMargin: -20
                anchors.leftMargin: -20
                width: parent.width + 40
                height:parent.height + 40
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    console.log("logo click");
                    GSystem.state = "Home";
                    GSystem.changePage("Home");

                }
            }
}
