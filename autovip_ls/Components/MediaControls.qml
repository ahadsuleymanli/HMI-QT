import QtQuick 2.0
import QtQuick.Layouts 1.1

Item {
    width:247
    height:295
    clip:true
    ColumnLayout{
        anchors.fill:parent
        spacing:5
        Rectangle{
            width:parent.width
            height:70
            anchors.top: parent.top
            color:"transparent"
                RowLayout{
                    anchors.fill:parent
                    Item{
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            Image{
                                anchors.left: parent.left
                                source:"qrc:/design/media/kodi/refreshBtn.svg"
                            }
                    }
                    Item{
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            Image{
                                    source:"qrc:/design/media/kodi/infoBtn.svg"
                                    anchors.horizontalCenter: parent.horizontalCenter
                            }
                    }
                    Item{
                            Layout.fillHeight: true
                            Layout.fillWidth : true
                            Image{
                                anchors.right: parent.right
                                Layout.rightMargin:0.1
                                source:"qrc:/design/media/kodi/listBtn.svg"
                            }
                    }
            }
        }
        Rectangle{
            width:parent.width
            height:70
            anchors.centerIn: parent
            color:"transparent"
            RowLayout{
            anchors.fill:parent
                Item{
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Image{
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        source:"qrc:/design/media/kodi/prevChapterBtn.svg"
                    }
                }
                Item{
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Image{
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        source:"qrc:/design/media/kodi/prevBtn.svg"
                    }
                }
                Item{
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Image{
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        source:"qrc:/design/media/kodi/nextBtn.svg"
                    }
                }
                Item{
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Image{
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        source:"qrc:/design/media/kodi/nextChapter.svg"
                    }
                }
            }
        }
        Rectangle{
            width:parent.width
            height:70
            anchors.bottom: parent.bottom
            color:"transparent"
            RowLayout{
            anchors.fill:parent
                Item{
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Image{
                        anchors.left: parent.left
                        anchors.bottom: parent.bottom
                        source:"qrc:/design/media/kodi/stopBtn.svg"
                        MouseArea{
                            anchors.fill: parent
                            onClicked: function()
                            {
                                mp_mng.stop();
                                mp_mng.getData();

                            }
                        }
                    }
                }
                Item{
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Image{
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        source:"qrc:/design/media/kodi/playBtn.svg"
                        MouseArea{
                            anchors.fill: parent
                            onClicked: function()
                            {
                                mp_mng.playPause();
                                mp_mng.getData();

                            }
                        }
                    }
                }
                Item{
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Image{
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        source:"qrc:/design/media/kodi/pauseBtn.svg"

                        MouseArea{
                            anchors.fill: parent
                            onClicked: function()
                            {
                                mp_mng.playPause();
                                mp_mng.getData();

                            }
                        }
                    }
                }
            }

        }
    }
}
