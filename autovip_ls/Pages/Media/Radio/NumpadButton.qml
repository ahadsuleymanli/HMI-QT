import QtQuick 2.0
import "../Radio"
Button {
    property int number: -1
    text.text: number
    mouseArea.onPressed: {
        pressed=true;
        numpad.numPadInput(number)
    }
    mouseArea.onReleased: {
        pressed=false;
    }

}
