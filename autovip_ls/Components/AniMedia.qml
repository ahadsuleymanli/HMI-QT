import QtQuick 2.0
        Item{
            id:root
            property real cscale: 0.4
            width : 512 * cscale *2
            height: 512 * cscale *2
            Image{
            anchors.centerIn: parent
            source:"qrc:/design/media/ani/circle.svg"
            smooth: true
            antialiasing: true
            sourceSize.width : 512.228 * root.cscale *2
            sourceSize.height : 512.228 * root.cscale *2
            width: sourceSize.width
            height: sourceSize.height
//            Image{
//                x:80.92 * root.cscale
//                y:90.92 * root.cscale
//                source:"qrc:/design/media/ani/shadow.svg"
//                sourceSize.width : 429 * root.cscale
//                sourceSize.height : 418 * root.cscale
//            }

            Image{
                x:113.298 * root.cscale *2
                y:192.14 * root.cscale *2
                sourceSize.width : 295 * root.cscale *2
                sourceSize.height : 208 * root.cscale *2
                source:"qrc:/design/media/ani/camera.svg"
            }

            Image{
                id:cw1
                x: 55 *2
                y: 38 *2
                width: 58 *2
                height: 58 *2
                sourceSize.width : 154 * root.cscale *2
                sourceSize.height : 154 * root.cscale *2
                source:"qrc:/design/media/ani/cark.svg"
                smooth: true
            }
            Image{
                id:cw2
                x: 115 *2
                y: 50 *2
                width: 50 *2
                height: 50 *2
                sourceSize.width : 154 * root.cscale *2
                sourceSize.height : 154 * root.cscale *2
                smooth: true
                source:"qrc:/design/media/ani/cark.svg"
            }
            NumberAnimation {
                targets: [cw1,cw2]
                properties: "rotation"
                from:0
                to:360
                duration:5000
                running: true
                loops: Animation.Infinite
            }

//            AnimatedImage{
//                source: "qrc:/design/media/ani/play.gif"
//                width: 1200 * root.cscale
//                height: 800 * root.cscale
//                anchors.centerIn: parent
//                cache: false
//            }
        }
        }
