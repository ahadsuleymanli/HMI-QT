import QtQuick 2.0

Item {
    id:root
    property real frequency: 88.1
    property real autoSliderIncrement: 0
    function setFrequency(frequency){
        if (frequency<minFrequency)
            root.frequency=minFrequency
        else if (frequency>maxFrequency)
            root.frequency=maxFrequency
        else
            root.frequency=frequency

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
//    Rectangle{
//        anchors.fill: parent
//        color: "#55ff00ff"
//    }
}
