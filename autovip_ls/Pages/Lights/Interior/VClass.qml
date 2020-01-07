import QtQuick 2.0
import QtQuick.Layouts 1.3
import "../../../Components"
import ColorComponents 1.0
import QtGraphicalEffects 1.0
import ck.gmachine 1.0

Item{
    id:root
    x:366
    y:200
    width:620
    height:500
    clip: true
    Rectangle{
        id:ceil
        x:175
        y:30
        width: 250
        height: 250
        border.width: 0
        color:ceilColor
    }
    Image{
        id:imagem
        width: 622
        height: 362
        anchors.verticalCenterOffset: -69
        anchors.topMargin: 0
        anchors.verticalCenter: root.verticalCenter
        anchors.top: root.top
        anchors.right: root.right
        anchors.left: root.left
        smooth: true
        enabled: true
        z: 1
        scale: 1
        transformOrigin: Item.Center
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        source:"qrc:/design/lights/icon-tavan.png"
        antialiasing: false
    }

    Rectangle{
        x:132
        y:271
        width:350
        height:91
        rotation: 0
        color:inSideColor
        }
    Rectangle{
        x:565
        y:187
        width:55
        height:175
        rotation: 0
        color:inSideColor
        }
    Rectangle{
        x:0
        y:187
        width:44
        height:175
        rotation: 0
        color:inSideColor
        }
     Rectangle{
         x:50
         y:259
         width:45
         height:82
         color:sideColor
         rotation: 0
         visible: SM.sidelight()
     }
     Rectangle{
         x:517
         y:266
         width:48
         height:75
         color:sideColor
         visible: SM.sidelight()
     }
//     Rectangle{
//         id:ambientColorRectangle
//         x:550
//         y:300
//         width:48
//         height:75
//         color:ambientColor
//         visible: SM.ambientlight()
//     }
     Rectangle{
         id:rightReadingLightRectangle
         x:66
         y:153
         width:96
         height:50
         color:rightReadingLight
     }
     Rectangle{
         id:leftReadingLightRectangle
         x:450
         y:160
         width:76
         height:43
         color:leftReadingLight
     }
     Glow{
         source:rightReadingLightRectangle
         anchors.fill: rightReadingLightRectangle
         color:rightReadingLightRectangle.color
         radius: 5
         anchors.rightMargin: 13
         anchors.bottomMargin: 27
         anchors.leftMargin: 17
         anchors.topMargin: 20
         z: 5
     }
     Glow{
         source:leftReadingLightRectangle
         anchors.fill: leftReadingLightRectangle
         color:leftReadingLightRectangle.color
         radius: 5
         anchors.rightMargin: 0
         anchors.bottomMargin: 27
         anchors.leftMargin: 9
         anchors.topMargin: 13
         z: 5
     }
    }
