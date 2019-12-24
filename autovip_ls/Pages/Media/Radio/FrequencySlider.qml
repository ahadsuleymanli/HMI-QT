import QtQuick 2.0
import QtQuick.Controls 2.0
//import QtQuick.Extras 1.4
import QtQuick.Layouts 1.1

import QtGraphicalEffects 1.0
Item {
    id:root
    property real frequency: 88.1
    property real autoSliderIncrement: 0
    function setFrequency(frequency){
        if (frequency<minFrequency)
            root.frequency=minFrequency
        else if (frequency>maxFrequency)
            root.frequency=maxFrequency
        else{
            root.frequency=frequency
        }
        var formattedFreq=Math.round(root.frequency*10)
        serial_mng.radioFrequency_uint=formattedFreq;
    }
    Connections{
        target:serial_mng
        onRadioFrequencyChanged:frequency=serial_mng.radioFrequency_uint/10
    }

    function increment(amount){
        root.setFrequency(frequency+amount)
    }
    function autoIncrement(value){
        root.autoSliderIncrement=value;
        if (value===0)
            autoIncrementTimer.stop();
        else
            autoIncrementTimer.start();
    }
    Timer{
        id:autoIncrementTimer
        interval: 50; running: false; repeat: true; triggeredOnStart: true;
        onTriggered: root.increment(root.autoSliderIncrement)
    }

    ListModel{
        id:frequencyList

    }

    ListView {
//            Rectangle{
//                anchors.fill: parent
//                color: "#55ff00ff"
//            }
        id: frequencySlider
        onMovementEnded: {
            console.log("ended");
            console.log(flick.contentX);
        }
        anchors{
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: parent.bottom
            topMargin: 100
            bottomMargin: 15
        }
        model: frequencyList
        orientation: ListView.Horizontal
        clip: true

        delegate: Item {
            id: frequencyTick
            width: 20
            height: frequencySlider.height
                Text {
                    property real frequency_: frequency
                    anchors.top: parent.top
                    id:frequencyText
                    text: frequencyToShow
                    color: "#fbfbfb"
                    font.pixelSize: 16
                    font.bold: true
                }
                Rectangle{
                    anchors{
                        horizontalCenter: frequencyTick.horizontalCenter
                        bottom: parent.bottom
                    }
                    width: 2
                    height: 10
                    color: "white"
                }
        }
    }
    Component.onCompleted: {
        for (var i=minFrequency*10;i<=maxFrequency*10;i++){
            frequencyList.append({frequency: (i/10).toFixed(1), frequencyToShow: ((i/10) - Math.floor((i/10))>0)?"":((i/10).toFixed(1)).toString()})
        }


    }

}
