import QtQuick 2.0
import "../Numpad"

Button {
    id:root
    property int number: -1
    text.text: number
    mouseArea.onPressed: {
        numpadPressed(number)
    }
    mouseArea.onReleased: {
    }

}
