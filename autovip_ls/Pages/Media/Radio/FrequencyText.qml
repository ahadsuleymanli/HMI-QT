import QtQuick 2.0
import QtGraphicalEffects 1.0

Item{
    id:root
    property alias wholePartAnimation: wholePartAnimation
    property alias fractionPartAnimation: fractionPartAnimation
    property alias wholePartCO: wholePartCO
    property alias fractionPartCO: fractionPartCO

    function getFreqText(){
        var valueString;
        if (buttons.numpadNumWhole){
            valueString = buttons.numpadNumWhole.toString()+".";
            if (buttons.numpadNumFraction)
                valueString += buttons.numpadNumFraction.toString();
            else
                valueString += frequencySlider.frequency.toString().split(".")[1]
        }
        else if (buttons.numpadNumFraction){
            valueString = frequencySlider.frequency.toString().split(".")[0]+".";
            valueString += buttons.numpadNumFraction.toString();
        }
        else
            valueString = frequencySlider.frequency.toString();
        var realValue = parseFloat(valueString);
        if (realValue>maxFrequency)
            realValue=maxFrequency
        else if (realValue<minFrequency)
            realValue=minFrequency;
        return realValue;
    }
    Text {
        anchors.right: dot.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -2
        id:wholePart
        text:buttons.numpadNumWhole?buttons.numpadNumWhole:frequencySlider.frequency.toString().split(".")[0]
        font.pixelSize: 50
        font.family:GSystem.centurygothic.name
        color: "white"
        style: Text.Raised;
        styleColor: "#ffffd700"
        antialiasing: true
        smooth: true
        ColorOverlay {
            id:wholePartCO
            anchors.fill: wholePart
            source: wholePart
            color: "#44ffd700"
            visible: false
        }
        SequentialAnimation {
            id:wholePartAnimation
            loops: Animation.Infinite
            running: false
            NumberAnimation {target: wholePart;property: "opacity";duration: 400;from:1;to:0.5;easing.type: Easing.InOutQuad}
            NumberAnimation {target: wholePart;property: "opacity";duration: 400;from:0.5;to:1;easing.type: Easing.InOutQuad}
            onRunningChanged: {
                if (!running)
                    wholePart.opacity=1
            }
        }
    }
    Text {
        anchors.right: fractionPart.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -2
        id:dot
        text:"."
        font.pixelSize: 50
        font.family:GSystem.centurygothic.name
        color: "white"
        style: Text.Raised;
        styleColor: "#ffffd700"
        antialiasing: true
        smooth: true
    }
    Text {
        anchors.right: parent.horizontalCenter
        anchors.rightMargin: -50
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -2
        id:fractionPart
        text:buttons.numpadNumFraction?buttons.numpadNumFraction:frequencySlider.frequency.toFixed(1).toString().split(".")[1]
        font.pixelSize: 50
        font.family:GSystem.centurygothic.name
        color: "white"
        style: Text.Raised;
        styleColor: "#ffffd700"
        antialiasing: true
        smooth: true
        ColorOverlay {
            id:fractionPartCO
            anchors.fill: fractionPart
            source: fractionPart
            color: "#44ffd700"
            visible: false
        }
        SequentialAnimation {
            id:fractionPartAnimation
            loops: Animation.Infinite
            running: false
            NumberAnimation {target: fractionPart;property: "opacity";duration: 400;from:1;to:0.5;easing.type: Easing.InOutQuad}
            NumberAnimation {target: fractionPart;property: "opacity";duration: 400;from:0.5;to:1;easing.type: Easing.InOutQuad}
            onRunningChanged: {
                if (!running)
                    fractionPart.opacity=1
            }
        }
    }
    Text{
        text:"MHz"
        font.pixelSize: 20
        font.family:GSystem.centurygothic.name
        color: "white"
        style: Text.Raised;
        styleColor: "#ffffd700"
        antialiasing: true
        smooth: true
        anchors.left: fraction.right
        anchors.top: fraction.verticalCenter
        anchors.topMargin: -2
    }

}

