import QtQuick 2.0
import QtQuick.Layouts 1.1
import ck.gmachine 1.0

Item {
    id:root
    width:parent.width
//    height:768






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
                        bgSource : "qrc:/design/general/System.svg"
                        info:false
                        onClicked:GSystem.systemOnOff()
                    }

                    FooterButton {
                        id:btnDoor
                        bgSource : "qrc:/design/general/Door.svg"
                        pressKey:"controls/right_door"
                        releaseKey:"controls/right_door_stop"
                    }

                    FooterButton {
                        id:btnLeftDoor
                        visible: SM.twodoor
                        bgSource : "qrc:/design/general/Door_leftside.svg"
                        pressKey: "controls/left_door"
                        releaseKey:"controls/left_door_stop"
                    }

                    FooterButton {
                        id:btnIntercom
                        bgSource : "qrc:/design/general/Intercom.svg"
                        pressKey: "controls/intercom"
                    }

                    FooterButton {
                        id:btnMute
                        visible: SM.amp
                        bgSource : (toggled==false ?
                                                    (isUnderClick ?  "qrc:/design/general/Mute_off.svg" : "qrc:/design/general/Mute_on.svg")
                                                   : (isUnderClick ?  "qrc:/design/general/Mute_on.svg" : "qrc:/design/general/Mute_off.svg"))
                        height: GSystem.bottomIconHeight
                        //pressKey: ""
                        releaseKey: (toggled==false ?  "controls/mute" : "controls/unmute" )

                    }

                    FooterButton {
                        id:btnVolumeUp
                        bgSource : "qrc:/design/general/volumeup.svg"
                        visible: SM.amp
                        height: GSystem.bottomIconHeight
                        pressKey: "controls/volume_up"
                        releaseKey: "controls/volume_up_stop"
                    }

                    FooterButton {
                        id:btnVolumeDown
                        bgSource : "qrc:/design/general/volumedown.svg"
                        visible: SM.amp
                        height: GSystem.bottomIconHeight
                        pressKey: "controls/volume_down"
                        releaseKey: "controls/volume_down_stop"
                    }

                    FooterButton {
                        id:output
                        bgSource : "qrc:/design/general/audiosource.svg"
                        visible: SM.amp
                        height: GSystem.bottomIconHeight
                        pressKey: "controls/audio_source"
                    }

                    FooterButton {
                        id: screenup
                        bgSource : "qrc:/design/general/screenup.svg"
                        pressKey: "controls/screen_up"
                        releaseKey: "controls/screen_stop"
                    }

                    FooterButton {
                        id:screendown
                        bgSource : "qrc:/design/general/screendown.svg"
                        pressKey: "controls/screen_down"
                        releaseKey: "controls/screen_stop"
                    }



                    FooterButton {
                        id:btnSettings
                        info:false
                        bgSource : "qrc:/design/general/Settings.svg"
                        onClicked: function(){
                                console.log("system clicked");
                                GSystem.state = "GeneralSettings";
                                GSystem.changePage("GeneralSettings");
                        }
                    }




            }


            FooterButton{
                id:infobtn
                anchors.right: rowRectangle.right
                info:false
                bgSource : "qrc:/design/general/info.svg"
                onClicked: function(){
                        GSystem.infoverlay.come();
                }
            }

                    }
            }


            MicrophoneBtn{
                anchors.left: rowRectangle.right
                y:-25
                anchors.leftMargin: 230
                service:GSystem.voice_recognition.state
            }
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
