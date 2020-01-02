import QtQuick 2.4
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import ck.gmachine 1.0


SeatButton{
    id:root
    text.text: qsTr("Seat Presets")
    property alias overlay: overlay
    property Item overlaysParent
    mouseArea.onPressed: {
        overlay.visible=true;
    }
    function reset(){
        endSaveMode();
        overlay.visible=false;
    }
    function startSaveMode(){
        presetButton1.blinkingAnimation.start();
        presetButton2.blinkingAnimation.start();
        presetButton3.blinkingAnimation.start();
        saveButton.toggled=true;
    }
    function endSaveMode(){
        presetButton1.blinkingAnimation.stop();
        presetButton2.blinkingAnimation.stop();
        presetButton3.blinkingAnimation.stop();
        saveButton.toggled=false;
    }
    SeatButton{
        id:overlay
        visible: false
        parent: overlaysParent
        anchors.top: parent.top
        anchors.bottom: root.top
        anchors.bottomMargin: 20
        anchors.left: parent.left
        border.width: 0
        color:Qt.rgba(0, 0, 0,0.4)
        SeatButton{
            text.text: qsTr("Seat Presets")
            anchors.top: parent.bottom
            anchors.topMargin: 20
            color: Qt.rgba(0/255, 108/255, 128/255,0.6)
            mouseArea.onPressed: {
                overlay.visible=false;
            }
        }
        ColumnLayout{
            spacing: 20
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            SeatButton{
                id:presetButton1
                radius:8
                text.text: "1"
                mouseArea.onClicked: {
                    if (!blinkingAnimation.running)
                        serial_mng.loadPositionPreset(GSystem.selectedSeat,1);
                    else{
                        serial_mng.savePositionPreset(GSystem.selectedSeat,1);
                        root.endSaveMode();
                    }
                }
                onBlinkEnded: root.endSaveMode();
            }
            SeatButton{
                id:presetButton2
                radius:8
                text.text: "2"
                mouseArea.onClicked: {
                    if (!blinkingAnimation.running)
                        serial_mng.loadPositionPreset(GSystem.selectedSeat,2);
                    else{
                        serial_mng.savePositionPreset(GSystem.selectedSeat,2);
                        root.endSaveMode();
                    }
                }
                onBlinkEnded: root.endSaveMode();
            }
            SeatButton{
                id:presetButton3
                radius:8
                text.text: "3"
                mouseArea.onClicked: {
                    if (!blinkingAnimation.running)
                        serial_mng.loadPositionPreset(GSystem.selectedSeat,3);
                    else{
                        serial_mng.savePositionPreset(GSystem.selectedSeat,3);
                        root.endSaveMode();
                    }
                }
                onBlinkEnded: root.endSaveMode();
            }
            SeatButton{
                id:saveButton
                border.width: 0
                Image{
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    sourceSize.height: height
                    anchors.margins: 6
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: "qrc:/design/general/saved.svg"
                }
                mouseArea.onReleased: {
                    if (!toggled){
                        root.startSaveMode();
                    }
                    else{
                        root.endSaveMode();
                    }

                }
            }
        }
    }
}




