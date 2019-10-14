import QtQuick 2.0
import "../Components"
import QtQuick.Particles 2.0

BasePage {
    id: root
    pageName: "Home"
    TopMenu {
            id: iTopMenu
            x:0
            y:0
            clip: true
            Component.onCompleted:
            {
                iTopMenu.x = 0;
            }
        }
    Image{
        id:car
        source: "qrc:/design/home/car.png"
        anchors.centerIn: parent
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenterOffset: 35
    }
    /*
    ParticleSystem {
        id: particleSystem
    }

    Emitter {
        id: emitter
        anchors.left: parent.left
        anchors.leftMargin: -100
        anchors.bottom:  parent.bottom
        anchors.bottomMargin: 400
        system: particleSystem
        emitRate: 10
        lifeSpan: 6400
        lifeSpanVariation: 500
        size: 32
        velocity: AngleDirection {
            angle: -15
            angleVariation: 25
            magnitude: 100
            magnitudeVariation: 25
        }
    }
    Emitter {
        id: emitter2
        anchors.right: parent.right
        anchors.rightMargin : -100
        anchors.bottom:  parent.bottom
        anchors.bottomMargin: 400
        system: particleSystem
        emitRate: 30
        lifeSpan: 6400
        lifeSpanVariation: 500
        size: 32
        velocity: AngleDirection {
            angle: 165
            angleVariation: 25
            magnitude: 100
            magnitudeVariation: 25
        }
    }

    Gravity {
        anchors.left: car.left
        anchors.top: car.top
        width: 240; height: 240
        system: particleSystem
        magnitude: 50
        angle: 90
    }
    Gravity {
        anchors.right:car.horizontalCenter
        anchors.top: car.top
        width: 240;
        height: 240
        system: particleSystem
        magnitude: 50
        angle: 90
    }

    ImageParticle {
        source: "qrc:/design/general/particle.png"
        system: particleSystem
        color: 'white'
        colorVariation: 0.2
    }
    */
}
