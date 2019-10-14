import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import ck.gmachine 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id:root
    property string message: "infoverlay"
    signal finished
    width:1024
    height:768
    visible: false

    function come()
    {
        infofadein.start();
        root.visible=true
    }




    Rectangle{
        id:infoverlay
        width: 1024
        height:768
        color:Qt.rgba(0,0,0,0.8)
        z:343
        opacity: 0
        visible: true
        MouseArea{
            anchors.fill: parent
            onClicked: {
                if(infoverlay.opacity==1){
                    infofadeout.start();
                    remover.start();
                }
            }
        }
    }

    Rectangle{
        id:infomenu
        anchors.centerIn: infoverlay;
        width: 900
        height:600
        color:"#1c1c1c"
        border.width: 3
        border.color:Qt.rgba(0/255, 108/255, 128/255,0.6)
        z:344
        opacity: 0
        visible: true
        MouseArea{
            anchors.fill: parent
            onClicked: {
            }
        }

            TableView {
                id:infoverlayTable
                width: 800
                height: 450
                model: GSystem.infoverlayModel
                anchors.centerIn: infomenu
                horizontalScrollBarPolicy : Qt.ScrollBarAlwaysOff
                verticalScrollBarPolicy : Qt.ScrollBarAlwaysOff

                TableViewColumn {
                    role: "command"
                    title: qsTr("Command") + mytrans.emptyString
                    width: 400
                    movable: false
                    resizable: false
                }
                TableViewColumn {
                    role: "action"
                    title: qsTr("Action") + mytrans.emptyString
                    width: 400
                    movable: false
                    resizable: false
                }

                itemDelegate: Item {
                                        Text {
                                          anchors.verticalCenter: parent.verticalCenter
                                          anchors.horizontalCenter: parent.horizontalCenter
                                          color: "white"
                                          elide: styleData.elideMode
                                          text: styleData.value
                                          font.pixelSize: 15
                                        }
                                 }

                style: TableViewStyle {
                    headerDelegate: Rectangle {
                        height: textItem.implicitHeight * 2
                        width: textItem.implicitWidth
                        color: "#141414"
                        Text {
                            id: textItem
                            anchors.fill: parent
                            verticalAlignment: Text.AlignVCenter
//                            horizontalAlignment: styleData.textAlignment
                            horizontalAlignment: Text.AlignHCenter
                            text: styleData.value
                            elide: Text.ElideRight
                            color: "white"
                            renderType: Text.NativeRendering
                        }
                        Rectangle {
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 1
                            anchors.topMargin: 1
                            width: 1
                            color: "#ccc"
                        }
                    }

                    backgroundColor: "#212121"
                    alternateBackgroundColor: "#313131"
                    textColor: "white"


                }

            }

    }

    Rectangle{
        id:infoheader
        height: 30
        width: infomenu.width - 6
        anchors.top:infomenu.top
        anchors.topMargin: 3
        anchors.leftMargin: 3
        anchors.left:infomenu.left
        visible: true
        opacity: 0
        z:345
        color: "#0f0f0f"
        Text {
            text:qsTr("Command list that you can ask from the voice assistant.") + mytrans.emptyString
            font.pixelSize: 16
            font.italic: true
            color: "white"
            anchors.centerIn: parent
        }
    }

    Text{
        anchors.horizontalCenter: parent.horizontalCenter
        visible: false
        y:120
        z:345
        font.family:GSystem.myriadproita.name
        font.italic: true
        font.pixelSize: 25
        color: "white"
    }


        Rectangle{
            id: infoclose
            width: 120
            height: 50
            color:"#0f0f0f"
            border.width: 1
            border.color:Qt.rgba(0/255, 108/255, 128/255,0.6)
            visible: true
            opacity: 0
            anchors.horizontalCenter: parent.horizontalCenter
            y:620
            z:346
            Text{
                anchors.centerIn: parent
                text:qsTr("Close") + mytrans.emptyString
                font.family:GSystem.myriadproita.name
                font.italic: true
                font.pixelSize: 18
                color: "white"
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    if(infoverlay.opacity==1){
                        infofadeout.start();
                        remover.start();
                    }
                }
                onPressed: {
                    infoclose.color = Qt.rgba(0/255, 108/255, 128/255,0.6)
                }
                onReleased: {
                    infoclose.color = "#0f0f0f"
                }
            }
        }

       NumberAnimation {
           id:infofadeout
           targets: [infoverlay,infomenu,infoheader,infoclose]
           properties: "opacity"
           from:1
           to:0
           duration:250
           running: false
           loops: 1
       }
       NumberAnimation {
           id:infofadein
           targets: [infoverlay,infomenu,infoheader,infoclose]
           properties: "opacity"
           from:0
           to:1
           duration:250
           running: false
           loops: 1
       }
       Timer{
           id:remover
           repeat: false
           running: false
           interval: 250
           onTriggered: root.visible=false;
       }
}
