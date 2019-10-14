import QtQuick 2.11
import QtQuick.Window 2.10
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4
import ck.gmachine 1.0
import "Components"
import QtMultimedia 5.6
import MyLang 1.0
import QtQuick.Controls.Material 2.2
import closx.updater 1.0
import closx.smanager 1.0




Window {
    id: root
    visible:true
    width: 1024
    height: 768
    title: qsTr("autovip") + mytrans.emptyString
    modality: Qt.ApplicationModal
    flags: Qt.Window | Qt.FramelessWindowHint
    Material.theme: Material.Dark
    Material.accent: Material.Purple
    color: "black"
    Intro{
        x:0
        y:0
        z:1334
        width:1024
        height:768
        opacity: 1
    }
    Connections{
       target: nvidia_conn_manager
       onChangeQmlPage: function(page){
           GSystem.state = page;
           GSystem.changePage(page,false);
       }
    }
    Connections {
        target: update_manager
        onDoUpdateOverlay: function(){
            updateOverlayTimer.running = startBtn.visible;
        }
    }

    Timer{
        id:updateOverlayTimer
        running: false
        repeat: true
        interval: 100
        onTriggered: {
            if(startBtn.visible==false){
                if(update_manager.checkUnzipped()){
                    updaterbtn.visible=true;
                    updater.visible=true;
                    updateOverlayTimer.running=false;
                }else{
                    updateOverlayTimer.running=false;
                    SM.setLastVersion(SM.version);
                }
            }
        }
    }

//    AnimatedImage {
//        x:0
//        y:0
//        source: "qrc:/design/general/background.gif"
//        width:parent.width
//        height:parent.height
//        Body{
//            id: bodyPart
//            x:0
//            y:0
//        }
//        BottomMenu
//        {
//            id: iBottomMenu
//            x:0
//            y:690
//        }
//    }

    Rectangle{
        x:0
        y:0
        width:parent.width
        height:parent.height
//        AnimatedImage {
//            x:0
//            y:0
//            source: "qrc:/design/general/background.gif"
//            speed: 1
//            width:parent.width
//            height:parent.height
////            cache: false
//        }

        Image{
            x:0
            y:0
            width:parent.width
            height:parent.height
            source: "qrc:/design/general/background.png"
        }

//        MediaPlayer {
//            id:player
//            source: "file:///"+workingDirPath+"/background.mp4"
////            onStopped: play()
//            autoPlay: true
//            loops: Animation.Infinite
//            }

//        VideoOutput {
////            anchors.fill: parent
//            x:0
//            y:0
//            width:1230
//            height:920
//            source: player
//        }
//        Component.onCompleted: {
//                player.play();
//        }
        Image {
                x:0
                y:0
                source: "qrc:/design/general/backgroundoverlay.png"
                width:parent.width
                height:parent.height
        }

        Body{
            id: bodyPart
            x:0
            y:0
        }
        BottomMenu
        {
            id: iBottomMenu
            x:0
            y:690
        }
    }
    CommandInfo{
        id:info
        z:332
        width:root.width
        height:root.height
    }
    RestartOverlay{
        id:rstarter
        z:332
        width: root.width
        height: root.height
    }
    InfoOverlay{
        id:infoverlay
        z:332
        width: root.width
        height: root.height
    }

    Item{
       id:start
       width:root.width
       height:root.height
       opacity: 0.7
       Rectangle{
           x:0
           y:0
           width:1024
           height:768
           color:"black"
           z:333
           MouseArea{
              anchors.fill: parent
           }
       }
    }



    //////////////////////////////////// INFO OVERLAY'ININ BAŞLADIĞI YER





    //////////////////////////////////// INFO OVERLAY'ININ BİTTİĞİ YER








       Rectangle{
           id:startBtn
           anchors.centerIn: start;
           border.width: 2
           border.color:Qt.rgba(0/255, 108/255, 128/255,0.6)
           width: 300
           height: 300
           color: Qt.rgba(0,0,0,0.8)
           z:334
           property int systemstate: serial_mng.systemstate
           onSystemstateChanged: {
               switch(systemstate)
               {
               case -1:
               case 0:
                        start.visible=true;
                        startBtn.visible=true;
                        GSystem.syscheck.repeat=true;
                   break;
               case 1:
                        start.visible=false;
                        startBtn.visible=false;
                        GSystem.syscheck.repeat=true;
                   break;
               }
           }
           Image{
               anchors.centerIn: parent
               source:"qrc:/design/general/on-button.svg"
               sourceSize.width: 200
               sourceSize.height: 200
               z:334
               MouseArea{
                   anchors.fill: parent
                   onClicked: {
                       GSystem.systemOnOff();
                   }
               }
           }
           MouseArea{
               anchors.fill: parent
           }

       }
       MouseArea {
           anchors.fill: parent
           enabled: false
       }



       ///////////////////////////// UPDATER OVERLAY BAŞLANGICI

       Updater{
           id:updateMe
       }


       Rectangle{
           id:updater
           width: 1024
           height:768
           color:"black"
           z:330
           opacity: 0.8
           visible: false
           MouseArea{
               anchors.fill: parent
               onClicked: {
                   updater.visible=false;
                   updaterbtn.visible=false;
               }
           }
       }

       Rectangle{
           id:updaterbtn
           anchors.centerIn: updater;
           width: 450
           height:240
           color: "#1c1c1c"
           border.width: 3
           border.color:Qt.rgba(0/255, 108/255, 128/255,0.6)
           z:330
           opacity: 1
           visible: false
           MouseArea{
               anchors.fill: parent
               onClicked: {
                   updater.visible=true;
                   updaterbtn.visible=true;
               }
           }
           ColumnLayout
              {
                  id:updaterlayout
                  width: updaterbtn.width
//                  height: 200
                  Rectangle{
                      id: updaterheader
                      width: updaterbtn.width - 6
                      height: 30
                      anchors.top: parent.top
                      anchors.topMargin: 3
                      anchors.left: parent.left
                      anchors.leftMargin: 3
                      color: "#0f0f0f"
                      Text {
                          id: updaterheadertext
                          anchors.centerIn: parent
                          text: qsTr("New Update Found!") + mytrans.emptyString
                          font.pixelSize: 16
                          font.italic: true
                          color: "white"
                      }
                  }

                  Rectangle{
                      id:updatertextrect
                      width:updaterbtn.width - 100
                      height: updaterbtn.height - 140
                      anchors.top: updaterheader.bottom
                      anchors.topMargin: 20
                      anchors.horizontalCenter: parent.horizontalCenter
                      color:"transparent"
                      Item {
                          anchors.fill: parent
                          Text {
                              id:updatertext
                              anchors {
                                  left: parent.left
                                  right: parent.right
                                  verticalCenter: parent.verticalCenter
                              }
                              text: qsTr("There is a new update of the system software. Do you want to install it? (System will be restarted.)") + mytrans.emptyString
                              font.family: GSystem.myriadproita.name
                              font.pixelSize: 22
                              font.italic: true
                              color: "white"
                              wrapMode: Text.Wrap
                              horizontalAlignment: Text.AlignHCenter
                          }
                      }
                  }

                  Rectangle{
                      id:updaterbuttonlayout
                      anchors.horizontalCenter: parent.horizontalCenter
                      width:updaterbtn.width
                      height: 100
                      y:100
                      color:"transparent"
                      RowLayout{
                          anchors.fill:parent
                          spacing: 0
                          Rectangle{
                              width: 150
                              height: 100
                              color:"transparent"
                              Rectangle{
                                  id: updaterbg
                                  width: 120
                                  height: 50
                                  color:"#0f0f0f"
                                  border.width: 1
                                  border.color:Qt.rgba(0/255, 108/255, 128/255,0.6)
//                                  anchors.verticalCenter: parent.verticalCenter
//                                  anchors.right: parent.right
//                                  anchors.rightMargin: 30
                                  anchors.centerIn: parent
                                  anchors.horizontalCenterOffset: 15
                                  Text{
                                      anchors.centerIn: parent
                                      text:qsTr("Update") + mytrans.emptyString
                                      font.family:GSystem.myriadproita.name
                                      font.pixelSize: 18
                                      color: "white"
                                  }
                                  MouseArea{
                                      anchors.fill: parent
                                      onClicked: {
                                          updateMe.makeUpdate()
                                      }
                                      onPressed: {
                                          updaterbg.color = Qt.rgba(0/255, 108/255, 128/255,0.6)
                                      }
                                      onReleased: {
                                          updaterbg.color = "#0f0f0f"
                                      }
                                  }
                              }

                          }
                          Rectangle{
                              id:centerbuttonbg
                              width: 150
                              height: 100
                              color: "transparent"
                              Rectangle{
                                  id: changelogbg
                                  width: 120
                                  height: 50
                                  color:"#0f0f0f"
                                  border.width: 1
                                  border.color:Qt.rgba(0/255, 108/255, 128/255,0.6)
                                  anchors.verticalCenter: parent.verticalCenter
                                  anchors.centerIn: parent
                                  Text{
                                      anchors.centerIn: parent
                                      text:qsTr("Change Log") + mytrans.emptyString
                                      font.family:GSystem.myriadproita.name
                                      font.pixelSize: 18
                                      color: "white"
                                  }
                                  MouseArea{
                                      anchors.fill: parent
                                      property var mywidth: 550
                                      property var myheight: 400
                                      onClicked: {
                                          updaterheadertext.text = qsTr("Change Log of the New Update") + mytrans.emptyString
                                          console.log(update_manager.dirPath()+"/changelog");
                                          updatertext.text = update_manager.changeLog();
                                          console.log(update_manager.changeLog());
                                          updatertext.anchors.verticalCenterOffset = (myheight - updaterbtn.height)/4
                                          updaterbg.visible=false
                                          cancelbg.visible=false
                                          centerbuttonbg.visible=false
                                          changelogcancelbg.visible=true
                                          updaterbtn.width = mywidth
                                          updaterbtn.height = myheight
                                          updaterlayout.width = mywidth
                                          updaterheader.width = mywidth-6
                                          updatertextrect.width = mywidth-100
                                          updatertextrect.height = myheight/2
                                          updaterbuttonlayout.width = mywidth
                                          updaterbuttonlayout.height = 100
                                          updaterbuttonlayout.y = 300 + myheight - updaterbtn.height
                                          updaterbuttonlayout.anchors.horizontalCenterOffset = 20
                                      }
                                      onPressed: {
                                          changelogbg.color =  Qt.rgba(0/255, 108/255, 128/255,0.6)
                                      }
                                      onReleased: {
                                          changelogbg.color =  "#0f0f0f"
                                      }
                                  }
                              }
                          }
                          Rectangle{
                              id: changelogcancelbg
                              width: 150
                              height: 100
                              color: "transparent"
                              visible: false
                              Rectangle{
                                  id: changelogcancelbutton
                                  width: 120
                                  height: 50
                                  color:"#0f0f0f"
                                  border.width: 1
                                  border.color:Qt.rgba(0/255, 108/255, 128/255,0.6)
                                  anchors.verticalCenter: parent.verticalCenter
                                  anchors.centerIn: parent
                                  Text{
                                      anchors.centerIn: parent
                                      text:qsTr("OK") + mytrans.emptyString
                                      font.family:GSystem.myriadproita.name
                                      font.pixelSize: 18
                                      color: "white"
                                  }
                                  MouseArea{
                                      anchors.fill: parent
                                      property var mywidth: 450
                                      property var myheight: 240
                                      onClicked: {
                                          updaterheadertext.text = qsTr("New Update Found!") + mytrans.emptyString
                                          updatertext.text = qsTr("There is a new update of the system software. Do you want to install it? (System will be restarted.)") + mytrans.emptyString
                                          updatertext.anchors.verticalCenterOffset = 0
                                          updaterbg.visible=true
                                          cancelbg.visible=true
                                          centerbuttonbg.visible=true
                                          changelogcancelbg.visible=false
                                          updaterbtn.width = mywidth
                                          updaterbtn.height = myheight
                                          updaterlayout.width = mywidth
                                          updaterheader.width = mywidth-6
                                          updatertextrect.width = mywidth-100
                                          updatertextrect.height = myheight/2
                                          updaterbuttonlayout.width = mywidth
                                          updaterbuttonlayout.height = 100
                                          updaterbuttonlayout.y = 140
                                          updaterbuttonlayout.anchors.horizontalCenterOffset = 0
                                      }
                                      onPressed: {
                                          changelogcancelbutton.color =  Qt.rgba(0/255, 108/255, 128/255,0.6)
                                      }
                                      onReleased: {
                                          changelogcancelbutton.color =  "#0f0f0f"
                                      }
                                  }
                              }
                          }


                          Rectangle{
                              width: 150
                              height: 100
                              color: "transparent"
                              Rectangle{
                                  id: cancelbg
                                  width: 120
                                  height: 50
                                  color:"#0f0f0f"
                                  border.width: 1
                                  border.color:Qt.rgba(0/255, 108/255, 128/255,0.6)
//                                  anchors.verticalCenter: parent.verticalCenter
//                                  anchors.left: parent.left
//                                  anchors.leftMargin: 30
                                  anchors.centerIn: parent
                                  anchors.horizontalCenterOffset: -15
                                  Text{
                                      anchors.centerIn: parent
                                      text:qsTr("Cancel") + mytrans.emptyString
                                      font.family:GSystem.myriadproita.name
                                      font.pixelSize: 18
                                      color: "white"
                                  }
                                  MouseArea{
                                      anchors.fill: parent
                                      onClicked: {
                                          updater.visible=false;
                                          updaterbtn.visible=false;
                                      }
                                      onPressed: {
                                          cancelbg.color =  Qt.rgba(0/255, 108/255, 128/255,0.6)
                                      }
                                      onReleased: {
                                          cancelbg.color =  "#0f0f0f"
                                      }
                                  }
                              }
                          }

                      }
                  }

              }

          }

         ///////////////////////////// UPDATER OVERLAY BİTİŞİ


    Component.onCompleted: {
        GSystem.phistory = ["Home"];
        GSystem.state = "Home"
        GSystem.setInfo(info);
        GSystem.setRestarter(rstarter);
        GSystem.setInfoverlay(infoverlay);
        console.log(SM.value("main/lang"));
        console.log("Serial Con : "+serial_mng.isConnected());

    }
}
