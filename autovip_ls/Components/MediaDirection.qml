import QtQuick 2.0

Rectangle {
    id: root
    width  :422
    height :290
    color:"transparent"
    signal clicked(string direction)
    Item{
        Image{
           x:0
           y:0
           width:86
           height:86
           source:"qrc:/design/media/kodi/back.svg"

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        mp_mng.fback();
                        mp_mng.getData();
                    }
                    cursorShape: Qt.PointingHandCursor
                }
        }
        Image{
           x:0
           y:90
           width:86
           height:86
           source:"qrc:/design/media/kodi/home.svg"
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                    mp_mng.fhome();
                    mp_mng.getData();
                    }
                    cursorShape: Qt.PointingHandCursor
                }
        }
        Image{
           x:0
           y:180
           width:86
           height:86
           source:"qrc:/design/media/kodi/list2.svg"
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                    mp_mng.fcontext();
                    mp_mng.getData();
                    }
                    cursorShape: Qt.PointingHandCursor
                }
        }

    }
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
                    mp_mng.fup();
                    mp_mng.getData();
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
                    mp_mng.fleft();
                    mp_mng.getData();
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
                    mp_mng.fselect();
                    mp_mng.getData();
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
                    mp_mng.fright();
                    mp_mng.getData();
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
                    mp_mng.fdown();
                    mp_mng.getData();
                    }
                    cursorShape: Qt.PointingHandCursor
                }
                }

    }
}
