import QtQuick 2.0
//import QtQuick.Window 2.2

Rectangle {
    id: root
    property int frameCounter: 0
    property int frameCounterAvg: 0
    property int counter: 0
    property int fps: 0
    property int dippingFps: 0
    property int fpsAvg: 0

    readonly property real dp: Screen.pixelDensity * 25.4/160

    color: "black"
    width:  childrenRect.width + 10*dp;
    height: childrenRect.height + 10*dp;

    Image {
        id: spinnerImage
        anchors.verticalCenter: parent.verticalCenter
        x: 4 * dp
        width: 36 * dp
        height: width
        source: "qrc:/design/general/spinner.png"
        NumberAnimation on rotation {
            from:0
            to: 360
            duration: 800
            loops: Animation.Infinite
            running: root.visible
        }

        onRotationChanged: {frameCounter++;}
    }

    Text {
        anchors.left: spinnerImage.right
        anchors.leftMargin: 8 * dp
        anchors.verticalCenter: spinnerImage.verticalCenter
        color: "#c0c0c0"
        font.pixelSize: 18 * dp
        text: root.dippingFps + " fps | " + root.fpsAvg
    }

    Timer {
        interval: 50
        repeat: true
        running: root.visible
        onTriggered: {
            fps = frameCounter*20;
            frameCounterAvg += fps;
            if (!(fps>root.fpsAvg))
                root.dippingFps = fps;
            counter++;
            frameCounter = 0;
            if (counter >= 24) {
                root.fpsAvg = frameCounterAvg/(counter)
                frameCounterAvg = 0;
                counter = 0;
            }
        }
    }
}
