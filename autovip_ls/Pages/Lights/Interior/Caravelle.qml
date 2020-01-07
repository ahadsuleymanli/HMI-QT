import QtQuick 2.0
import QtQuick.Layouts 1.3
import "../../../Components"
import ColorComponents 1.0
import QtGraphicalEffects 1.0
import ck.gmachine 1.0

Item{
    id:root
    x:356
    y:200
    width:630
    height:500
    clip: true
    Item{
        width: 630
        height: 362
        anchors.top: root.top
        anchors.right: root.right
        anchors.left: root.left
        Image{
            anchors.fill: parent
            source:"qrc:/design/lights/caravelle_bg.png"
        }
        //            hsvHue, hsvSaturation, hsvValue and hslHue, hslSaturation, hslLightness
        //            color.r, color.g, color.b, color.a
        //            Qt.hsla(c.hslHue, 0.0, c.hslLightness, c.a);
        Image {
            id: ceilingLightImage
            anchors.fill: parent
            source: "qrc:/design/lights/caravelle_starlight.png"
            opacity: ceilColor.hsvValue
            Colorize {
                anchors.fill: parent
                source: parent
                hue: ceilColor.hslHue
                saturation: ceilColor.hslSaturation
            }
        }
        Image {
            id: insideLightImage
            anchors.fill: parent
            source: "qrc:/design/lights/caravelle_insidelight.png"
            opacity: inSideColor.hsvValue
            Colorize {
                anchors.fill: parent
                source: parent
                hue: inSideColor.hslHue
                saturation: inSideColor.hslSaturation
            }
        }
        Image {
            id: sideLightImage
            anchors.fill: parent
            source: "qrc:/design/lights/caravelle_sidelight.png"
            opacity: sideColor.hsvValue
            Colorize {
                anchors.fill: parent
                source: parent
                hue: sideColor.hslHue
                saturation: sideColor.hslSaturation
            }
        }
        Image {
            id: ambientLightImage
            anchors.fill: parent
            source: "qrc:/design/lights/caravelle_ambientlight.png"
            opacity: ambientColor.hsvValue
            Colorize {
                anchors.fill: parent
                source: parent
                hue: ambientColor.hslHue
                saturation: ambientColor.hslSaturation
            }
        }
    }

}
