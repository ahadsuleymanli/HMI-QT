import QtQuick 2.0
import ck.gmachine 1.0
import closx.smanager 1.0

Image {
        id:root
        x : 0
        y : 0
        width: 1024
        height: 160
        signal pageChange(string pageName)
        function changePage(pageName)
        {
            console.log(pageName + "is clicked ");
            root.pageChange(pageName);
        }
        SettingsManager{
            id:smanager
        }


            DDate{
                id:topDate
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.topMargin: 30
                anchors.rightMargin: 29
            }

            DigitalClock {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.topMargin: 63
                anchors.rightMargin: 29
            }
            Item{
                y:0
                z:1
                width:540
                height:105
                anchors.horizontalCenter: parent.horizontalCenter
                Rectangle{
                    id:mainmenu
                    width: parent.width
                    height: parent.height
                    color: "transparent"
                    y:80
                    z:2

                    TopButton {
                                id:btnSeats
                                bgSource : "qrc:/design/general/Seats.svg"
                                textColor: "white"
                                x: 45
                                anchors.verticalCenter: parent.verticalCenter
                                width:64
                                height:88
                                text: qsTr("SEATS") + mytrans.emptyString
                                onClicked: function(){
                                console.log("seat clicked");
                                GSystem.state = "Seats";
                                GSystem.changePage("Seats");
                        }
                    }
                    TopButton {
                        id:btnControls
                        bgSource : "qrc:/design/general/Controls.svg"
                        textColor: "white"
                        anchors.verticalCenter: parent.verticalCenter
                        width:117
                        height:88
                        x: 150
                        text: qsTr("CONTROLS") + mytrans.emptyString
                        onClicked: function(){
                                console.log("controls clicked");
                                GSystem.state = "Controls";
                                GSystem.changePage("Controls");
                        }
                    }
                    TopButton {
                            id:btnMedia
                            bgSource : "qrc:/design/general/Media.svg";
                            textColor: "white"
                            anchors.verticalCenter: parent.verticalCenter
                            width: 77
                            height:88
                            x: 307
                            text: qsTr("MEDIA")  + mytrans.emptyString
                            onClicked: function(){
                                    GSystem.state = "Media";
                                    GSystem.changePage("Media");
                            }
                    }
                    TopButton {
                            id:btnLights
                            bgSource : "qrc:/design/general/Lights.svg"
                            textColor: "white"
                            anchors.verticalCenter: parent.verticalCenter
                            width:77
                            height:88
                            x: 428
                            text: qsTr("LIGHTS") + mytrans.emptyString
                            onClicked: function(){
                                console.log("lights clicked");
                                GSystem.state = "Lights";
                                GSystem.changePage("Lights");
                            }
                    }

                }
            }
    Component.onCompleted: {
        topDate.refresh();
        mainmenu.y=0;
    }
}

