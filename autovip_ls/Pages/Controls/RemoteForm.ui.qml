import QtQuick 2.4
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.1


Item {
    width: 1024
    height: 696
    id:root
    property int big_btn_height: 65
    property int btn_height : 48
    property int menu_left: 200
    property int menu_center: 512

    ColumnLayout{
//        width: 335
        width: 470
        x: menu_center-width/2
        anchors.top: parent.top
        anchors.topMargin: 132
//        y: 132

//        height: 564
        spacing: 0
        Grid {
    //        x: menu_left+145
    //        y: 132
    //        width: 335
    //        height: 564
            Layout.alignment: Qt.AlignCenter
            flow: Grid.TopToBottom
            rows: 9
            columns: 3
            rowSpacing: 1
            columnSpacing: 6

            Item {width: 100; height: big_btn_height}
            Item {width: 100; height: btn_height}
            Button {
                image.source:"qrc:/design/controls/remote/remoteLeft.png"
                mouseArea.onPressed: {serial_mng.sendKey("iptv/left");}
                mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
            }
            Item {width: 100; height: btn_height}
            Button {
                image.source:"qrc:/design/controls/remote/1.png"
                mouseArea.onPressed: {serial_mng.sendKey("iptv/num_1");}
                mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
            }
            Button {
                image.source:"qrc:/design/controls/remote/4.png"
                mouseArea.onPressed: {serial_mng.sendKey("iptv/num_4");}
                mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
            }
            Button {
                image.source:"qrc:/design/controls/remote/7.png"
                mouseArea.onPressed: {serial_mng.sendKey("iptv/num_7");}
                mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
            }
            Item {width: 100; height: btn_height}
            Button {
                image.source:"qrc:/design/controls/remote/remoteReturn.png"
                mouseArea.onPressed: {serial_mng.sendKey("iptv/return");}
                mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
            }
            Button {
                height: big_btn_height
    //            width: big_btn_height + 10
    //            image.fillMode: Image.Stretch
                image.source:"qrc:/design/controls/remote/remoteSling.png"
                mouseArea.onPressed: {serial_mng.sendKey("iptv/settings");}
                mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
            }
            Button {
                image.source:"qrc:/design/controls/remote/remoteUp.png"
                mouseArea.onPressed: {serial_mng.sendKey("iptv/up");}
                mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
            }
            Button {
                image.source:"qrc:/design/controls/remote/Ok.png"
                mouseArea.onPressed: {serial_mng.sendKey("iptv/ok");}
                mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
            }
            Button {
                image.source:"qrc:/design/controls/remote/remoteDown.png"
                mouseArea.onPressed: {serial_mng.sendKey("iptv/down");}
                mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
            }
            Button {
                image.source:"qrc:/design/controls/remote/2.png"
                mouseArea.onPressed: {serial_mng.sendKey("iptv/num_2");}
                mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
            }
            Button {
                image.source:"qrc:/design/controls/remote/5.png"
                mouseArea.onPressed: {serial_mng.sendKey("iptv/num_5");}
                mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
            }
            Button {
                image.source:"qrc:/design/controls/remote/8.png"
                mouseArea.onPressed: {serial_mng.sendKey("iptv/num_8");}
                mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
            }
            Button {
                image.source:"qrc:/design/controls/remote/0.png"
                mouseArea.onPressed: {serial_mng.sendKey("iptv/num_0");}
                mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
            }
            Button {
                image.source:"qrc:/design/controls/remote/remoteScissor.png"
                mouseArea.onPressed: {serial_mng.sendKey("iptv/cut");}
                mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
            }
            Item {width: 100; height: big_btn_height}
            Item {width: 100; height: btn_height}
            Button {
                image.source:"qrc:/design/controls/remote/remoteRight.png"
                mouseArea.onPressed: {serial_mng.sendKey("iptv/right");}
                mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
            }
            Item {width: 100; height: btn_height}
            Button {
                image.source:"qrc:/design/controls/remote/3.png"
                mouseArea.onPressed: {serial_mng.sendKey("iptv/num_3");}
                mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
            }
            Button {
                image.source:"qrc:/design/controls/remote/6.png"
                mouseArea.onPressed: {serial_mng.sendKey("iptv/num_6");}
                mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
            }
            Button {
                image.source:"qrc:/design/controls/remote/9.png"
                mouseArea.onPressed: {serial_mng.sendKey("iptv/num_9");}
                mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
            }
            Item {width: 100; height: btn_height}
            Button {
                image.source:"qrc:/design/controls/remote/remoteNext.png"
                mouseArea.onPressed: {serial_mng.sendKey("iptv/next");}
                mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
            }
        }
        Grid {
            flow: Grid.TopToBottom
            rows: 2
            columns: 4
            rowSpacing: 1
            columnSpacing: 6
            Layout.alignment: Qt.AlignCenter
            Button {
                image.source:"qrc:/design/controls/remote/butonRed.png"
                mouseArea.onPressed: {serial_mng.sendKey("iptv/red");}
                mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
            }
            Button {
                image.source:"qrc:/design/controls/remote/remoteFastBackward.png"
                mouseArea.onPressed: {serial_mng.sendKey("iptv/seek_backward");}
                mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
            }
            Button {
                image.source:"qrc:/design/controls/remote/butonGreen.png"
                mouseArea.onPressed: {serial_mng.sendKey("iptv/green");}
                mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
            }
            Button {
                image.source:"qrc:/design/controls/remote/remotePlay.png"
                mouseArea.onPressed: {serial_mng.sendKey("iptv/play");}
                mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
            }
            Button {
                image.source:"qrc:/design/controls/remote/butonYellow.png"
                mouseArea.onPressed: {serial_mng.sendKey("iptv/yellow");}
                mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
            }
            Button {
                image.source:"qrc:/design/controls/remote/remotePause.png"
                mouseArea.onPressed: {serial_mng.sendKey("iptv/pause");}
                mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
            }
            Button {
                image.source:"qrc:/design/controls/remote/butonBlue.png"
                mouseArea.onPressed: {serial_mng.sendKey("iptv/blue");}
                mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
            }
            Button {
                image.source:"qrc:/design/controls/remote/remoteFastForward.png"
                mouseArea.onPressed: {serial_mng.sendKey("iptv/seek_forward");}
                mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
            }
        }
    }

    Grid {
        id: outergrid
//        x: menu_left
        y: 132
        width: 722
        height: 564

        x: menu_center-width/2
        flow: Grid.TopToBottom
        rows: 11
        columns: 5
        rowSpacing: 1
        columnSpacing: 515

        Item {
            width: 100
            height: big_btn_height
        }

        Button {
            image.source:"qrc:/design/controls/remote/Tv_power.png"
            mouseArea.onPressed: {serial_mng.sendKey("iptv/tv_power");}
            mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
        }
        Button {
            image.source:"qrc:/design/controls/remote/Chan+.png"
            mouseArea.onPressed: {serial_mng.sendKey("iptv/chan_up");}
            mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
        }

        Button {
            image.source:"qrc:/design/controls/remote/Chan-.png"
            mouseArea.onPressed: {serial_mng.sendKey("iptv/chan_down");}
            mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
        }

        Button {
            image.source:"qrc:/design/controls/remote/Page+.png"
            mouseArea.onPressed: {serial_mng.sendKey("iptv/page_up");}
            mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
        }

        Button {
            image.source:"qrc:/design/controls/remote/Page-.png"
            mouseArea.onPressed: {serial_mng.sendKey("iptv/page_down");}
            mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
        }

        Button {
            image.source:"qrc:/design/controls/remote/Menu.png"
            mouseArea.onPressed: {serial_mng.sendKey("iptv/menu");}
            mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
        }

        Button {
            image.source:"qrc:/design/controls/remote/Guide.png"
            mouseArea.onPressed: {serial_mng.sendKey("iptv/guide");}
            mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
        }

        Button {
            image.source:"qrc:/design/controls/remote/Jump.png"
            mouseArea.onPressed: {serial_mng.sendKey("iptv/jump");}
            mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
        }

        Button {
            image.source:"qrc:/design/controls/remote/Clear.png"
            mouseArea.onPressed: {serial_mng.sendKey("iptv/clear");}
            mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
        }

        Button {
            image.source:"qrc:/design/controls/remote/Record.png"
            mouseArea.onPressed: {serial_mng.sendKey("iptv/rec");}
            mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
        }

        Button {
            height: big_btn_height
            image.fillMode: Image.PreserveAspectFit
            image.source:"qrc:/design/controls/remote/remotePower.png"
            mouseArea.onPressed: {serial_mng.sendKey("iptv/power");}
            mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
        }
        Button {
            image.source:"qrc:/design/controls/remote/Tv_Input.png"
            mouseArea.onPressed: {serial_mng.sendKey("iptv/tv_input");}
            mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
        }

        Button {
            image.source:"qrc:/design/controls/remote/Vol+.png"
            mouseArea.onPressed: {serial_mng.sendKey("iptv/vol_up");}
            mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
        }

        Button {
            image.source:"qrc:/design/controls/remote/Vol-.png"
            mouseArea.onPressed: {serial_mng.sendKey("iptv/vol_down");}
            mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
        }

        Button {
            image.source:"qrc:/design/controls/remote/Mute.png"
            mouseArea.onPressed: {serial_mng.sendKey("iptv/mute");}
            mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
        }

        Button {
            image.source:"qrc:/design/controls/remote/Info.png"
            mouseArea.onPressed: {serial_mng.sendKey("iptv/info");}
            mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
        }

        Button {
            image.source:"qrc:/design/controls/remote/Back.png"
            mouseArea.onPressed: {serial_mng.sendKey("iptv/back");}
            mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
        }

        Button {
            image.source:"qrc:/design/controls/remote/Mode.png"
            mouseArea.onPressed: {serial_mng.sendKey("iptv/mode");}
            mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
        }

        Button {
            image.source:"qrc:/design/controls/remote/Opt.png"
            mouseArea.onPressed: {serial_mng.sendKey("iptv/opt");}
            mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
        }

        Button {
            image.source:"qrc:/design/controls/remote/Enter.png"
            mouseArea.onPressed: {serial_mng.sendKey("iptv/enter");}
            mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
        }

        Button {
            image.source:"qrc:/design/controls/remote/remoteStop.png"
            mouseArea.onPressed: {serial_mng.sendKey("iptv/stop");}
            mouseArea.onReleased: {serial_mng.sendKey("iptv/stop_cmd");}
        }
    }
}
