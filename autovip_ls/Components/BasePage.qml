import QtQuick 2.0
import ck.gmachine 1.0

Rectangle {
    id: root
    width: 1024
    height: 768
    x:-1024
    property alias caption: caption.text
    property string pageName: "default"
    property int contentTopMargin: 132
    property int contentBottomMargin: 72
    clip:true
    color: "transparent"
    visible: false
    Item{
        id: topMenu
        anchors.fill: root
        x:root.x
        y:root.y
        parent: bgOverlay
        Rectangle{
            id:rcaption
            width:238
            height:60
            color:"transparent"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 67
            visible: root.visible && ( root.pageName !== "Home"  )
            Text{
                id:caption
                text:""
                z:32
                font.pixelSize: 36
                font.family: GSystem.centurygothic.name
                color:"white"
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top

            }
            Image{
                visible: (caption.text!="")?true:false
                anchors.bottom: parent.bottom
                source: "qrc:/design/general/captionline.svg"
                z:31
            }
        }

       Image{
           id: return_btn
           visible: root.visible && ( root.pageName !== "Home"  )
           source: "qrc:/design/general/Return.svg"
           anchors.right: parent.right
           anchors.rightMargin: width + 1
           y:30
           z:32
           MouseArea{
               x:-16
               y:-16
               width: parent.width + 32
               height:parent.height + 32
               cursorShape: Qt.PointingHandCursor
               onPressed: {
                       GSystem.goBack();
               }
           }
       }

       Image{
           id: home_btn
           visible: root.visible && ( root.pageName !== "Home"  )
           source: "qrc:/design/general/homeBtn.svg"
           anchors.right: return_btn.left
           anchors.rightMargin: width + 5
           y:35
           z:332
           MouseArea{
               x:-16
               y:-16
               width: parent.width + 32
               height:parent.height + 32
               cursorShape: Qt.PointingHandCursor
               onPressed: {
                       console.log("return button is pressed");
                       GSystem.state = "Home";
                       GSystem.changePage("Home");
               }
           }
       }
   }
}
