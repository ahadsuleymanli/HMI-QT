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
        frequencySlider.updateSliderPos();
    }
    Connections{
        target:serial_mng
        onRadioFrequencyChanged:{
            frequency=serial_mng.radioFrequency_uint/10;
            frequencySlider.updateSliderPos();
        }

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
        opacity: 1
        onMovementEnded: {
            frequencySlider.contentX=index*itemWidth-margin;
//            if (opacity>0 && showAnimation.running==false){
//                showAnimation.stop();
//                hideAnimation.start();
//            }
        }
        onMovementStarted: {
//            if (opacity<1 && showAnimation.running==false){
//                hideAnimation.stop();
//                showAnimation.start();
//            }
        }
        onContentXChanged: {
            var index;
            index = Math.round((frequencySlider.contentX+margin)/itemWidth)
            if (frequencySlider.index!==index){
                frequencySlider.index=index;
                root.setFrequency(minFrequency+index/10)
            }
        }
        function updateSliderPos(){
            if (!frequencySlider.moving){
                frequencySlider.contentX = (root.frequency-minFrequency)*10*itemWidth-margin;
            }
        }
        NumberAnimation {
            id:hideAnimation
            target: frequencySlider;
            running: false
            property: "opacity";
            duration: 400;
            from:frequencySlider.opacity;
            to:0.4;
            easing.type:Easing.InOutQuad
        }
        NumberAnimation {
            id:showAnimation
            target: frequencySlider;
            running: false
            property: "opacity";
            duration: 400;
            from:frequencySlider.opacity;
            to:1;
            easing.type:Easing.InOutQuad
        }

        anchors{
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: parent.bottom
//            topMargin: 100
//            bottomMargin: 15
        }
        model: frequencyList
        orientation: ListView.Horizontal
        clip: true
        spacing:0
        delegate: Item {
            id: frequencyTick
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.topMargin: 140
            anchors.bottomMargin: 15
            width: frequencySlider.itemWidth
            height: frequencySlider.height
            Text {
                anchors.verticalCenter: parent.top
                anchors.verticalCenterOffset: 12
                anchors.horizontalCenter: parent.horizontalCenter
                property int distance: (frequencySlider.index-5>index || frequencySlider.index+5<index )?-1:Math.abs(frequencySlider.index-index)
                property int previousDistance: -1
                id:frequencyText
                text: frequency
                opacity: 1
                color: "#fbfbfb"
                font.pixelSize: 18
                font.family:GSystem.centurygothic.name
                font.bold: true
//                onDistanceChanged: {
//                    if (distance===-1){
//                        opacity=1;
//                        font.pixelSize=18;
//                    }else if (distance<previousDistance){
//                        opacity=(distance>1)?(distance/10):0
//                        font.pixelSize=((5-distance)+2)*9
//                    }else{
//                        opacity=(distance>1)?(distance/10):0
//                        font.pixelSize=18
//                    }
//                    previousDistance=distance
//                }
                Component.onCompleted: {
                    if (frequency - Math.floor(frequency)>0){
//                        if ((frequency!=minFrequency && frequency!=maxFrequency))
                        {
                            text="";
                            distance = 0
                        }
                    }
                }
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
            frequencyList.append({frequency: (i/10).toFixed(1)})
        }
        frequencySlider.updateSliderPos();


    }

}
