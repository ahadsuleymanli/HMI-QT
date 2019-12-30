import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import "../Numpad"
Rectangle{
    id: root
    color: "#ff0c0c0c"
    signal numpadPressed (var key)
    signal enterPressed
    property alias keysGrid: keysGrid
    property alias enterButton: enterButton
    property alias extraBtn0: extraBtn0
    property alias extraBtn1: extraBtn1
    property alias extraBtn2: extraBtn2
    property alias extraBtn3: extraBtn3
    height: 263 + 72
    width: 378
    GridLayout {
        id:keysGrid
        columns: 3
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 4
        NumpadButton{number: 1}
        NumpadButton{number: 2}
        NumpadButton{number: 3}
        NumpadButton{number: 4}
        NumpadButton{number: 5}
        NumpadButton{number: 6}
        NumpadButton{number: 7}
        NumpadButton{number: 8}
        NumpadButton{number: 9}
        NumpadButton{number: 0}
        Button{id:enterButton; text.text: qsTr("ENTER"); text.font.pixelSize:18;mouseArea.onPressed: enterPressed();}
        Button{id:extraBtn0; visible: false; text.font.pixelSize:18;}
        Button{id:extraBtn1; visible: false; text.font.pixelSize:18;}
        Button{id:extraBtn2; visible: false; text.font.pixelSize:18;}
        Button{id:extraBtn3; visible: false; text.font.pixelSize:18;}
    }
}


