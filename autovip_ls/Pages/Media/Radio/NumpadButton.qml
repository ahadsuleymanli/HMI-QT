import QtQuick 2.0
import "../Radio"
Button {
    property int number: -1
    text.text: number
    mouseArea.onPressed: {
        pressed=true;
        numpad.numPadInput(number);
        if (!numpadPointPressed){
            frequencyText.wholePartCO.visible=true
            frequencyText.textAnimation.pause()
        }
        else{
            frequencyText.fractionPartCO.visible=true
            frequencyText.textAnimation.pause()
        }
    }
    mouseArea.onReleased: {
        pressed=false;
        frequencyText.wholePartCO.visible=false
        frequencyText.fractionPartCO.visible=false
        if (frequencyText.textAnimation.paused)
            frequencyText.textAnimation.restart()
    }

}
