import QtQuick 2.0
import ck.gmachine 1.0
import QtGraphicalEffects 1.0

Item {
    id:root
    property string message: "info"
    property alias src:icon.source
    property point position: Qt.point(0,0)
    signal finished
    x: position.x
    y: position.y
    width:100
    height:100
    visible: false
    function start()
    {
        root.visible = true;
        ani.restart();
    }
    Rectangle{
        id:info
        x:0
        y:0
        width:100
        height:100
        opacity: 0
        radius: 8
        color:Qt.rgba(0, 0, 0,0.4)
        border.width: 3
        border.color:Qt.rgba(0/255, 108/255, 128/255,0.8)

        Column
        {
            anchors.centerIn: parent
            spacing: 10
            Image{
                id:icon
                sourceSize.width: 80
                fillMode: Image.PreserveAspectFit
            }
            Text{
                    font.family: GSystem.myriadproita.name
                    font.italic: true
                    font.pixelSize: 24
                    color: "white"
                    anchors.centerIn: parent
            }
        }

    }
    SequentialAnimation{
        id:ani
        ParallelAnimation{
            PropertyAnimation {
                property: "opacity"
                target: info;
                from: 0;
                to: 1;
                duration: 500
            }
            PropertyAnimation {
                property: "y"
                target: root;
                from: root.position.y;
                to: root.position.y-100;
                duration: 500
            }
        }
        PauseAnimation {
            duration: 300
        }
        ParallelAnimation{
            PropertyAnimation {
                property: "opacity"
                target: info;
                from: 1;
                to: 0;
                duration: 500
            }
        }

    }
}
