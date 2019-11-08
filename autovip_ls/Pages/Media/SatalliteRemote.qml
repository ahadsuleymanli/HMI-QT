import QtQuick 2.4
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import ck.gmachine 1.0
import QtGraphicalEffects 1.0
import "../../Components"

BasePage {
    id:root
    caption: qsTr("SATALLITE") + mytrans.emptyString
    pageName: "Satallite"
    property int delay: -1
    property color shadowColor: "red"

    function sendCommand(command){
            serial_mng.sendKey("satallite_remote/"+command,true,delay);
    }
    Connections{
        target: GSystem
        onActivePageChanged:{
            if(GSystem.activePage === "Satallite")
                serial_mng.sendKey("media/satallite",true,delay);
        }
    }

    Rectangle{
        id:rec
        width: 215
        height: 330
        anchors.left: parent.left
        anchors.leftMargin: 150
        y:200
        color: "transparent"


        GridLayout{
            width:parent.width
            height:parent.height
            columns: 3
            Rectangle{
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                color: "transparent"
                Image{
                    id:oneImage
                    source:"qrc:/design/media/Tv/buton-1.svg"
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            sendCommand("num_one");
                            oneDs.visible = true
                        }
                        onReleased: {
                            oneDs.visible = false
                            sendCommand("stop_code");
                        }
                        onClicked : oneDs.visible = false
                   }

                }
                DropShadow {
                  id: oneDs
                  anchors.fill: oneImage
                  horizontalOffset: 0
                  verticalOffset: 3
                  radius: 8.0
                  samples: 12
                  source: oneImage
                  color: shadowColor
                  visible: false
                }
            }
            Rectangle{
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                color: "transparent"
                Image{
                    id:twoImage
                    source:"qrc:/design/media/Tv/buton-2.svg"
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                               sendCommand("num_two");
                               twoDs.visible = true
                        }
                        onClicked: {
                            twoDs.visible = false
                        }
                        onReleased: {
                            twoDs.visible = false
                            sendCommand("stop_code");
                        }
                   }

                }
                DropShadow {
                  id: twoDs
                  anchors.fill: twoImage
                  horizontalOffset: 0
                  verticalOffset: 3
                  radius: 8.0
                  samples: 12
                  source: twoImage
                  color: shadowColor
                  visible: false
                }
            }
            Rectangle{
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                color: "transparent"
                Image{
                    id: threeImage
                    source:"qrc:/design/media/Tv/buton-3.svg"
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            sendCommand("num_three");
                            threeDs.visible = true
                        }
                        onClicked: {
                            threeDs.visible = false
                        }
                        onReleased: {
                            threeDs.visible = false
                            sendCommand("stop_code");
                        }
                   }

                }
                DropShadow {
                  id: threeDs
                  anchors.fill: threeImage
                  horizontalOffset: 0
                  verticalOffset: 3
                  radius: 8.0
                  samples: 12
                  source: threeImage
                  color: shadowColor
                  visible: false
                }
            }
            Rectangle{
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                color: "transparent"
                Image{
                    id:fourImage
                    source:"qrc:/design/media/Tv/buton-4.svg"
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            sendCommand("num_four");
                            fourDs.visible = true;
                        }
                        onClicked: fourDs.visible = false
                        onReleased: {fourDs.visible = false; sendCommand("stop");}
                   }

                }
                DropShadow {
                  id: fourDs
                  anchors.fill: fourImage
                  horizontalOffset: 0
                  verticalOffset: 3
                  radius: 8.0
                  samples: 12
                  source: fourImage
                  color: shadowColor
                  visible: false
                }
            }
            Rectangle{
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                color: "transparent"
                Image{
                    id:fiveImage
                    source:"qrc:/design/media/Tv/buton-5.svg"
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            fiveDs.visible = true;
                            sendCommand("num_five");
                        }
                        onClicked: {
                            fiveDs.visible = false;
                        }
                        onReleased: {
                            fiveDs.visible = false;
                            sendCommand("stop_code");
                        }
                   }

                }
                DropShadow {
                  id: fiveDs
                  anchors.fill: fiveImage
                  horizontalOffset: 0
                  verticalOffset: 3
                  radius: 8.0
                  samples: 12
                  source: fiveImage
                  color: shadowColor
                  visible: false
                }
            }

            Rectangle{
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                color: "transparent"
                Image{
                    id:sixImage
                    source:"qrc:/design/media/Tv/buton-6.svg"
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            sendCommand("num_six");
                            sixDs.visible = true;
                        }
                        onClicked: sixDs.visible = false;
                        onReleased: {
                            sendCommand("stop_code");
                            sixDs.visible = false;
                        }
                   }

                }
                DropShadow {
                  id: sixDs
                  anchors.fill: sixImage
                  horizontalOffset: 0
                  verticalOffset: 3
                  radius: 8.0
                  samples: 12
                  source: sixImage
                  color: shadowColor
                  visible: false
                }
            }
            Rectangle{
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                color: "transparent"
                Image{
                    id:sevenImage
                    source:"qrc:/design/media/Tv/buton-7.svg"
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            sendCommand("num_seven");
                            sevenDs.visible = true
                        }
                        onReleased: {sevenDs.visible = false; sendCommand("stop_code");}
                        onClicked: sevenDs.visible = false
                   }

                }
                DropShadow {
                  id: sevenDs
                  anchors.fill: sevenImage
                  horizontalOffset: 0
                  verticalOffset: 3
                  radius: 8.0
                  samples: 12
                  source: sevenImage
                  color: shadowColor
                  visible: false
                }
            }
            Rectangle{
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                color: "transparent"
                Image{
                    id:eightImage
                    source:"qrc:/design/media/Tv/buton-8.svg"
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                                sendCommand("num_eight");
                                eightDs.visible = true
                                }
                        onClicked: eightDs.visible = false
                        onReleased:{ eightDs.visible = false; sendCommand("stop_code"); }
                   }

                }
                DropShadow {
                  id: eightDs
                  anchors.fill: eightImage
                  horizontalOffset: 0
                  verticalOffset: 3
                  radius: 8.0
                  samples: 12
                  source: eightImage
                  color: shadowColor
                  visible: false
                }

            }
            Rectangle{
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                color: "transparent"
                Image{
                    id:nineImage
                    source:"qrc:/design/media/Tv/buton-9.svg"
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            sendCommand("num_nine");
                            nineDs.visible = true
                        }
                        onClicked : nineDs.visible = false
                        onReleased: { nineDs.visible = false; sendCommand("stop_code"); }
                   }

                }
                DropShadow {
                  id: nineDs
                  anchors.fill: nineImage
                  horizontalOffset: 0
                  verticalOffset: 3
                  radius: 8.0
                  samples: 12
                  source: nineImage
                  color: shadowColor
                  visible: false
                }
            }
            Rectangle{
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                color: "transparent"
                Image{
                    id: hdImage
                    source:"qrc:/design/media/Tv/btnBackground.png"
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            sendCommand("hd");
                            hdDs.visible = true;
                        }
                        onClicked: hdDs.visible = false
                        onReleased: {hdDs.visible = false; sendCommand("stop_code"); }
                   }
                }
                Text{
                    anchors.centerIn: hdImage
                    text: qsTr("HD")
                    color: "#ededed"
                }

                DropShadow {
                  id: hdDs
                  anchors.fill: hdImage
                  horizontalOffset: 0
                  verticalOffset: 3
                  radius: 8.0
                  samples: 12
                  source: hdImage
                  color: shadowColor
                  visible: false
                }
            }

            Rectangle{
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30

                color: "transparent"
                Image{
                    id:zeroImage
                    source:"qrc:/design/media/Tv/buton-0.svg"
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            sendCommand("num_zero");
                            zeroDs.visible = true
                        }
                        onClicked : zeroDs.visible = false
                        onReleased: {zeroDs.visible = false; sendCommand("stop_code"); }
                   }

                }
                DropShadow {
                  id: zeroDs
                  anchors.fill: zeroImage
                  horizontalOffset: 0
                  verticalOffset: 3
                  radius: 8.0
                  samples: 12
                  source: zeroImage
                  color: shadowColor
                  visible: false
                }
            }
            Rectangle{
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                color: "transparent"
                Image{
                    id:resImage
                    source:"qrc:/design/media/Tv/buton-res.svg"
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            sendCommand("res")
                            resDs.visible = true;
                        }
                        onReleased: { resDs.visible = false; sendCommand("stop_code"); }
                        onClicked: resDs.visible = false
                   }

                }
                DropShadow {
                  id: resDs
                  anchors.fill: resImage
                  horizontalOffset: 0
                  verticalOffset: 3
                  radius: 8.0
                  samples: 12
                  source: resImage
                  color: shadowColor
                  visible: false
                }
            }

        }

    }

    Rectangle{
        id: rec2
        width: 215
        height: 330
        anchors.left: rec.right
        anchors.leftMargin: 50
        y:200
        color: "transparent"


        GridLayout{
            width:parent.width
            height:parent.height
            columns: 3
            Rectangle{
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                color: "transparent"
                Image{
                    id: stopImage
                    source:"qrc:/design/media/Tv/buton-stop.svg"
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            sendCommand("stop");
                            stopDs.visible = true;
                        }
                        onClicked: stopDs.visible = false
                        onReleased:{ stopDs.visible = false; sendCommand("stop_code"); }
                   }

                }
                DropShadow {
                  id: stopDs
                  anchors.fill:stopImage
                  horizontalOffset: 0
                  verticalOffset: 3
                  radius: 8.0
                  samples: 12
                  source: stopImage
                  color: shadowColor
                  visible: false
                }
            }

            Rectangle{
                id: playPauseRect
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                color: "transparent"
                property bool isPlaying : true
                Image{
                    id: playPauseImage
                    source:"qrc:/design/media/Tv/buton-play-pause.svg"
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            sendCommand((playPauseRect.isPlaying ?"pause":"play"));
                            playPauseRect.isPlaying = !playPauseRect.isPlaying
                            playPauseDs.visible = true;
                        }
                        onClicked: playPauseDs.visible = false
                        onReleased:{ playPauseDs.visible = false; sendCommand("stop_code"); }
                   }

                }
                DropShadow {
                  id: playPauseDs
                  anchors.fill:playPauseImage
                  horizontalOffset: 0
                  verticalOffset: 3
                  radius: 8.0
                  samples: 12
                  source: playPauseImage
                  color: shadowColor
                  visible: false
                }

            }
            Rectangle{
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                color: "transparent"
                Image{
                    id: muteImage
                    source:"qrc:/design/media/Tv/btnBackground.png"
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            sendCommand("mute");
                            muteDs.visible = true;
                        }
                        onClicked: muteDs.visible = false
                        onReleased: {muteDs.visible = false; sendCommand("stop_code"); }
                   }
                }
                Text{
                    anchors.centerIn: muteImage
                    text: "Mute"
                    color: "#ededed"
                }

                DropShadow {
                  id: muteDs
                  anchors.fill: muteImage
                  horizontalOffset: 0
                  verticalOffset: 3
                  radius: 8.0
                  samples: 12
                  source: muteImage
                  color: shadowColor
                  visible: false
                }
            }
            Rectangle{
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                color: "transparent"
                Image{
                    id: rewindImage
                    source:"qrc:/design/media/Tv/buton-rewind.svg"
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            sendCommand("backward");
                            rewindDs.visible = true;
                        }
                        onClicked: rewindDs.visible = false
                        onReleased:{ rewindDs.visible = false; sendCommand("stop_code"); }
                   }

                }
                DropShadow {
                  id: rewindDs
                  anchors.fill:rewindImage
                  horizontalOffset: 0
                  verticalOffset: 3
                  radius: 8.0
                  samples: 12
                  source: rewindImage
                  color: shadowColor
                  visible: false
                }
            }
            Rectangle{
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                color: "transparent";
                Image{
                    id: upImage
                    source:"qrc:/design/media/Tv/buton-up.svg";
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            sendCommand("menu_up");
                            upDs.visible = true;
                        }
                        onClicked: upDs.visible = false
                        onReleased: { upDs.visible = false; sendCommand("stop_code"); }
                   }

                }
                DropShadow {
                  id: upDs
                  anchors.fill: upImage
                  horizontalOffset: 0
                  verticalOffset: 3
                  radius: 8.0
                  samples: 12
                  source: upImage
                  color: shadowColor
                  visible: false
                }
            }
            Rectangle{
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                color: "transparent"
                Image{
                    id: forwardImage
                    source:"qrc:/design/media/Tv/buton-forward.svg"
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            sendCommand("forward");
                            forwardDs.visible = true;
                        }
                        onClicked: forwardDs.visible = false
                        onReleased:{ forwardDs.visible = false; sendCommand("stop_code"); }
                   }

                }
                DropShadow {
                  id: forwardDs
                  anchors.fill:forwardImage
                  horizontalOffset: 0
                  verticalOffset: 3
                  radius: 8.0
                  samples: 12
                  source: forwardImage
                  color: shadowColor
                  visible: false
                }
            }


            Rectangle{
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                color: "transparent"
                Image{
                    id: leftImage
                    source:"qrc:/design/media/Tv/buton-left.svg"
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            sendCommand("menu_left");
                            leftDs.visible = true;
                        }
                        onClicked: leftDs.visible = false
                        onReleased:{ leftDs.visible = false; sendCommand("stop_code"); }
                   }

                }
                DropShadow {
                  id: leftDs
                  anchors.fill: leftImage
                  horizontalOffset: 0
                  verticalOffset: 3
                  radius: 8.0
                  samples: 12
                  source: leftImage
                  color: shadowColor
                  visible: false
                }
            }
            Rectangle{
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                color: "transparent"
                Image{
                    id: okeyImage
                    source:"qrc:/design/media/Tv/buton-okey.svg"
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            sendCommand("ok");
                            okeyDs.visible = true;
                        }
                        onClicked: okeyDs.visible = false
                        onReleased:{ okeyDs.visible = false; sendCommand("stop_code"); }
                   }

                }
                DropShadow {
                  id: okeyDs
                  anchors.fill: okeyImage
                  horizontalOffset: 0
                  verticalOffset: 3
                  radius: 8.0
                  samples: 12
                  source: okeyImage
                  color: shadowColor
                  visible: false
                }
            }
            Rectangle{
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                color: "transparent"
                Image{
                    id: rightImage
                    source:"qrc:/design/media/Tv/buton-right.svg"
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            sendCommand("menu_right");
                            rightDs.visible = true;
                        }
                        onClicked: rightDs.visible = false
                        onReleased:{ rightDs.visible = false; sendCommand("stop_code"); }
                   }

                }
                DropShadow {
                  id: rightDs
                  anchors.fill: rightImage
                  horizontalOffset: 0
                  verticalOffset: 3
                  radius: 8.0
                  samples: 12
                  source: rightImage
                  color: shadowColor
                  visible: false
                }
            }

            Rectangle{
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                color: "transparent"
                Image{
                    id: previousImage
                    source:"qrc:/design/media/Tv/buton-previous.svg"
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            sendCommand("previous");
                            previousDs.visible = true;
                        }
                        onClicked: previousDs.visible = false
                        onReleased:{ previousDs.visible = false; sendCommand("stop_code"); }
                   }

                }
                DropShadow {
                  id: previousDs
                  anchors.fill:previousImage
                  horizontalOffset: 0
                  verticalOffset: 3
                  radius: 8.0
                  samples: 12
                  source: previousImage
                  color: shadowColor
                  visible: false
                }
            }
            Rectangle{
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                color: "transparent"
                Image{
                    id: downImage
                    source:"qrc:/design/media/Tv/buton-down.svg"
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            sendCommand("menu_down");
                            downDs.visible = true;
                        }
                        onClicked: downDs.visible = false
                        onReleased:{ downDs.visible = false; sendCommand("stop_code"); }
                   }

                }
                DropShadow {
                  id: downDs
                  anchors.fill: downImage
                  horizontalOffset: 0
                  verticalOffset: 3
                  radius: 8.0
                  samples: 12
                  source: downImage
                  color: shadowColor
                  visible: false
                }
            }
            Rectangle{
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                color: "transparent"
                Image{
                    id:nextImage
                    source:"qrc:/design/media/Tv/buton-next.svg"
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            sendCommand("next");
                            nextDs.visible = true;
                        }
                        onClicked: nextDs.visible = false
                        onReleased:{ nextDs.visible = false; sendCommand("stop_code"); }
                   }

                }
                DropShadow {
                  id: nextDs
                  anchors.fill:nextImage
                  horizontalOffset: 0
                  verticalOffset: 3
                  radius: 8.0
                  samples: 12
                  source: nextImage
                  color: shadowColor
                  visible: false
                }
            }
        }
    }

    Rectangle{
        id: rec3
        width: 215
        height: 330
        anchors.left: rec2.right
        anchors.leftMargin: 50
        y:200
        color: "transparent"

        GridLayout{
            id: thirdGrid
            width:parent.width
            height:parent.height
            columns: 3

            Rectangle{
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                color: "transparent"
                Image{
                    id: menuImage
                    source:"qrc:/design/media/Tv/buton-menu.svg"
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            sendCommand("menu");
                            menuDs.visible = true;
                        }
                        onClicked: menuDs.visible = false
                        onReleased: {menuDs.visible = false; sendCommand("stop_code"); }
                   }

                }
                DropShadow {
                  id: menuDs
                  anchors.fill: menuImage
                  horizontalOffset: 0
                  verticalOffset: 3
                  radius: 8.0
                  samples: 12
                  source: menuImage
                  color: shadowColor
                  visible: false
                }
            }

            Rectangle{
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                color: "transparent"
                Image{
                    id: returnImage
                    source:"qrc:/design/media/Tv/buton-return.svg"
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            sendCommand("return");
                            returnDs.visible = true;
                        }
                        onClicked: returnDs.visible = false
                        onReleased:{ returnDs.visible = false; sendCommand("stop_code"); }
                   }

                }
                DropShadow {
                  id: returnDs
                  anchors.fill: returnImage
                  horizontalOffset: 0
                  verticalOffset: 3
                  radius: 8.0
                  samples: 12
                  source: returnImage
                  color: shadowColor
                  visible: false
                }
            }
            Loader{
                id: exit
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                sourceComponent: satButtonComponent
                onLoaded: {
                    item.imgSource = "qrc:/design/media/Tv/btnBackground.png"
                    item.command = "exit"
                    item.stopCommand="stop_code"
                    item.str = "EXIT"
                }
            }
            Loader{
                id: adl
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                sourceComponent: satButtonComponent
                onLoaded: {
                    item.imgSource = "qrc:/design/media/Tv/btnBackground.png"
                    item.command = "adl"
                    item.stopCommand="stop_code"
                    item.str = "ADL"
                }
            }
            Loader{
                id: inf
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                sourceComponent: satButtonComponent
                onLoaded: {
                    item.imgSource = "qrc:/design/media/Tv/btnBackground.png"
                    item.command = "inf_plus"
                    item.stopCommand="stop_code"
                    item.str = "INF+"
                }
            }
            Loader{
                id: txt
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                sourceComponent: satButtonComponent
                onLoaded: {
                    item.imgSource = "qrc:/design/media/Tv/btnBackground.png"
                    item.command = "txt"
                    item.stopCommand="stop_code"
                    item.str = "TXT"
                }
            }
            Loader{
                id: usb
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                sourceComponent: satButtonComponent
                onLoaded: {
                    item.imgSource = "qrc:/design/media/Tv/btnBackground.png"
                    item.command = "usb"
                    item.stopCommand="stop_code"
                    item.str = "USB"
                }
            }
            Loader{
                id: tvr
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                sourceComponent: satButtonComponent
                onLoaded: {
                    item.imgSource = "qrc:/design/media/Tv/btnBackground.png"
                    item.command = "tv_r"
                    item.stopCommand="stop_code"
                    item.str = "TV/R"
                }
            }
            Loader{
                id: m_plus
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                sourceComponent: satButtonComponent
                onLoaded: {
                    item.imgSource = "qrc:/design/media/Tv/btnBackground.png"
                    item.command = "m_plus"
                    item.stopCommand="stop_code"
                    item.str = "M+"
                }
            }
            Loader{
                id: fav
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                sourceComponent: satButtonComponent
                onLoaded: {
                    item.imgSource = "qrc:/design/media/Tv/btnBackground.png"
                    item.command = "fav"
                    item.stopCommand="stop_code"
                    item.str = "FAV"
                }
            }
            Loader{
                id: iptv
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                sourceComponent: satButtonComponent
                onLoaded: {
                    item.imgSource = "qrc:/design/media/Tv/btnBackground.png"
                    item.command = "iptv"
                    item.stopCommand="stop_code"
                    item.str = "IPTV"
                }
            }
            Loader{
                id: epg
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                sourceComponent: satButtonComponent
                onLoaded: {
                    item.imgSource = "qrc:/design/media/Tv/btnBackground.png"
                    item.command = "epg"
                    item.stopCommand="stop_code"
                    item.str = "EPG"
                }
            }
        }

    }

    RowLayout{
        anchors.left: parent.left
        anchors.top: rec.bottom
        anchors.topMargin: 30
        anchors.right: parent.right
        spacing: 50
        Item{
            Layout.fillWidth: true
        }

        Loader{
            id: record
            Layout.preferredWidth: 30
            Layout.preferredHeight: 30
            sourceComponent: satButtonComponent
            onLoaded: {
                item.imgSource = "qrc:/design/media/Tv/btnBackground.png"
                item.command = "record"
                item.stopCommand="stop_code"
                item.str = "Record"
            }
        }
        Loader{
            id: vplus
            Layout.preferredWidth: 30
            Layout.preferredHeight: 30
            sourceComponent: satButtonComponent
            onLoaded: {
                item.imgSource = "qrc:/design/media/Tv/btnBackground.png"
                item.command = "vol_up"
                item.stopCommand="stop_code"
                item.str = "V+"
            }
        }
        Loader{
            id: vminus
            Layout.preferredWidth: 30
            Layout.preferredHeight: 30
            sourceComponent: satButtonComponent
            onLoaded: {
                item.imgSource = "qrc:/design/media/Tv/btnBackground.png"
                item.command = "vol_down"
                item.stopCommand="stop_code"
                item.str = "V-"
            }
        }
        Loader{
            id: pplus
            Layout.preferredWidth: 30
            Layout.preferredHeight: 30
            sourceComponent: satButtonComponent
            onLoaded: {
                item.imgSource = "qrc:/design/media/Tv/btnBackground.png"
                item.command = "prog_up"
                item.stopCommand="stop_code"
                item.str = "P+"
            }
        }
        Loader{
            id: pminus
            Layout.preferredWidth: 30
            Layout.preferredHeight: 30
            sourceComponent: satButtonComponent
            onLoaded: {
                item.imgSource = "qrc:/design/media/Tv/btnBackground.png"
                item.command = "prog_down"
                item.stopCommand="stop_code"
                item.str = "P-"
            }
        }
        Loader{
            id: a
            Layout.preferredWidth: 30
            Layout.preferredHeight: 30
            sourceComponent: satButtonComponent
            onLoaded: {
                item.imgSource = "qrc:/design/media/Tv/btnBackground.png"
                item.command = "a"
                item.stopCommand="stop_code"
                item.str = "A"
            }
        }
        Loader{
            id: b
            Layout.preferredWidth: 30
            Layout.preferredHeight: 30
            sourceComponent: satButtonComponent
            onLoaded: {
                item.imgSource = "qrc:/design/media/Tv/btnBackground.png"
                item.command = "b"
                item.stopCommand="stop_code"
                item.str = "B"
            }
        }
        Loader{
            id: c
            Layout.preferredWidth: 30
            Layout.preferredHeight: 30
            sourceComponent: satButtonComponent
            onLoaded: {
                item.imgSource = "qrc:/design/media/Tv/btnBackground.png"
                item.command = "c"
                item.stopCommand="stop_code"
                item.str = "C"
            }
        }
        Loader{
            id: d
            Layout.preferredWidth: 30
            Layout.preferredHeight: 30
            sourceComponent: satButtonComponent
            onLoaded: {
                item.imgSource = "qrc:/design/media/Tv/btnBackground.png"
                item.command = "d"
                item.stopCommand="stop_code"
                item.str = "D"
            }
        }
        Loader{
            id: info
            Layout.preferredWidth: 30
            Layout.preferredHeight: 30
            sourceComponent: satButtonComponent
            onLoaded: {
                item.imgSource = "qrc:/design/media/Tv/btnBackground.png"
                item.command = "info"
                item.stopCommand="stop_code"
                item.str = "INFO"
            }
        }
        Loader{
            id: sat
            Layout.preferredWidth: 30
            Layout.preferredHeight: 30
            sourceComponent: satButtonComponent
            onLoaded: {
                item.imgSource = "qrc:/design/media/Tv/btnBackground.png"
                item.command = "sat"
                item.stopCommand="stop_code"
                item.str = "SAT"
            }
        }
        Item{
            Layout.fillWidth: true
        }
    }

    Rectangle{
        anchors.right: rec3.right
        anchors.bottom: rec3.top
        anchors.rightMargin: 37
        anchors.bottomMargin: 10
        width: 30
        height: 30
        color: "transparent";

        Image{
            id: powerImage
            source:"qrc:/design/media/Tv/buton-power.svg"
            MouseArea{
                anchors.fill: parent
                onPressed: {
                    powerDs.visible = true
                    sendCommand("power");
                }
                onReleased: {
                    powerDs.visible = false
                    sendCommand("stop_code");
                    }
                onClicked: powerDs.visible = false
           }

        }
        DropShadow {
          id: powerDs
          anchors.fill: powerImage
          horizontalOffset: 0
          verticalOffset: 3
          radius: 8.0
          samples: 12
          source: powerImage
          color: shadowColor
          visible: false
        }
    }
    Component{
        id: satButtonComponent
        Rectangle{
            id: compRect
            anchors.fill: parent

            color: "transparent";
            property var imgSource: ""
            property var command: ""
            property var stopCommand: ""
            property var str: ""
            Image{
                id: image
                source: compRect.imgSource
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        ds.visible = true
                        sendCommand(compRect.command);
                    }
                    onReleased: {
                        ds.visible = false
                        sendCommand(compRect.stopCommand);
                        }
                    onClicked: ds.visible = false
               }

            }
            DropShadow {
              id: ds
              anchors.fill: image
              horizontalOffset: 0
              verticalOffset: 3
              radius: 8.0
              samples: 12
              source: image
              color: shadowColor
              visible: false
            }
            Text {
                anchors.centerIn: image
                text: compRect.str
                color:"#fdfdfd"
            }
        }
    }

}
