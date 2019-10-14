import QtQuick 2.0
import ck.gmachine 1.0

Rectangle {
    id: root
    width: 1024
    height: 768
    x:-1024
    property bool showing: false
    property bool hiding: false
    property alias caption: caption.text
    property string pageName: "default"
    clip:true
    color: "transparent"

    Rectangle{
        id:rcaption
        width:238
        height:60
        color:"transparent"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 67
        Text{
            id:caption
            text:""
            z:2
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
            z:1
        }
    }

   Image{
       id: return_btn
       visible: (root.pageName === "Home")?false:true;
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
       visible: ( root.pageName === "Home"  ) ?false:true;
       source: "qrc:/design/general/homeBtn.svg"
       anchors.right: return_btn.left
       anchors.rightMargin: width + 5
       y:35
       z:32
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

   NumberAnimation on x {
        from: root.width
        to:  0
        duration: 300
        running: root.showing
    }
   NumberAnimation on x {
        from: 0
        to: -root.width
        duration: 300
        running: root.hiding
    }
}
