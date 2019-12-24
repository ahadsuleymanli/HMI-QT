import QtQuick 2.0
import QtQuick.Layouts 1.3

Item {
    id:root
    property real cscale:1
    width: 300 * cscale
    height: 300 * cscale
    property bool running: true
//    Image{
//        source:"qrc:/design/controls/ani/circle.svg"
//        sourceSize.width: 200 * root.cscale
//        sourceSize.height: 200 * root.cscale
//        Image{
//            source:"qrc:/design/controls/ani/shadow.svg"
//            sourceSize.width: 200 * root.cscale
//            sourceSize.height: 200 * root.cscale
//        }
    RowLayout{
        anchors.fill: parent
        Image{
            id:cw2
            sourceSize.width:  root.width * 0.4
            sourceSize.height: root.height * 0.4
            source:"qrc:/design/controls/ani/orta.png"
        }
        ColumnLayout{
            Image{
                id:cw1
                sourceSize.width: root.width * 0.6
                sourceSize.height: root.height * 0.6
                source:"qrc:/design/controls/ani/buyuk.png"
                fillMode: Image.PreserveAspectFit
            }
            Image{
                id:cw3
                sourceSize.width:  root.width * 0.3
                sourceSize.height: root.height * 0.3
                source:"qrc:/design/controls/ani/kucuk.png"
            }
        }
    }


//    }
    Component.onCompleted: {
        console.log("cog anim sizes: "+cw1.sourceSize.width + " " +cw2.sourceSize.width + " " +cw3.sourceSize.width)
    }
    NumberAnimation {
        targets: [cw1,cw2,cw3]
        properties: "rotation"
        from:0
        to:360
        duration:5000
        running: root.running
        loops: Animation.Infinite
    }

//    AnimatedImage{
//        source: "qrc:/design/controls/ani/gears.gif"
//        width: 400 * root.cscale
//        height: 400 * root.cscale
//        anchors.centerIn: parent
//        cache: false
//    }
}
