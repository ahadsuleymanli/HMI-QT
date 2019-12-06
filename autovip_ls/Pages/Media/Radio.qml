import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import "../../Components"

BasePage {
    id:root
    caption:qsTr("RADIO FM") + mytrans.emptyString
    property real currentFrequency: 95.5

    ListModel{
        id: favoriteModel
        ListElement{frequency :"90.5"; name : "Fenomen FM"}
        ListElement{frequency :"107.0"; name : "Seymen FM"}
        ListElement{frequency :"107.0"; name : "Seymen FM"}
        ListElement{frequency :"107.0"; name : "Seymen FM"}


    }
    function init()
    {
        mPlayerBackend.pause();
    }
    ColumnLayout{
        anchors.fill: parent
        anchors.bottomMargin: 120
        anchors.topMargin: 180
        spacing: 1
        ListView{
            id: favoriteList
            Layout.alignment: Qt.AlignHCenter
            width: Math.min(childrenRect.width, parent.width)
            height: 150
            orientation: ListView.Horizontal
            model: favoriteModel
            spacing: 8
            delegate: Item{
                height: favoriteList.height
                width: height
                Rectangle{
                    id: favoriteBckg
                    anchors.fill: parent
                    radius : 6
                    color: "#dd202020"
                    border.color: "#baecec"
                }
                ColumnLayout{
                    anchors.fill: parent
                    Item{
                        Layout.fillHeight: true
                    }
                    Image{
                        Layout.alignment: Qt.AlignHCenter
                        width: 50
                        height: 62
                        source: "qrc:/design/radio/cfrequency.svg"
                    }
                    Text{
                        Layout.alignment: Qt.AlignHCenter
                        text: frequency
                        font.pixelSize: 15
                        color: "#dadada"
                    }
                    Text{
                        Layout.alignment: Qt.AlignHCenter
                        text: name
                        font.pixelSize: 15
                        color: "#dadada"
                    }
                    Item{
                        Layout.fillHeight: true
                    }
                }
                MouseArea{
                    id: favoriteMouseArea
                    anchors.fill: parent
                    onPressed: favoriteBckg.border.color = "#6aacac"
                    onReleased: favoriteBckg.border.color = "#baecec"
                }
            }
        }

        Item{
            height: 10
        }
        ColumnLayout{
            id: infoLayout
            Layout.alignment: Qt.AlignHCenter
            width: childrenRect.width
            height: childrenRect.height
            Text{
                id: frequencyText
                Layout.alignment: Qt.AlignHCenter
                font.pixelSize: 30
                color: "#dadada"

                text: root.currentFrequency.toFixed(2)

            }
            Text{
                id: channelNameText
                Layout.alignment: Qt.AlignHCenter
                font.pixelSize: 30
                color: "#eaeaea"
                text:"Joy FM"
            }
        }
        Item{
            height: 20
        }

        RowLayout{
            id: frequencyLayout
            Layout.alignment: Qt.AlignHCenter
            width: childrenRect.width
            height: childrenRect.height
            spacing: 4
            Repeater{
                model: (108 - 88) * 5 + 3
                Item{
                    id: frequencySpectrum
                    property real freq: 88 + (index - 2) / 5
                    property bool isCurrent: ((root.currentFrequency >= frequencySpectrum.freq &&
                                              root.currentFrequency < frequencySpectrum.freq + 0.2) ?
                                                 true : false)
                    property bool isLongStick: ((index - 2)% 5) == 0 ? true : false
                    width: (isLongStick ? 5 : 3)
                    height: 70
                    Item{
                        id: stick
                        anchors.top: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: frequencySpectrum.isCurrent ? 4 : 2
                        height: 60
                        Rectangle{
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width
                            height: parent.height * (frequencySpectrum.isLongStick ? 1 : 0.7)
                            color: frequencySpectrum.isCurrent ? Qt.lighter("#1fa0cb") : "#cadada"
                            radius: 2
                        }
                    }
                    Rectangle{
                        id: currentFrecuencyIndicator
                        anchors.verticalCenter: stick.verticalCenter
                        anchors.horizontalCenter: stick.horizontalCenter
                        width: 10
                        height: 10
                        radius: 5
                        visible: frequencySpectrum.isCurrent
                        color: "#1fa0cb"
                    }

                    Text {
                        anchors.top: stick.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        visible: frequencySpectrum.isLongStick ? true : false
                        color: "#fafafa"
                        font.pixelSize: 12
                        text: frequencySpectrum.freq + ".0"
                    }
                }
            }
        }
        Item{
            Layout.fillHeight: true
        }

        RowLayout{
            id: controlLayout
            Layout.alignment: Qt.AlignHCenter
            width: childrenRect.width
            height: 60
            spacing: 25
            Rectangle{
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                width: 70
                height: 70
                radius: 35
                color: "#80101010"
                border.color: "#1fa0cb"
                Image{
                    id: backwardImg
                    anchors{
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        leftMargin: 8
                    }
                    visible: false
                    sourceSize: Qt.point(50,34)
                    source: "qrc:/design/radio/backward.svg"
                }
                ColorOverlay{
                    anchors.fill: backwardImg
                    source: backwardImg
                    color: Qt.lighter(parent.border.color)
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: (root.currentFrequency - 0.1).toFixed(2)
                }
            }
            Rectangle{
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                width: 80
                height: 80
                radius: 40
            }
            Rectangle{
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                width: 70
                height: 70
                radius: 35
                color: "#80101010"
                border.color: "#1fa0cb"
                Image{
                    id: forwardImg
                    anchors{
                        verticalCenter: parent.verticalCenter
                        right: parent.right
                        rightMargin: 6
                    }
                    visible: false
                    sourceSize: Qt.point(50,34)
                    source: "qrc:/design/radio/forward.svg"
                }
                ColorOverlay{
                    anchors.fill: forwardImg
                    source: forwardImg
                    color: Qt.lighter(parent.border.color)
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: root.currentFrequency = (root.currentFrequency + 0.1).toFixed(2)
                }
            }
        }
    }
}
