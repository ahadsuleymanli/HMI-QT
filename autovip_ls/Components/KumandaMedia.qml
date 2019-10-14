import QtQuick 2.0


Item{
        x:96
        y:0
        width  :320
        height :290
        Image{
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        id:top
        source:"qrc:/design/media/kodi/directBtn.svg"

        MouseArea{
            anchors.fill: parent
            onClicked: {
                serial_mng.sendKey("apple_tv/up");
            }
            cursorShape: Qt.PointingHandCursor
        }
        }
        Image{
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        id:left
        source:"qrc:/design/media/kodi/directBtn.svg"
        rotation: -90
        MouseArea{
            anchors.fill: parent
            onClicked: {
                serial_mng.sendKey("apple_tv/left");
            }
            cursorShape: Qt.PointingHandCursor
        }
        }
        Image{
           anchors.centerIn: parent
           source:"qrc:/design/media/kodi/okBtn.svg"
        MouseArea{
            anchors.fill: parent
            onClicked: {
                serial_mng.sendKey("apple_tv/click");
            }
            cursorShape: Qt.PointingHandCursor
        }
        }
        Image{
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        id:right
        source:"qrc:/design/media/kodi/directBtn.svg"
        rotation: 90
        MouseArea{
            anchors.fill: parent
            onClicked:{
                serial_mng.sendKey("apple_tv/right");
            }
            cursorShape: Qt.PointingHandCursor
        }
        }
        Image{
        id:bottom
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        source:"qrc:/design/media/kodi/directBtn.svg"
        rotation:180
        MouseArea{
            anchors.fill: parent
            onClicked: {
                serial_mng.sendKey("apple_tv/down");
            }
            cursorShape: Qt.PointingHandCursor
        }
        }

}
