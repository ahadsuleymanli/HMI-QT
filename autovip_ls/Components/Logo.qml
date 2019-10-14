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
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    console.log("logo click");
                    GSystem.state = "Home";
                    GSystem.changePage("Home");

                }
            }
}
