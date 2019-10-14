import QtQuick 2.0
import QtGraphicalEffects 1.0
import ck.gmachine 1.0

Rectangle {
    id: root
    color: "transparent"
    property alias text: txt.text
    property string modeName: "default"
    property bool selected:false
    signal modSelected( string sel)
    width:161
    height:55
    Text{
        id:txt
        text:""
        font.pixelSize: 28
        color: "white"
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

       MouseArea{
            anchors.fill: root
            cursorShape: Qt.PointingHandCursor
            onClicked: modSelected(root.modeName)
       }


   Item {
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: txt.bottom
    anchors.topMargin: 2
    width: 161
    height: 6

    RadialGradient {
        id:grad
        opacity: 0
        anchors.fill: parent
        horizontalRadius:parent.width/3
        verticalRadius: parent.height/3
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#FFFFFFFF"}
            GradientStop { position: 1.0; color: "#00FFFFFF" }
        }
        }
    }


    ParallelAnimation{
            running: GSystem.radioMode === txt.text
            NumberAnimation {
                id:selectedAni
                target: grad
                property: "opacity"
                from: 0
                to: 1
                duration: 500
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: grad
                property: "width"
                from: 0
                to: 161
                duration: 500
                easing.type: Easing.InOutQuad
            }
    }
    ParallelAnimation{
         running: GSystem.prevRadioMode === txt.text
         NumberAnimation {
            id:unselectedAni
            target: grad
            property: "opacity"
            from:  1
            to: 0
            duration: 500
            easing.type: Easing.Linear
        }
        NumberAnimation {
            target: grad
            property: "width"
            from:  161
            to: 0
            duration: 500
            easing.type: Easing.Linear
        }
    }

   }
