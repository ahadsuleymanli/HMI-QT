import QtQuick 2.0
import "../Radio"
Button {
    property int number: -1
    text.text: number
    mouseArea.onPressed: {
        pressed=true;
        numpad.numPadInput(number);
        if (!pointPressed){
            frequencyText.wholePartCO.visible=true
            frequencyText.wholePartAnimation.pause()
        }
        else{
            frequencyText.fractionPartCO.visible=true
            frequencyText.fractionPartAnimation.pause()
        }
    }
    mouseArea.onReleased: {
        pressed=false;
        frequencyText.wholePartCO.visible=false
        frequencyText.fractionPartCO.visible=false
        if (frequencyText.fractionPartAnimation.paused)
            frequencyText.fractionPartAnimation.restart()
        if (frequencyText.wholePartAnimation.paused)
            frequencyText.wholePartAnimation.restart()
    }

}
