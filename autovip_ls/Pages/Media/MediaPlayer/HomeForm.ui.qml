import QtQuick 2.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Item {
    id:root
//    width: 810
//    height: 600 //564?
    property alias repeatButton: repeatButton
    property alias progressArea: progressArea
    property alias progressIndicator: progressIndicator
    property alias coverImage: coverImage
    property alias playPauseImage: playPauseImage
    property alias shuffleImage: shuffleImage
    property alias repeatImage: repeatImage
    property alias repeatGlow: repeatGlow
    property alias shuffleGlow: shuffleGlow
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
    property bool repeatImageToggled: false
    property bool shuffleImageToggled: false
    property string toggledColor: "#8800FF55"

    ColumnLayout {
        id: columnLayout
        anchors.fill: parent
//        Item {
//            height: 104
//        }
        RowLayout {
            id: rowLayout
            Layout.fillWidth: true
            Layout.topMargin: 104
            height: childrenRect.height
            Item {
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.leftMargin: 50
                width: 260
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
                //                width: childrenRect.width
                //                height: childrenRect.height
                Layout.maximumWidth: 370
                Layout.leftMargin: 20
                Layout.topMargin: 40
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop

                RowLayout {
                    id: rowLayout1

                    //                    width: childrenRect.width
                    //                    height: childrenRect.height

                    Text {
                        id: infoTitle
                        color: "#c5c5c5"
                        text: ""
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        Layout.maximumWidth: 370
                        font.pixelSize: 20
                        styleColor: "#000000"
                    }

                    Text {
                        id: infoYear
                        color: "#959595"
                        text: ""
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        font.pixelSize: 20
                    }
                }

                RowLayout {
                    id: rowLayout2

                    //                    width: childrenRect.width
                    //                    height: childrenRect.height
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
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        Layout.maximumWidth: 370
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
                Glow {
                    anchors.fill: progressCurrent
                    samples: 10
                    color: "#7b8b8b"
                    source: progressCurrent
                    visible: progressArea.pressed
                }
                Rectangle {
                    id: progressCurrent
                    anchors {
                        left: parent.left
                        top: parent.top
                    }
                    height: parent.height
                    width: 0
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
                Glow {
                    anchors.fill: progressIndicator
                    radius: 15
                    samples: 20
                    color: "#abebfb"
                    source: progressIndicator
                    visible: progressArea.pressed
                }

                MouseArea {
                    id: progressArea
                    anchors.fill: progressBackground
                    anchors.topMargin: -20
                    anchors.bottomMargin: -20
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
            Layout.bottomMargin: 24
            height: childrenRect.height
            spacing: 20
            Item {
                Layout.fillWidth: true
            }
            Item {
                width: childrenRect.width
                height: childrenRect.height
                Image {
                    id: shuffleImage
                    sourceSize.height: 30
                    sourceSize.width: 30
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/design/media/MediaPlayer/shuffle.png"
                    MouseArea {
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.topMargin: -12
                        anchors.leftMargin: -12
                        width: parent.width + 24
                        height:parent.height + 24
                        id: shuffleButton
                    }
                }
                ColorOverlay {
                    anchors.fill: shuffleImage
                    source: shuffleImage
                    color: toggledColor
                    cached: true
                    visible: shuffleImageToggled
                }
                Glow {
                    id: shuffleGlow
                    anchors.fill: shuffleImage
                    radius: 20
                    samples: 20
                    color: "#bbabebfb"
                    source: shuffleImage
                    visible: shuffleButton.pressed
                }
            }
            Item {
                width: 2
            }
            Item {
                width: childrenRect.width
                height: childrenRect.height
                Image {
                    id: prewImage
                    sourceSize.height: 60
                    sourceSize.width: 60
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/design/media/MediaPlayer/1.png"
                    MouseArea {
                        id: prewButton
                        anchors.fill: parent
                    }
                }
                Glow {
                    anchors.fill: prewImage
                    radius: 20
                    samples: 20
                    color: "#abebfb"
                    source: prewImage
                    visible: prewButton.pressed
                }
            }
            Item {
                width: childrenRect.width
                height: childrenRect.height
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
                Glow {
                    anchors.fill: playPauseImage
                    radius: 20
                    samples: 20
                    color: "#bbabebfb"
                    source: playPauseImage
                    visible: playPauseButton.pressed
                }
            }
            Item {
                width: childrenRect.width
                height: childrenRect.height
                Image {
                    id: nextImage
                    sourceSize.height: 60
                    sourceSize.width: 60
                    source: "qrc:/design/media/MediaPlayer/3.png"
                    MouseArea {
                        id: nextButton
                        anchors.fill: parent
                    }
                }
                Glow {
                    anchors.fill: nextImage
                    radius: 20
                    samples: 20
                    color: "#bbabebfb"
                    source: nextImage
                    visible: nextButton.pressed
                }
            }

            Item {
                width: 2
            }
            Item {
                width: childrenRect.width
                height: childrenRect.height
                Image {
                    id: repeatImage
                    sourceSize.height: 30
                    sourceSize.width: 30
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/design/media/MediaPlayer/repeat.png"
                    MouseArea {
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.topMargin: -12
                        anchors.leftMargin: -12
                        width: parent.width + 24
                        height:parent.height + 24
                        id: repeatButton
                    }
                }
                ColorOverlay {
                    anchors.fill: repeatImage
                    source: repeatImage
                    color: toggledColor
                    cached: true
                    visible: repeatImageToggled
                }
                Glow {
                    id: repeatGlow
                    anchors.fill: repeatImage
                    radius: 20
                    samples: 20
                    color: "#bbabebfb"
                    source: repeatImage
                    visible: repeatButton.pressed
                }
            }

            Item {
                Layout.fillWidth: true
            }
        }


    }
    Item {
        id: audiolabs
        anchors.bottom:parent.bottom
        anchors.left:parent.left
        height:image.height
        width:image.width
        Image {
            id: image
            source: "qrc:/design/media/MediaPlayer/DizaynVIP_Audio_Labs.png"
        }
    }
}

/*##^##
Designer {
    D{i:52;anchors_y:0}D{i:1;anchors_height:100;anchors_width:100;anchors_x:332;anchors_y:250}
}
##^##*/

