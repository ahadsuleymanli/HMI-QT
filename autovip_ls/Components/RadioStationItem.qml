import QtQuick 2.0
import QtGraphicalEffects 1.0
import ck.gmachine 1.0


/*
Image {
    width:320
    height: 300
    source:"qrc:/design/radio/fbg.svg"
}
*/

Item{
    anchors.top:parent.top
    width:320
    height: 300
    property alias fmtext: fmname.text
    property alias fmval: fmvalue.text
    property bool isCurrent:false
    Rectangle{
        anchors.horizontalCenter: parent.horizontalCenter
        id: fbg
        width:254
        height:254
        border.width: 2.5
        border.color:Qt.rgba(0/255, 108/255, 128/255,0.6)
        clip:true
        color: GSystem.leftTextMenuItemColor
//        gradient: Gradient {
//            GradientStop { position: 0.0; color: "#999999" }
//            GradientStop { position: 0.5; color: "#4a4849" }
//            GradientStop { position: 1.0; color: "#231f20" }
//        }
        Image{
            y:30
            width:50
            height:62
            anchors.horizontalCenter: parent.horizontalCenter
            source:"qrc:/design/radio/cfrequency.svg"
            visible:(isCurrent)?true:false
        }
        Text{
            id:fmname
            width:parent.width
            horizontalAlignment: Text.AlignHCenter
            anchors.centerIn: parent
            font.family:GSystem.centurygothic.name
            font.pixelSize: 27
            color: "white"
        }
        Text{
            id:fmvalue
            anchors.top: fmname.bottom
            anchors.topMargin: 30
            width:parent.width
            horizontalAlignment: Text.AlignHCenter
            font.family: "Century Gothic"
            font.pixelSize: 27
            color: "white"
        }
        //        Image{
        //            x:0
        //            y:0
        //            width:parent.width
        //            height:parent.height
        //            source:"qrc:/design/radio/insidel.png"
        //        }
    }
   Item {
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: fbg.bottom
    anchors.topMargin: 10
    width: fbg.width
    height: 13

    RadialGradient {
       anchors.fill: parent
        horizontalRadius:parent.width/2
        verticalRadius: parent.height/2
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#FF000000"}
            GradientStop { position: 1.0; color: "#00333333" }
        }
    }
    }
}
