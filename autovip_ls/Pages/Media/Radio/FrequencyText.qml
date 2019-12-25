import QtQuick 2.0
import QtGraphicalEffects 1.0
import ck.gmachine 1.0

Item{
    id:root
    property alias textAnimation: textAnimation
    property alias wholePartCO: wholePartCO
    property alias fractionPartCO: fractionPartCO

    function getFreqText(){
        var valueString;
        if (buttons.numpadNumWhole!==-1){
            valueString = buttons.numpadNumWhole.toString()+".";
            if (buttons.numpadNumFraction!==-1)
                valueString += buttons.numpadNumFraction.toString();
        }
        else if (buttons.numpadNumFraction!==-1){
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
    SequentialAnimation {
        id:textAnimation
        loops: Animation.Infinite
        running: false
        NumberAnimation {targets: [wholePart, dot,fractionPart];property: "opacity";duration: 400;from:1;to:0.2;}
        NumberAnimation {targets: [wholePart, dot,fractionPart];property: "opacity";duration: 400;from:0.2;to:1;}
        onRunningChanged: {
            if (!running){
                wholePart.opacity=1;
                dot.opacity=1;
                fractionPart.opacity=1;
            }
        }
    }
    Text {
        anchors.right: dot.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -2
        id:wholePart
        text:buttons.numpadNumWhole!==-1?buttons.numpadNumWhole:frequencySlider.frequency.toString().split(".")[0]
        font.pixelSize: 50
//        font.family:GSystem.centurygothic.name
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
    }
    Text {
        anchors.right: fractionPart.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -2
        id:dot
        text:"."
        visible: (buttons.numpadNumWhole!==-1&&buttons.numpadNumFraction===-1&&!buttons.numpadPointPressed)?0:1
        font.pixelSize: 50
//        font.family:GSystem.centurygothic.name
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
        text:buttons.numpadNumFraction!==-1?buttons.numpadNumFraction:frequencySlider.frequency.toFixed(1).toString().split(".")[1]
        visible: (buttons.numpadNumWhole!==-1&&buttons.numpadNumFraction===-1)?0:1
        font.pixelSize: 50
//        font.family:GSystem.centurygothic.name
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
    }
    Text{
        text:"MHz"
        font.pixelSize: 20
//        font.family:GSystem.centurygothic.name
        color: "white"
        style: Text.Raised;
        styleColor: "#ffffd700"
        antialiasing: true
        smooth: true
        anchors.left: fractionPart.right
        anchors.top: fractionPart.verticalCenter
        anchors.topMargin: -2
    }

}

