import QtQuick 2.4
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import ck.gmachine 1.0

Rectangle {
    id:root
    width:275
    height:75
    anchors.horizontalCenter: parent.horizontalCenter
    color:Qt.rgba(0, 0, 0,0.4)
    border.width: 1
    border.color:Qt.rgba(0/255, 108/255, 128/255,0.6)
    property string text
    signal pressed
    signal released
    signal clicked
    RowLayout{
        anchors.fill: parent
        spacing: 0
        Rectangle{
            id:coolintext
            width: 200
            height: parent.height
            border.width: 1
            border.color:Qt.rgba(0/255, 108/255, 128/255,0.6)
            color:"transparent"
            Text{
                id:btnText
                font.family: GSystem.myriadproita.name
                font.italic: true
                font.pixelSize: 24
                text: root.text
                color: "white"
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill: parent
                onPressed: function(){
                    coolintext.color = Qt.rgba(0/255, 108/255, 128/255,0.6);
                    root.pressed();
                }
                onReleased: function(){
                    coolintext.color = "transparent";
                    root.released();
                }
            }
        }
        Rectangle{
            id:coolinarea
            width: 75
            height: parent.height
            border.width: 1
            border.color:Qt.rgba(0/255, 108/255, 128/255,0.6)
            color: "transparent"
            Column
            {
                anchors.centerIn: parent
                id:cooldegree
                spacing: 5
                        Rectangle{
                        id:coollevel1
                        radius: 5
                        width:30
                        height:5
                        color:serial_mng.cool>2?"#4ab8f7":"white"
                            MouseArea{
                               anchors.fill: parent
                               cursorShape: Qt.IBeamCursor;
                            }
                        }
                        Rectangle{
                        id:coollevel2
                        radius: 5
                        width:30
                        height:5
                        color:serial_mng.cool>1?"#4ab8f7":"white"
                            MouseArea{
                               anchors.fill: parent
                               cursorShape: Qt.IBeamCursor;
                            }
                        }
                        Rectangle{
                        id:coollevel3
                        radius: 5
                        width:30
                        height:5
                        color:serial_mng.cool>0?"#4ab8f7":"white"
                            MouseArea{
                               anchors.fill: parent
                               cursorShape: Qt.IBeamCursor;
                            }
                        }
            }
        }
    }
}
