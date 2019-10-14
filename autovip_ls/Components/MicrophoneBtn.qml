import QtQuick 2.0
import QtQuick.Layouts 1.1
import ck.gmachine 1.0
import QtGraphicalEffects 1.0

Item {
    id:root
    height: btnImage.height
    width: btnImage.width
    property int service: -1
    onServiceChanged: function(){
        switch(root.service)
        {
        case -1:
            root.state="noconnect";
            break;
        case 0:
            root.state="busy";
            break;
        case 1:
            root.state="ready";
            break;
        }
    }
    states:[
        State{
            name:"busy"
            PropertyChanges {
                target: co
                visible:true
            }
            PropertyChanges {
                target: cross
                visible:false

            }
        },
        State{
            name:"ready"
            PropertyChanges {
                target: btnImage
            }
            PropertyChanges {
                target: co
                visible:false
            }
            PropertyChanges {
                target: cross
                visible:false

            }
        },
        State{
            name:"noconnect"
            PropertyChanges {
                target: cross
                visible:true

            }
        }]

    Image{
            id: btnImage
            fillMode: Image.PreserveAspectFit
            antialiasing: true
            smooth: true
            height:100
            source:"qrc:/design/general/Microphone.svg"
            Image{
                id:cross
                anchors.verticalCenter: parent.verticalCenter
                source:"qrc:/design/general/close.svg"
                width:parent.width
                visible: true
                fillMode: Image.PreserveAspectFit
                antialiasing: true

            }
            MouseArea{
                anchors.fill: parent
                onClicked: function(){
                    GSystem.voice_service.openMic();
                }
            }
    }
         ColorOverlay {
                        id:co
                        visible: false
                        anchors.fill: btnImage
                        source: btnImage
                        color: Qt.rgba(191/255, 63/255, 191/255,0.6)
         }

         Connections{
             target:GSystem.voice_service
             onBusyChanged:function(st){
                 root.service = st;
             }
         }

}
