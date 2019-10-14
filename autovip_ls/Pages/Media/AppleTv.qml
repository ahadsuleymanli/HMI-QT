import QtQuick 2.4
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import ck.gmachine 1.0
import "../../Components"

BasePage {
    id:root
    caption: qsTr("APPLE TV") + mytrans.emptyString
    pageName: "AppleTv"
    property int delay: 100
    function init()
    {
        serial_mng.sendKey("apple_tv/source");
    }

    Item{
        id: kumanda
        height: parent.height
        width: parent.width
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
//        Image{
//            id:boskumanda
//            source: "qrc:/design/media/appletv-kumanda/kumandatek.png"
//            anchors.fill: parent
//            antialiasing: true
//        }

//        KumandaMedia{
//            x:117
//            y:70
//            scale: 0.4
//        }

//        Image{
//            id:menubutton
//            source: "qrc:/design/media/appletv-kumanda/menubutton.png"
//            x: 210
//            y: 270
//            antialiasing: true
//            MouseArea{
//               onPressed: {
//                   serial_mng.sendKey("apple_tv/menu",true,root.delay)
//               }
//               onReleased: {
//                   serial_mng.sendKey("apple_tv/stop_code");
//               }
//           }

//        }

//        Image{
//            id:altbutton
//            source: "qrc:/design/media/appletv-kumanda/altbutton.png"
//            x: 290
//            y: 270
//            antialiasing: true
//            MouseArea{
//               onPressed: {
//                   serial_mng.sendKey("apple_tv/altbtn",true,root.delay)
//               }
//               onReleased: {
//                   serial_mng.sendKey("apple_tv/stop_code");
//               }
//           }

//        }

//        Image{
//            id:microphone
//            source: "qrc:/design/media/appletv-kumanda/microfonbutton.png"
//            x: 210
//            y: 340
//            antialiasing: true
//            MouseArea{
//               onPressed: {
//                   serial_mng.sendKey("apple_tv/microphone",true,root.delay)
//               }
//               onReleased: {
//                   serial_mng.sendKey("apple_tv/stop_code");
//               }
//           }

//        }

//        Image{
//            id:playstop
//            source: "qrc:/design/media/appletv-kumanda/playbutton.png"
//            x: 210
//            y: 400
//            antialiasing: true
//            MouseArea{
//               onPressed: {
//                   serial_mng.sendKey("apple_tv/play_pause",true,root.delay);
//               }
//               onReleased: {
//                   serial_mng.sendKey("apple_tv/stop_code");
//               }
//           }

//        }

//        Image{
//            id:artir
//            source: "qrc:/design/media/appletv-kumanda/arti.png"
//            x: 290
//            y: 350
//            antialiasing: true
//            width:50
//            height:60
//            //anchors.fill:Image.PreserveAspectFit
//            MouseArea{
//               anchors.fill: artir
//               onPressed:{
//                   serial_mng.sendKey("apple_tv/volume_up",true,root.delay)
//               }
//               onReleased: {
//                   serial_mng.sendKey("apple_tv/stop_code");
//               }
//           }

//        }

//        Image{
//            id:azalt
//            source: "qrc:/design/media/appletv-kumanda/eksi.png"
//            x: 290
//            y: 385
//            antialiasing: true
//            //anchors.fill:Image.PreserveAspectFit
//            width:50
//            height:60
//            MouseArea{
//                anchors.fill: azalt
//                onPressed: {
//                   serial_mng.sendKey("apple_tv/volume_down",true,root.delay);
//               }
//               onReleased: {
//                   serial_mng.sendKey("apple_tv/stop_code");
//               }
//           }

//        }








        GridLayout{
            anchors.horizontalCenter: parent.horizontalCenter
            y:250
            rows:5
            columns:5
            DVDButton{
//                text:qsTr("⌃")
                color: Qt.rgba(0,0,0,0.4)
                Layout.column: 1
                Layout.row: 0
                width: 100
                height: 70
                border.color: "black"
                border.width: 1
                Image {
                    anchors.centerIn: parent
                    width: 60
                    height: 60
                    id: upimage
                    source:"qrc:/design/media/appletv-kumanda/up.png";
                }
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                       serial_mng.sendKey("apple_tv/up",true,root.delay);
                       parent.border.color= GSystem.leftTextMenuItemPressedColor;
                   }
                   onReleased: {
                       serial_mng.sendKey("apple_tv/stop_code");
                       parent.border.color="black";
                   }
               }
            }
            DVDButton{
                color: GSystem.leftTextMenuItemPressedColor
                Layout.column: 4
                Layout.row: 0
                width: 100
                height: 70
                Image {
                    anchors.centerIn: parent
                    width: 60
                    height: 60
                    id: menuimage
                    source:"qrc:/design/media/appletv-kumanda/menu.png";
                }
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                       serial_mng.sendKey("apple_tv/menu",true,root.delay);
                        parent.border.color= GSystem.leftTextMenuItemPressedColor;
                   }
                   onReleased: {
                       serial_mng.sendKey("apple_tv/stop_code");
                       parent.border.color="black";
                   }
               }
            }
            DVDButton{
                color: Qt.rgba(0,0,0,0.4)
                Layout.column: 0
                Layout.row: 1
                width: 100
                height: 70
                Image {
                    anchors.centerIn: parent
                    width: 60
                    height: 60
                    id: leftimage
                    source:"qrc:/design/media/appletv-kumanda/left.png";
                }
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                       serial_mng.sendKey("apple_tv/left",true,root.delay);
                        parent.border.color= GSystem.leftTextMenuItemPressedColor;
                   }
                   onReleased: {
                       serial_mng.sendKey("apple_tv/stop_code");
                       parent.border.color="black";
                   }
               }
            }
            DVDButton{
                color: GSystem.leftTextMenuItemPressedColor
                Layout.column: 1
                Layout.row: 1
                width: 100
                height: 70
                Image {
                    anchors.centerIn: parent
                    width: 45
                    height: 45
                    id: clickimage
                    source:"qrc:/design/media/appletv-kumanda/click.png";
                }
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                       serial_mng.sendKey("apple_tv/click",true,root.delay);
                        parent.border.color= GSystem.leftTextMenuItemPressedColor;
                   }
                   onReleased: {
                       serial_mng.sendKey("apple_tv/stop_code");
                       parent.border.color="black";
                   }
               }
            }
            DVDButton{
                color: Qt.rgba(0,0,0,0.4)
                Layout.column: 2
                Layout.row: 1
                width: 100
                height: 70
                Image {
                    anchors.centerIn: parent
                    width: 60
                    height: 60
                    id: rightimage
                    source:"qrc:/design/media/appletv-kumanda/right.png";
                }
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                       serial_mng.sendKey("apple_tv/right",true,root.delay);
                        parent.border.color= GSystem.leftTextMenuItemPressedColor;
                   }
                   onReleased: {
                       serial_mng.sendKey("apple_tv/stop_code");
                       parent.border.color="black";
                   }
               }
            }
            DVDButton{
                color: GSystem.leftTextMenuItemPressedColor
                Layout.column: 4
                Layout.row: 1
                width: 100
                height: 70
                Image {
                    anchors.centerIn: parent
                    width: 60
                    height: 60
                    id: altimage
                    source:"qrc:/design/media/appletv-kumanda/alt.png";
                }
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                       serial_mng.sendKey("apple_tv/altbtn",true,root.delay);
                        parent.border.color= GSystem.leftTextMenuItemPressedColor;
                   }
                   onReleased: {
                       serial_mng.sendKey("apple_tv/stop_code");
                       parent.border.color="black";
                   }
               }
            }
            DVDButton{
                color: Qt.rgba(0,0,0,0.4)
                Layout.column: 1
                Layout.row: 2
                width: 100
                height: 70
                Image {
                    anchors.centerIn: parent
                    width: 60
                    height: 60
                    id: downimage
                    source:"qrc:/design/media/appletv-kumanda/down.png";
                }
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                       serial_mng.sendKey("apple_tv/down",true,root.delay);
                        parent.border.color= GSystem.leftTextMenuItemPressedColor;
                   }
                   onReleased: {
                       serial_mng.sendKey("apple_tv/stop_code");
                       parent.border.color="black";
                   }
               }
            }
            DVDButton{
                color: GSystem.leftTextMenuItemPressedColor
                Layout.column: 4
                Layout.row: 2
                width: 100
                height: 70
                Image {
                    anchors.centerIn: parent
                    width: 60
                    height: 60
                    id: playpauseimage
                    source:"qrc:/design/media/appletv-kumanda/playpause.png";
                }
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                       serial_mng.sendKey("apple_tv/play_pause",true,root.delay);
                        parent.border.color= GSystem.leftTextMenuItemPressedColor;
                   }
                   onReleased: {
                       serial_mng.sendKey("apple_tv/stop_code");
                       parent.border.color="black";
                   }
               }
            }
            DVDButton{
                color: Qt.rgba(0,0,0,0.4)
                Layout.column: 3
                Layout.row: 4
                width: 100
                height: 70
                Image {
                    anchors.centerIn: parent
                    width: 60
                    height: 60
                    id: plusimage
                    source:"qrc:/design/media/appletv-kumanda/plus.png";
                }
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                       serial_mng.sendKey("apple_tv/volume_up",true,root.delay);
                        parent.border.color= GSystem.leftTextMenuItemPressedColor;
                   }
                   onReleased: {
                       serial_mng.sendKey("apple_tv/stop_code");
                       parent.border.color="black";
                   }
               }
            }
            DVDButton{
                color: Qt.rgba(0,0,0,0.4)
                Layout.column: 4
                Layout.row: 4
                width: 100
                height: 70
                Image {
                    anchors.centerIn: parent
                    width: 60
                    height: 60
                    id: minusimage
                    source:"qrc:/design/media/appletv-kumanda/minus.png";
                }
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                       serial_mng.sendKey("apple_tv/volume_down",true,root.delay);
                        parent.border.color= GSystem.leftTextMenuItemPressedColor;
                   }
                   onReleased: {
                       serial_mng.sendKey("apple_tv/stop_code");
                       parent.border.color="black";
                   }
               }
            }
        }











    }
    Component.onCompleted: {
        root.delay = serial_mng.getAppltvDelay();
    }
}


