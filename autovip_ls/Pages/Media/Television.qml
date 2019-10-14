import QtQuick 2.4
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import ck.gmachine 1.0
import QtGraphicalEffects 1.0
import "../../Components"

BasePage {
    id:root
    caption: qsTr("TELEVISION") + mytrans.emptyString
    pageName: "Television"
    property int delay: -1
    property color shadowColor: "red"

    function sendCommand(command){
        switch(SM.tvtype){
            case  6:
                serial_mng.sendKey("samsung_tv/"+command,true,delay);
                break;
            case 7:
                serial_mng.sendKey("lg_tv/"+command,true,delay);
                break;
        }
    }


    Rectangle{
        id:powerBtn
        width: 20
        height: 20
        x:300
        y:190
        color: "transparent"

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

    Rectangle{
        id:rec
        width: 215
        height: 330
        x:300
        y:250
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
                            sendCommand("one");
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
                               sendCommand("two");
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
                            sendCommand("three");
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
                            sendCommand("four");
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
                            sendCommand("five");
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
                            sendCommand("six");
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
                            sendCommand("seven");
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
                                sendCommand("eight");
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
                            sendCommand("nine");
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
                    id:displayImage
                    source:"qrc:/design/media/Tv/buton-display.svg"
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            sendCommand("display");
                            displayDs.visible = true;
                        }
                        onClicked : displayDs.visible = false
                        onReleased: {displayDs.visible = false; sendCommand("stop_code"); }
                   }

                }
                DropShadow {
                  id: displayDs
                  anchors.fill: displayImage
                  horizontalOffset: 0
                  verticalOffset: 3
                  radius: 8.0
                  samples: 12
                  source: displayImage
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
                            sendCommand("zero");
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
                    id:subtitleImage
                    source:"qrc:/design/media/Tv/buton-subtitle.svg"
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            sendCommand("subtitle");
                            subtitleDs.visible = true;
                        }
                        onClicked :{ subtitleDs.visible = false; }
                        onReleased:{ subtitleDs.visible = false;  sendCommand("stop_code");}
                   }

                }
                DropShadow {
                  id: subtitleDs
                  anchors.fill: subtitleImage
                  horizontalOffset: 0
                  verticalOffset: 3
                  radius: 8.0
                  samples: 12
                  source: subtitleImage
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
            Rectangle{
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                color: "transparent"
                Image{
                    id:clearImage
                    source:"qrc:/design/media/Tv/buton-clear.svg"
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            sendCommand("clear");
                            clearDs.visible = true
                        }
                        onClicked: clearDs.visible = false
                        onReleased: {clearDs.visible = false; sendCommand("stop_code"); }
                   }

                }
                DropShadow {
                  id: clearDs
                  anchors.fill: clearImage
                  horizontalOffset: 0
                  verticalOffset: 3
                  radius: 8.0
                  samples: 12
                  source: clearImage
                  color: shadowColor
                  visible: false
                }
            }
            Rectangle{
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                color: "transparent"
                Image{
                    id:titleImage
                    source:"qrc:/design/media/Tv/buton-title.svg"
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            sendCommand("title");
                            titleDs.visible = true
                        }

                        onClicked : titleDs.visible = false
                        onReleased: { titleDs.visible = false; sendCommand("stop_code");}

                   }

                }

                DropShadow {
                  id: titleDs
                  anchors.fill: titleImage
                  horizontalOffset: 0
                  verticalOffset: 3
                  radius: 8.0
                  samples: 12
                  source: titleImage
                  color: shadowColor
                  visible: false
                }

            }

        }

    }

    Rectangle{
        width: 215
        height: 330
        x:550
        y:250
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
                    id: homeImage
                    source:"qrc:/design/media/Tv/buton-home.svg"
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            sendCommand("home");
                            homeDs.visible = true;
                        }
                        onClicked: homeDs.visible = false
                        onReleased: {homeDs.visible = false; sendCommand("stop_code"); }
                   }

                }
                DropShadow {
                  id: homeDs
                  anchors.fill: homeImage
                  horizontalOffset: 0
                  verticalOffset: 3
                  radius: 8.0
                  samples: 12
                  source: homeImage
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
            Rectangle{
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                color: "transparent"
                Image{
                    id:progImage
                    source:"qrc:/design/media/Tv/buton-prog.svg"
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            sendCommand("prog");
                            progDs.visible = true;
                        }
                        onClicked: progDs.visible = false
                        onReleased: {progDs.visible = false; sendCommand("stop_code"); }
                   }

                }
                DropShadow {
                  id: progDs
                  anchors.fill: progImage
                  horizontalOffset: 0
                  verticalOffset: 3
                  radius: 8.0
                  samples: 12
                  source: progImage
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
                            sendCommand("up_arrow");
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
                    id:bmarkImage
                    source:"qrc:/design/media/Tv/buton-bmark.svg"
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            sendCommand("bmark");
                            bmarkDs.visible = true;
                        }
                        onClicked: bmarkDs.visible = false
                        onReleased: { bmarkDs.visible = false; sendCommand("stop_code"); }
                   }

                }
                DropShadow {
                  id: bmarkDs
                  anchors.fill: bmarkImage
                  horizontalOffset: 0
                  verticalOffset: 3
                  radius: 8.0
                  samples: 12
                  source: bmarkImage
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
                            sendCommand("left_arrow");
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
                            sendCommand("okey");
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
                            sendCommand("right_arrow");
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
                    id: zoomImage
                    source:"qrc:/design/media/Tv/buton-zoom.svg"
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            sendCommand("zoom");
                            zoomDs.visible = true;
                        }
                        onClicked: zoomDs.visible = false
                        onReleased:{ zoomDs.visible = false; sendCommand("stop_code"); }
                   }

                }
                DropShadow {
                  id: zoomDs
                  anchors.fill: zoomImage
                  horizontalOffset: 0
                  verticalOffset: 3
                  radius: 8.0
                  samples: 12
                  source: zoomImage
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
                            sendCommand("down_arrow");
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
                    id: randomImage
                    source:"qrc:/design/media/Tv/buton-random.svg"
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            sendCommand("random");
                            randomDs.visible = true;
                        }
                        onClicked: randomDs.visible = false
                        onReleased:{ randomDs.visible = false; sendCommand("stop_code"); }
                   }

                }
                DropShadow {
                  id: randomDs
                  anchors.fill:randomImage
                  horizontalOffset: 0
                  verticalOffset: 3
                  radius: 8.0
                  samples: 12
                  source: randomImage
                  color: shadowColor
                  visible: false
                }
            }
            Rectangle{
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                color: "transparent"
                Image{
                    id: mediaImage
                    source:"qrc:/design/media/Tv/buton-media.svg"
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            sendCommand("media");
                            mediaDs.visible = true;
                        }
                        onClicked: mediaDs.visible = false
                        onReleased:{ mediaDs.visible = false; sendCommand("stop_code"); }
                   }

                }
                DropShadow {
                  id: mediaDs
                  anchors.fill:mediaImage
                  horizontalOffset: 0
                  verticalOffset: 3
                  radius: 8.0
                  samples: 12
                  source: mediaImage
                  color: shadowColor
                  visible: false
                }
            }
            Rectangle{
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                color: "transparent"
                Image{
                    id: audioImage
                    source:"qrc:/design/media/Tv/buton-audio.svg"
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            sendCommand("audio");
                            audioDs.visible = true;
                        }
                        onClicked: audioDs.visible = false
                        onReleased:{ audioDs.visible = false; sendCommand("stop_code"); }
                   }

                }
                DropShadow {
                  id: audioDs
                  anchors.fill:audioImage
                  horizontalOffset: 0
                  verticalOffset: 3
                  radius: 8.0
                  samples: 12
                  source: audioImage
                  color: shadowColor
                  visible: false
                }
            }
            Rectangle{
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                color: "transparent"
                Image{
                    id: oscImage
                    source:"qrc:/design/media/Tv/buton-osc.svg"
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            sendCommand("osc");
                            oscDs.visible = true;
                        }
                        onClicked: oscDs.visible = false
                        onReleased:{ oscDs.visible = false; sendCommand("stop_code"); }
                   }

                }
                DropShadow {
                  id: oscDs
                  anchors.fill:oscImage
                  horizontalOffset: 0
                  verticalOffset: 3
                  radius: 8.0
                  samples: 12
                  source: oscImage
                  color: shadowColor
                  visible: false
                }
            }

        }

    }

    Rectangle{
        width: 150
        height: 190
        x:790
        y:250
        color: "transparent"

        GridLayout{
            width:parent.width
            height:parent.height
            columns: 2
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
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                color: "transparent"
                Image{
                    id: playPauseImage
                    source:"qrc:/design/media/Tv/buton-play-pause.svg"
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            sendCommand("pause");
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
        }

    }

    Component.onCompleted:{
        switch(SM.tvtype)
        {
        case 6:
        root.delay = serial_mng.getSamsungDelay();
        break;
        case 7:
        root.delay = serial_mng.getLgDelay();
            break;
        }

    }




}
