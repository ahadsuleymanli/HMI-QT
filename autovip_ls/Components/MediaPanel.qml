import QtQuick 2.0
import QtMultimedia 5.6
import ck.gmachine 1.0

Item {
    id:root
    width :490
    height:490
    Text{
        id:caption
        anchors.right: parent.right
        font.family:GSystem.centurygothic.name
        font.pixelSize: 24
        color:"white"
        text: mp_mng.title
    }
    function init()
    {
        //video.play();
    }
    function end()
    {
        video.stop();
    }
    MediaControls{
        x:0
        y:81
    }
    Image{
        id:filmimg
        source:mp_mng.thumbnail
        x:255
        y:81
        width :222
        height:294


    }
    /*
    VideoOutput {
            x:filmimg.x
            y:filmimg.y
            width:filmimg.width
            height:filmimg.height
            source: player
   }
   */
   Video {
    id: video
    x:filmimg.x
    y:filmimg.y
    width:filmimg.width
    height:filmimg.height
    fillMode: VideoOutput.Stretch

    source: "file:///"+workingDirPath+"/film.mp4"

    MouseArea {
        anchors.fill: parent
        onClicked: {
            //video.play()
        }
    }

    focus: true
    Keys.onSpacePressed: video.playbackState == MediaPlayer.PlayingState ? video.pause() : video.play()
    Keys.onLeftPressed: video.seek(video.position - 5000)
    Keys.onRightPressed: video.seek(video.position + 5000)
}
   /*

    MediaPlayer {
        id: player
        source: "file:///"+workingDirPath+"/film.mp4"
        onPlaying: {
            filmimg.opacity = 0;
        }
        onStopped: {
            filmimg.opacity = 1;
        }
    }
    */

    MediaProgress
    {
        x:0
        y:425
        width : parent.width - 20
    }

}
