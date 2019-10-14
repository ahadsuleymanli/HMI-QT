import QtQuick 2.0
import QtGraphicalEffects 1.0
import ck.gmachine 1.0

Item {
    property alias text: txt.text
    property alias icon: ico.source
    property bool selected:false
    signal modSelected( string sel)
    width:161
    height:44
    Item{
            id:mrow
            width:parent.width
            height:parent.height
        Row{
            spacing: 7
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.fill: parent
            Image{
                id:ico
            }
            Text{
                id:txt
                text:""
                font.pixelSize: 28
                font.family:GSystem.centurygothic.name
                color: "white"
                horizontalAlignment: Text.AlignHCenter
            }

        }
           MouseArea{
               anchors.fill: parent
               cursorShape: Qt.PointingHandCursor
               onClicked: modSelected(txt.text)
           }
    }


   Item {
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: mrow.bottom
    anchors.topMargin: 2
    width: 161
    height: 6

    RadialGradient {
        id:grad
        opacity: 0
        anchors.fill: parent
        horizontalRadius:parent.width/2
        verticalRadius: parent.height/2
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
