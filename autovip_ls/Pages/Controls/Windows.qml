import QtQuick 2.4
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import ck.gmachine 1.0
import "../../Components"

BasePage {
    id:root
    caption: qsTr("WINDOWS") + mytrans.emptyString
    pageName: "Windows"
    Image{
        x:0
        y:0
        width:parent.width
        height:parent.height
        Rectangle{
            width: 800
            height: 450
            color:"transparent"
            anchors.centerIn:  parent

            RowLayout{
                anchors.fill:parent
                spacing:100

                ColumnLayout{
                    spacing: 0
                    anchors.left:parent.left
                    width:350
                    height: 400

                    Rectangle {
                        id:leftwrect
                        width:350
                        height:350
                        anchors.verticalCenter: parent.verticalCenter
                        color:Qt.rgba(0, 0, 0,0.4)
                        border.width: 1
                        border.color:Qt.rgba(0/255, 108/255, 128/255,0.6)
                        ColumnLayout{
                            width: 275
                            height: 275
                            spacing: 20
                            anchors.centerIn: parent
                            Text{
                                font.family: GSystem.myriadproita.name
                                font.italic: true
                                font.pixelSize: 24
                                text: qsTr("Left Window") + mytrans.emptyString
                                color: "white"
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.top:parent.top
                                anchors.topMargin: 20
                            }
                            Image {
                                id: lwpic
                                width:275
                                height: 275
                                sourceSize.height: 275
                                sourceSize.width: 275
                                anchors.horizontalCenter: parent.horizontalCenter
                                source: "qrc:/design/controls/left-window.png"
                            }
                        }
                    }

                    RowLayout{
                        id:leftbuttonslayout
                        anchors.horizontalCenter: leftwrect.horizontalCenter
                        anchors.top:leftwrect.bottom
                        spacing: 0
                        width: 350
                        height: 50
                        Rectangle{
                            id:leftwopen
                            width: 175
                            height: 50
                            anchors.left: parent.left
                            color:Qt.rgba(0, 0, 0,0.4)
                            border.width: 1
                            border.color:Qt.rgba(0/255, 108/255, 128/255,0.6)
                            Text {
                                font.family: GSystem.myriadproita.name
                                font.pixelSize: 24
                                font.italic: true
                                text: qsTr("Open")
                                color: "white"
                                anchors.centerIn: parent
                            }
                            MouseArea{
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: function(){
                                    serial_mng.sendKey("controls/window_leftopen");
                                }
                                onPressed: leftwopen.color = Qt.rgba(0/255, 108/255, 128/255,0.6)
                                onReleased: leftwopen.color = Qt.rgba(0, 0, 0,0.4)
                            }
                        }

                        Rectangle{
                            id:leftwclose
                            width: 175
                            height: 50
                            anchors.right:parent.right
                            color:Qt.rgba(0, 0, 0,0.4)
                            border.width: 1
                            border.color:Qt.rgba(0/255, 108/255, 128/255,0.6)
                            Text {
                                font.family: GSystem.myriadproita.name
                                font.pixelSize: 24
                                font.italic: true
                                text: qsTr("Close")
                                color: "white"
                                anchors.centerIn: parent
                            }
                            MouseArea{
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: function(){
                                    serial_mng.sendKey("controls/window_leftclose");
                                }
                                onPressed: leftwclose.color = Qt.rgba(0/255, 108/255, 128/255,0.6)
                                onReleased: leftwclose.color = Qt.rgba(0, 0, 0,0.4)
                            }
                        }
                    }
                } //columnlayout


                ColumnLayout{
                    spacing: 0
                    anchors.right:parent.right

                    Rectangle {
                        id:rightwrect
                        width:350
                        height:350
                        anchors.verticalCenter: parent.verticalCenter
                        color:Qt.rgba(0, 0, 0,0.4)
                        border.width: 1
                        border.color:Qt.rgba(0/255, 108/255, 128/255,0.6)
                        ColumnLayout{
                            spacing: 20
                            anchors.centerIn: parent
                            Text{
                                font.family: GSystem.myriadproita.name
                                font.italic: true
                                font.pixelSize: 24
                                text: qsTr("Right Window") + mytrans.emptyString
                                color: "white"
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.top:parent.top
                                anchors.topMargin: 0
                            }
                            Image {
                                id: rwpic
                                width:275
                                height: 275
                                sourceSize.height: 275
                                sourceSize.width: 275
                                anchors.horizontalCenter: parent.horizontalCenter
                                source: "qrc:/design/controls/right-window.png"
                            }
                        }
                    }

                    RowLayout{
                        id:rightbuttonslayout
                        anchors.horizontalCenter: rightwrect.horizontalCenter
                        anchors.top:rightwrect.bottom
                        spacing: 0
                        width: 350
                        height: 50
                        Rectangle{
                            id:rightwopen
                            width: 175
                            height: 50
                            anchors.left: parent.left
                            color:Qt.rgba(0, 0, 0,0.4)
                            border.width: 1
                            border.color:Qt.rgba(0/255, 108/255, 128/255,0.6)
                            Text {
                                font.family: GSystem.myriadproita.name
                                font.pixelSize: 24
                                font.italic: true
                                text: qsTr("Open")
                                color: "white"
                                anchors.centerIn: parent
                            }
                            MouseArea{
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: function(){
                                    serial_mng.sendKey("controls/window_rightopen");
                                }
                                onPressed: rightwopen.color = Qt.rgba(0/255, 108/255, 128/255,0.6)
                                onReleased: rightwopen.color = Qt.rgba(0, 0, 0,0.4)
                            }
                        }

                        Rectangle{
                            id:rightwclose
                            width: 175
                            height: 50
                            anchors.right:parent.right
                            color:Qt.rgba(0, 0, 0,0.4)
                            border.width: 1
                            border.color:Qt.rgba(0/255, 108/255, 128/255,0.6)
                            Text {
                                font.family: GSystem.myriadproita.name
                                font.pixelSize: 24
                                font.italic: true
                                text: qsTr("Close")
                                color: "white"
                                anchors.centerIn: parent
                            }
                            MouseArea{
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: function(){
                                    serial_mng.sendKey("controls/window_rightclose");
                                }
                                onPressed: rightwclose.color = Qt.rgba(0/255, 108/255, 128/255,0.6)
                                onReleased: rightwclose.color = Qt.rgba(0, 0, 0,0.4)
                            }
                        }
                    }
                } //columnlayout2
             }
        }

    }
}
