import QtQuick 2.0
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3

Item {
    id: root
    property Gradient borderGradient: Gradient{
        GradientStop { position: 0.0; color: "#f08993" }
        GradientStop { position: 0.5; color: "#8552ee" }
        GradientStop { position: 1.0; color: "#47afd5" }
    }
    property real maxVolue: 67




    Item {
        id: volumeBarItem
        anchors{
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }
        width: parent.width /2
        clip: true

        Rectangle {
            id: borderFill
            anchors{
                left: parent.left
                top: parent.top
            }
            width: parent.height
            height: parent.height
            radius: height / 2
            gradient: root.borderGradient
            visible: false

        }

        Rectangle {
            id: mask
            anchors{
                left:   parent.left
                top: parent.top
            }
            width: parent.height
            height: parent.height
            radius: height / 2
            border.width: 4
            color: 'transparent'
            visible: false   // otherwise a thin border might be seen.
        }

        OpacityMask {
            id: opM
            anchors{
                left: parent.left
                top: parent.top
            }
            width: parent.height
            height: parent.height
            source: borderFill
            maskSource: mask
        }
    }

    Rectangle{
        id: volumeIndicator
        x: 6;
        y: 6;
        transform: Rotation{
            id: trRotation
            origin.x: volumeBarItem.width - 6;
            origin.y: volumeBarItem.height/2-6;
            axis { x: 0; y: 0; z: 1 } angle: 180 * (((serial_mng.volume > 0) ? serial_mng.volume : 0)/maxVolue) -135
        }

        width: 20
        height: 20
        radius: 10

    }
    Rectangle{
        anchors.fill: parent
        anchors.margins: 14
        radius: height/2
        color: "#505d5d5d"

        ColumnLayout{
            anchors.fill: parent
            anchors.topMargin: 10
            anchors.rightMargin: 4
            spacing: 3
            Item{
               Layout.alignment: Qt.AlignHCenter
               width: childrenRect.width
               height: childrenRect.height
               RowLayout{
                   Layout.alignment: Qt.AlignHCenter
                   width: childrenRect.width
                   height: childrenRect.height
                   spacing: 3
                   Image{
                       id: volumeImage
                       Layout.alignment: Qt.AlignHCenter
                       width: 30
                       height: 30
                       visible: false
                       source: "qrc:/design/general/volume.png"
                       fillMode: Image.PreserveAspectFit

                   }
                   ColorOverlay{
                       width: 30
                       height: 30
                       source: volumeImage
                       color: "#ffefefef"
                   }

                   Rectangle{
                        width: 2
                        height: 14
                        radius: 2
                        color: "#ffaa44"
                   }
                   Rectangle{
                       width: 2
                       height: 20
                       radius: 2
                       color :"#ffb85f"
                   }
                   Rectangle{
                       width: 2
                       height: 28
                       radius: 2
                       color: "#ffc37a"
                   }
                   Item{
                       Layout.fillWidth: true
                   }
               }

            }

            Item{
                Layout.alignment: Qt.AlignHCenter
                width: childrenRect.width
                height: childrenRect.height
                Text{
                    id: volumeText
                    anchors.verticalCenter: parent.verticalCenter
                    text : ((serial_mng.volume > 0) ? serial_mng.volume : 0)
                    font.pixelSize: 16
                    color: "#fefdfd"
                }
//                Text {
//                    anchors.verticalCenter: parent.verticalCenter
//                    anchors.left: volumeText.right
//                    font.pixelSize: 16
//                    text: "%"
//                    color: "#a7a6a6"
//                }
            }
            Item{
                Layout.fillHeight: true
            }
        }
    }
//    MouseArea{
//        anchors.fill: parent
//        onMouseYChanged: {
//            var ratio
//            if(mouseY < 0 )
//                ratio = 1
//            else if(mouseY > parent.height)
//                ratio = 0
//            else
//                ratio = (parent.height - mouseY) / 100
//            trRotation.angle = 180 * ratio -135
//        }
//    }
}
