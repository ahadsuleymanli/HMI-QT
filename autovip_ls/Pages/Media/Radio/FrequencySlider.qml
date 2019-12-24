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
    Image {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        height: 22
        width: parent.width - 48
        z:10
        source: "qrc:/design/media/Radio/frequency2.png"
    }
    Image {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: -1
        height: 43
        z:10
        source: "qrc:/design/media/Radio/line.png"
    }
    ListModel{
        id:frequencyList

    }
//    property real minFrequency:87.5
//    property real maxFrequency:108.0
    ListView {
//            Rectangle{
//                anchors.fill: parent
//                color: "#55ff00ff"
//            }
        property int itemWidth: 20
        readonly property int  margin: parent.width/2 - itemWidth/2;
        property int index: 0
        rightMargin: margin
        leftMargin: margin
        id: frequencySlider
        onMovementEnded: {
//            console.log(parent.width/2 - itemWidth/2);
//            console.log(frequencySlider.contentWidth);
//            console.log(frequencySlider.contentX);
        }
        onContentXChanged: {
            var index;
            index = (frequencySlider.contentX+margin)/itemWidth
            console.log(index);
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
        spacing:0
        delegate: Item {
            id: frequencyTick
            width: frequencySlider.itemWidth
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
        var i=minFrequency*10
        var count = 0;
        for (;i<=maxFrequency*10;i++){
            count ++;
            frequencyList.append({frequency: (i/10).toFixed(1), frequencyToShow: ((i/10) - Math.floor((i/10))>0)?"":((i/10).toFixed(1)).toString()})
        }
        console.log("last freq" + i/10 + " count: " + count);

    }

}
