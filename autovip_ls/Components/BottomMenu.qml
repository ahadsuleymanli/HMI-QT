import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.0
import ck.gmachine 1.0

Item {
    id:root
    width:parent.width
//    height:768
    property alias btnIntercom: btnIntercom
    property alias btnVolumeUp: btnVolumeUp
    property alias btnVolumeDown: btnVolumeDown
        Rectangle{
            id:mainmenu
            width: root.width
            height: 140
            color: "transparent"
            y:0

            Behavior on y
            {
                NumberAnimation{
                duration:385
                }
            }
            Item{
                    id:rowRectangle
                    x:10
                    y:20
                    width:715
                    height:105

        RowLayout {
            spacing: 120
            anchors.fill: parent


            RowLayout {
                    spacing: 25
                    anchors.fill: parent
                    FooterButton {
                        id:btnQuit
                        Layout.fillHeight: true
                        bgSource : "qrc:/design/general/System.svg"
                        info:false
                        onClicked:GSystem.systemOnOff()
                    }

                    FooterButton {
                        id:btnDoor
                        Layout.fillHeight: true
                        bgSource : "qrc:/design/general/Door.svg"
                        pressKey:"controls/right_door"
                        releaseKey:"controls/right_door_stop"
                        infoPositionOffset: Qt.point(50,0)
                    }

                    FooterButton {
                        id:btnLeftDoor
                        Layout.fillHeight: true
                        visible: SM.twodoor
                        bgSource : "qrc:/design/general/Door_leftside.svg"
                        pressKey: "controls/left_door"
                        releaseKey:"controls/left_door_stop"
                    }

                    FooterButton {
                        id:btnIntercom
                        Layout.fillHeight: true
                        bgSource : "qrc:/design/general/Intercom.svg"
                        pressKey: "controls/intercom"

                    }

                    FooterButton {
                        id:btnMute
                        Layout.fillHeight: true
                        visible: SM.amp
                        bgSource : (toggled==true ?
                                                    (isUnderClick ?  "qrc:/design/general/Mute_off.svg" : "qrc:/design/general/Mute_on.svg")
                                                   : (isUnderClick ?  "qrc:/design/general/Mute_on.svg" : "qrc:/design/general/Mute_off.svg"))
                        height: GSystem.bottomIconHeight
                        //pressKey: ""
                        releaseKey: (toggled==false ?  "controls/mute" : "controls/unmute" )

                    }

                    FooterButton {
                        id:btnVolumeUp
                        Layout.fillHeight: true
                        bgSource : "qrc:/design/general/volumeup.svg"
                        visible: SM.amp
                        height: GSystem.bottomIconHeight
                        pressKey: "controls/volume_up"
                        releaseKey: "controls/volume_up_stop"
                    }

                    FooterButton {
                        id:btnVolumeDown
                        Layout.fillHeight: true
                        bgSource : "qrc:/design/general/volumedown.svg"
                        visible: SM.amp
                        height: GSystem.bottomIconHeight
                        pressKey: "controls/volume_down"
                        releaseKey: "controls/volume_down_stop"
                        infoPositionOffset: Qt.point(5,0)

                    }

                    ComboBox{
                        id: soundSourcesBox
//                        x: output.x
//                        y: output.y
                        Layout.fillHeight: true
                        width: 56
                        height: 46
                        visible: SM.amp
                        property real popupWidth: childrenRect.width
                        model: ListModel {
                            id: model
                            ListElement { name: "DVD"; command: "controls/aux_source" }
                            ListElement { name: "TV"; command: "controls/optic_source" }
//                            ListElement { name: "HILEVEL"; command: "controls/highlevel_source" }
//                            ListElement { name: "BLUETOOTH"; command: "controls/bluetooth_source" }
                        }
                        indicator: Image{
                            width: 56
                            height: 46
                            property var images: ["qrc:/design/general/audiosource_dvd.png",
                                "qrc:/design/general/audiosource_tv.png",
                                "qrc:/design/general/audiosource_hi.png",
                                "qrc:/design/general/bluetooth.png"]
                            source: images[serial_mng.soundSource]
                        }


                        background: Item{

                        }
                        contentItem: Item{

                        }
                        delegate: ItemDelegate {
                            width: 140
                            contentItem: Text {
                                text: name
                                color: soundSourcesBox.currentIndex === index ?
                                           "#21fefe" : "#dedede"
                                horizontalAlignment: Text.AlignHCenter
                                font: soundSourcesBox.font
                                elide: Text.ElideRight
                                verticalAlignment: Text.AlignVCenter
                            }
                            highlighted: soundSourcesBox.highlightedIndex === index
                            onClicked: serial_mng.sendKey(command)
                        }
                        popup: Popup {
                            y: soundSourcesBox.height + 15
                            x: -28
                            width: 140
                            implicitHeight: contentItem.implicitHeight
                            padding: 1

                            contentItem: ListView {
                                clip: true
                                implicitHeight: contentHeight
                                model: soundSourcesBox.popup.visible ? soundSourcesBox.delegateModel : null
                                currentIndex: soundSourcesBox.highlightedIndex

                                ScrollIndicator.vertical: ScrollIndicator { }
                            }

                            background: Rectangle {
                                color: "#ee101010"
                                border.color: "#a0219bbe"
                                radius: 2
                            }
                        }
                    }

                    FooterButton {
                        id: screenup
                        Layout.fillHeight: true
                        bgSource : "qrc:/design/general/screenup.svg"
                        pressKey: "controls/screen_up"
                        releaseKey: "controls/screen_stop"
                        infoPositionOffset: Qt.point(15,0)
                    }

                    FooterButton {
                        id:screendown
                        Layout.fillHeight: true
                        bgSource : "qrc:/design/general/screendown.svg"
                        pressKey: "controls/screen_down"
                        releaseKey: "controls/screen_stop"
                        infoPositionOffset: Qt.point(15,0)
                    }



                    FooterButton {
                        id:btnSettings
                        Layout.fillHeight: true
                        info:false
                        bgSource : "qrc:/design/general/Settings.svg"
                        onClicked: function(){
                                console.log("system clicked");
                                GSystem.state = "GeneralSettings";
                                GSystem.changePage("GeneralSettings");
                        }
                    }
            }


//            FooterButton{
//                id:infobtn
//                anchors.right: rowRectangle.right
//                info:false
//                bgSource : "qrc:/design/general/info.svg"
//                onClicked: function(){
//                        GSystem.infoverlay.come();
//                }
//            }

                    }

    }


//            MicrophoneBtn{
//                anchors.left: rowRectangle.right
//                y:-25
//                anchors.leftMargin: 230
//                service:GSystem.voice_recognition.state
//            }
            /*
            FooterButton {
                id:btnMicrophone
                bgSource : "qrc:/design/general/Microphone.svg"
                visible: true
                info:false
                clip:true
                height: 100
                width: 75
                anchors.left: rowRectangle.right
                y:-5
                anchors.leftMargin: 230
                onClicked: function(){
                    GSystem.voice_service.openMic();
                }
            }
            */
        }


}
