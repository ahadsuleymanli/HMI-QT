import QtQuick 2.5
import QtMultimedia 5.6
Rectangle {
    id:root
    width: 1024
    height: 768
    color: "#0f0f0f"
    MediaPlayer {
        id: player
        source: "file:///"+workingDirPath+"/intro.mp4"
        onStopped:{
            root.visible = false;
            if(serial_mng.isConnected())
            {
                    serial_mng.sendKey("main/system_request");
            }
        }
    }
     Timer {
        id:timer
        interval: 4500; running: false; repeat: false
        onTriggered: hideme.running=true;
    }
    VideoOutput {
        anchors.fill: parent
        x:0
        y:0
        width:1024
        height:768
        source: player

    }

    NumberAnimation {
        id:hideme
        target: root
        property: "opacity"
        duration: 750
        to:0
        running: false
    }
    Component.onCompleted: {
        if(SM.intro)
        {
            player.play();
            timer.running = true;
        }else{
            root.visible = false;
        }
    }
}
