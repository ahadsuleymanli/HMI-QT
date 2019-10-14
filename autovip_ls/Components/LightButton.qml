import QtQuick 2.0
import ck.gmachine 1.0

Rectangle{
            id:root
            property alias text: caption.text
            color:Qt.rgba(0, 0, 0,0.4)
            border.width: 1
            border.color:Qt.rgba(0/255, 108/255, 128/255,0.6)
            signal clicked;
            signal released;
            signal pressed;
            signal holded;
            Text{
                id:caption
                anchors.centerIn: parent
                text:qsTr("Memory 1") + mytrans.emptyString
                color:"white"
                font.pixelSize: 18
                horizontalAlignment: Text.AlignHCenter
                font.family: GSystem.centurygothic.name
            }
            MouseArea{
                anchors.fill: parent
                onPressed: {
                    root.color = GSystem.leftTextMenuItemPressedColor;
                    root.pressed();
                }
                onReleased: {
                    root.color = GSystem.leftTextMenuItemColor;
                    root.released();
                }
                onClicked: {
                    root.color = GSystem.leftTextMenuItemColor;
                    root.clicked();
                }
                onPressAndHold: {

                    root.color = GSystem.leftTextMenuItemPressedColor;
                    root.holded();
                }
            }
        }
