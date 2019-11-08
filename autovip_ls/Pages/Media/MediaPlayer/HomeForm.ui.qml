import QtQuick 2.4
import QtQuick.Layouts 1.3

Item {
    width: 810
    height: 600
    property alias progressIndicator: progressIndicator
    property alias coverImage: coverImage
    property alias infoArtist: infoArtist
    property alias infoLayout: infoLayout
    property alias infoYear: infoYear
    property alias infoTitle: infoTitle
    property alias progressBackground: progressBackground
    property alias durationText: durationText
    property alias currentPositionText: currentPositionText
    property alias progressCurrent: progressCurrent
    property alias prewButton: prewButton
    property alias shuffleButton: shuffleButton
    property alias playPauseButton: playPauseButton
    property alias nextButton: nextButton
    property alias backButton: backButton

    ColumnLayout {
        id: columnLayout
        anchors.fill: parent
        Item {
            height: 100
        }
        RowLayout {
            id: rowLayout
            Layout.fillWidth: true
            height: childrenRect.height
           Item{
               Layout.alignment: Qt.AlignLeft | Qt.AlignTop
               Layout.leftMargin: 50
               width: 200
               height: 200
               clip: true
               Image {
                   id: coverImage
                   anchors.fill: parent
                   fillMode: Image.PreserveAspectFit
               }
           }
            ColumnLayout {
                id: infoLayout
                width: childrenRect.width
                height: childrenRect.height
                Layout.leftMargin: 20
                Layout.topMargin: 20
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.fillHeight: true
                Layout.fillWidth: true

                RowLayout {
                    id: rowLayout1
                    width: 100
                    height: 100

                    Text {
                        id: infoTitle
                        color: "#c5c5c5"
                        text: "Another Love - Zwette Remix Radio Edit"
                        font.pixelSize: 20
                        styleColor: "#000000"
                        Layout.leftMargin: 0
                        Layout.topMargin: 0
                    }

                    Text {
                        id: infoYear
                        color: "#959595"
                        text: "2019"
                        font.pixelSize: 20
                    }
                }

                RowLayout {
                    id: rowLayout2
                    width: 100
                    height: 100

                    Text {
                        id: element
                        color: "#959595"
                        text: qsTr("by")
                        font.pixelSize: 20
                    }

                    Text {
                        id: infoArtist
                        color: "#c5c5c5"
                        text: qsTr("Call On Me")
                        Layout.leftMargin: 0
                        font.pixelSize: 26
                    }
                }
            }
        }

        ColumnLayout {
            id: columnLayout2
            width: childrenRect.width
            height: childrenRect.height
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 70
            Item {
                width: 700
                height: 6
                Rectangle {
                    id: progressBackground
                    anchors.fill: parent
                    color: "#575c5f"
                }
                Rectangle {
                    id: progressCurrent
                    anchors {
                        left: parent.left
                        top: parent.top
                    }
                    height: parent.height
                    width: 150
                    color: "#d4d3d3"
                }
                Image {
                    id: progressIndicator
                    anchors.verticalCenter: parent.verticalCenter
                    x: progressCurrent.width - width / 2
                    width: 80
                    height: 80
                    source: "qrc:/design/media/MediaPlayer/slider.png"
                }
            }
            Item {
                id: element1
                Layout.topMargin: 10
                width: progressBackground.width
                height: childrenRect.height
                Layout.fillWidth: false
                Text {
                    id: currentPositionText
                    anchors.left: parent.left
                    font.pixelSize: 18
                    text: "1:28"
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#a9a9ab"
                }
                Text {
                    id: durationText
                    anchors.right: parent.right
                    font.pixelSize: 18
                    text: "3:56"
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignLeft
                    color: "#a9a9ab"
                }
            }
        }
        RowLayout {
            Layout.fillWidth: true
            Layout.topMargin: 20
            height: childrenRect.height
            spacing: 20
            Item {
                Layout.fillWidth: true
            }
            Image {
                id: shuffleImage
                sourceSize.height: 30
                sourceSize.width: 30
                fillMode: Image.PreserveAspectFit
                source: "qrc:/design/media/MediaPlayer/change.png"
                MouseArea {
                    id: shuffleButton
                    anchors.fill: parent
                }
            }
            Item {
                width: 2
            }
            Image {
                id: prewImage
                sourceSize.height: 70
                sourceSize.width: 70
                fillMode: Image.PreserveAspectFit
                source: "qrc:/design/media/MediaPlayer/1.png"
                MouseArea {
                    id: prewButton
                    anchors.fill: parent
                }
            }
            Image {
                id: playPauseImage
                fillMode: Image.Stretch
                Layout.fillWidth: false
                source: "qrc:/design/media/MediaPlayer/2.png"
                MouseArea {
                    id: playPauseButton
                    anchors.fill: parent
                }
            }
            Image {
                id: nextImage
                sourceSize.height: 70
                sourceSize.width: 70
                source: "qrc:/design/media/MediaPlayer/3.png"
                MouseArea {
                    id: nextButton
                    anchors.fill: parent
                }
            }
            Item {
                width: 2
            }
            Image {
                id: repeat
                sourceSize.height: 30
                sourceSize.width: 30
                fillMode: Image.PreserveAspectFit
                source: "qrc:/design/media/MediaPlayer/back.png"
                MouseArea {
                    id: backButton
                    anchors.fill: parent
                }
            }

            Item {
                Layout.fillWidth: true
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }
}

/*##^##
Designer {
    D{i:1;anchors_height:100;anchors_width:100;anchors_x:332;anchors_y:250}
}
##^##*/

