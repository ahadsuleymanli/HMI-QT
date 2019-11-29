import QtQuick 2.4
import QtQuick.Layouts 1.1

Item {
    width: 810
    height: 600
    property alias playlist: playlist
    Rectangle{
        anchors.fill: parent
        anchors.topMargin: 41
        color:"#181818"
    }

    Item{
        id: header
        anchors{
            left: parent.left
            right: parent.right
            top: parent.top
            topMargin: 41
        }
        height: 100
        Rectangle{
            anchors.fill: parent
            color: "#cc202020"
        }

        RowLayout{
            anchors.fill: parent
            Item {
                Layout.preferredWidth: 100 * image.aspectRatio
                Layout.preferredHeight: 100
                Image {
                    id: image
                    anchors.fill: parent
                    property real aspectRatio: sourceSize.width / sourceSize.height
                    fillMode: Image.PreserveAspectFit
                    source: (mPlayerBackend.playingCover === "" ? "qrc:/design/media/MediaPlayer/melody.png":
                                                                  mPlayerBackend.playingCover)
                }
            }
            Item{
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.leftMargin: 5
                ColumnLayout{
                    anchors.fill: parent
                    spacing: 0
                    Item{
                        Layout.fillHeight: true
                    }

                    Text {
                        text: mPlayerBackend.playingTitle
                        font.bold: true
                        color: "#dfdfdf"
                    }
                    Text {
                        text: mPlayerBackend.playingArtist
                        color: "#afafaf"
                    }
                    Item{
                        Layout.fillHeight: true
                    }
                }
            }


        }
        Rectangle{
            anchors{
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            height: 1
            color: "#dd303030"
        }
    }

    ListView {
        id: playlist
        anchors{
            left: parent.left
            right: parent.right
            top: header.bottom
            bottom: parent.bottom
            topMargin: 5
        }
        clip: true
        delegate: Item {
            width: playlist.width
            height: 50
            Text {
                anchors{
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 15
                }

                id: indexText
                text: (index + 1)
                color:"#bfbfbf"
            }
            MouseArea {
                id:trackClickable
                anchors.fill: parent
                onClicked: {playlist.model.playTrack(index)}
            }
            ColumnLayout{
                anchors{
                    verticalCenter: parent.verticalCenter
                    left: indexText.right
                    right: durationText.left
                    rightMargin: 20
                    leftMargin: trackClickable.pressed ? 22 : 20
                }
                spacing: 0
                Text {
                    id: trackText
                    text: track
                    color: "#fbfbfb"
                    font.pixelSize: 16
                    font.bold: true
                }
                Text {
                    id: artistsText
                    text: artists
                    color: "#9b9b9b"
                    font.pixelSize: 16
                }
            }
            Text {
                id: durationText
                anchors{
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin: 10
                }
            }
            Rectangle{
                anchors{
                    horizontalCenter: parent.horizontalCenter
                    bottom: parent.bottom
                }
                width: parent.width -30
                height: 1
                color: "#cc303030"
            }



        }
    }
}

/*##^##
Designer {
    D{i:1;anchors_height:160;anchors_width:110;anchors_x:327;anchors_y:252}
}
##^##*/

