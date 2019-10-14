import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import ck.gmachine 1.0
import QtGraphicalEffects 1.0
import closx.restarter 1.0

Item {
    id:root
    property string message: "rstarter"
    signal finished
    width:1024
    height:768
    visible: false

    function come()
    {
        restartfadein.running=true;
        root.visible=true
    }
//    function go()
//    {
//        restartfadeout.running=true;
//    }

    Restarter {
        id:restarter
    }

    Rectangle{
        id:restart
        width: 1024
        height:768
        color:Qt.rgba(0,0,0,0.8)
        z:300
        opacity: 0
        visible: true
        MouseArea{
            anchors.fill: parent
            onClicked: {
                if(restart.opacity==1){
                    restartfadeout.running=true;
                    remover.start();
                }
            }
        }
    }
       Rectangle{
           id:restartbtn
           anchors.centerIn: restart;
           width: 400
           height:240
           color: "#1c1c1c"
           border.width: 3
           border.color:Qt.rgba(0/255, 108/255, 128/255,0.6)
           z:344
           visible: true
           opacity: 0
           MouseArea{
               anchors.fill: parent
           }
           ColumnLayout
           {
               width: 400
               height: 200
               Rectangle{
                   id: restartheader
                   width: 394
                   height: 30
                   anchors.top: parent.top
                   anchors.topMargin: 3
                   anchors.left: parent.left
                   anchors.leftMargin: 3
                   color: "#0f0f0f"
                   Text {
                       anchors.centerIn: parent
                       text: qsTr("Restart the system!") + mytrans.emptyString
                       font.pixelSize: 16
                       font.italic: true
                       color: "white"
                   }
               }

               Rectangle{
                   width:400
                   height: 100
                   anchors.top: restartheader.bottom
                   anchors.topMargin: 20
                   color:"transparent"
                   Text{
                       anchors.centerIn: parent
                       text:qsTr("System should be restarted to\n apply all language changes.") + mytrans.emptyString
                       font.family:GSystem.myriadproita.name
                       font.pixelSize: 22
                       font.italic: true
                       color: "white"
                   }
               }

               Rectangle{
                   width:400
                   height: 100
                   color:"transparent"
                   RowLayout{
                       width: 400
                       height: 100
                       Rectangle{
                           width: 200
                           height: 100
                           color:"transparent"
                           Rectangle{
                               id: restartbg
                               width: 120
                               height: 50
                               color:"#0f0f0f"
                               border.width: 1
                               border.color:Qt.rgba(0/255, 108/255, 128/255,0.6)
                               anchors.verticalCenter: parent.verticalCenter
                               anchors.right: parent.right
                               anchors.rightMargin: 20
                               z:344
                               Text{
                                   anchors.centerIn: parent
                                   text:qsTr("Restart") + mytrans.emptyString
                                   font.family:GSystem.myriadproita.name
                                   font.pixelSize: 18
                                   color: "white"
                               }
                               MouseArea{
                                   anchors.fill: parent
                                   onClicked: {
                                       if(restart.opacity==1){
                                           restarter.makeRestart()
                                       }
                                   }
                                   onPressed: {
                                       if(restart.opacity==1){
                                           restartbg.color = Qt.rgba(0/255, 108/255, 128/255,0.6)
                                       }
                                   }
                                   onReleased: {
                                       if(restart.opacity==1){
                                           restartbg.color = "#0f0f0f"
                                       }
                                   }
                               }
                           }

                       }
                       Rectangle{
                           width: 200
                           height: 100
                           color: "transparent"
                           Rectangle{
                               id: cancelbg
                               width: 120
                               height: 50
                               color:"#0f0f0f"
                               border.width: 1
                               border.color:Qt.rgba(0/255, 108/255, 128/255,0.6)
                               anchors.verticalCenter: parent.verticalCenter
                               anchors.left: parent.left
                               anchors.leftMargin: 20
                               z:344
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
                                       if(restart.opacity==1){
                                           restartfadeout.running=true;
                                           remover.start();
                                       }
                                   }
                                   onPressed: {
                                       if(restart.opacity==1){
                                           cancelbg.color =  Qt.rgba(0/255, 108/255, 128/255,0.6)
                                       }
                                   }
                                   onReleased: {
                                       if(restart.opacity==1){
                                           cancelbg.color =  "#0f0f0f"
                                       }
                                   }
                               }
                           }
                       }

                   }
               }

           }

       }

       NumberAnimation {
           id:restartfadeout
           targets: [restartbtn,restart]
           properties: "opacity"
           from:1
           to:0
           duration:250
           running: false
           loops: 1
       }
       NumberAnimation {
           id:restartfadein
           targets: [restartbtn,restart]
           properties: "opacity"
           from:0
           to:1
           duration:250
           running: false
           loops: 1
       }
       Timer{
           id:remover
           repeat: false
           running: false
           interval: 250
           onTriggered: root.visible=false;
       }
}
