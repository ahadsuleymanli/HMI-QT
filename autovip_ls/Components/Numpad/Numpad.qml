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
    height: 263
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
        Button{text.text: "ENTER"; text.font.pixelSize:18;mouseArea.onPressed: enterPressed();}
        Component.onCompleted: {
//            console.log(height + " w: " + width)
        }
    }
}


