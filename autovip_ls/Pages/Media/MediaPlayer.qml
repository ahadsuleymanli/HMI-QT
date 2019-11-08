import QtQuick 2.11
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtMultimedia 5.11
import QtQuick.Controls.Material 2.3
import ck.gmachine 1.0
import "../../Components"
import QtGraphicalEffects 1.0
import MediaPlayerBackend 1.0

BasePage {
    id:root
    caption: qsTr("MEDIA") + mytrans.emptyString
    pageName: "MediaPlayer"
    property real playingIndex : -1
    property real queueLastIndex: -1
    property bool isShuffle: false
    property bool playQueue: true
    property bool userStop: false
    property bool userPause: false


    property real lastPosition: 0
    property real lastDuration: 0
    property var lastSource: ""
    property alias mPlayerBackend : mPlayerBackend

    property real positionRatio: {
        if(mPlayerBackend.duration > 0)
            return (mPlayerBackend.position / mPlayerBackend.duration)
    }

    property string audioPositionStr: {
        var pos = root.userPause ? root.lastPosition : mPlayerBackend.position
        var posMin = Math.floor(pos / 60000)
        var posSec = Math.floor(pos / 1000 - posMin * 60)
        return posMin + ":" + (posSec < 10 ? "0" + posSec : posSec);
    }
    property string audioDurationStr: {
        var durMin = Math.floor(mPlayerBackend.duration / 60000)
        var durSec = Math.floor(mPlayerBackend.duration / 1000 - durMin * 60)
        return durMin + ":" + (durSec < 10 ? "0" + durSec : durSec);
    }

    /* Generates random number within range of 0 to max value
        except given value */
    function generateRandom(max, exclude){
        var num = Math.floor(Math.random() * max);
        return (num === exclude) ? generateRandom() : num;
    }

    /* Decides which media to play next */
    function nextMedia(){
        var nextIndex = 0
        if(playQueue && queueModel.count !== 0){
            if(isShuffle){
                root.queueLastIndex = generateRandom(queueModel.count, root.queueLastIndex)
            }
            else{
                root.queueLastIndex = (((root.queueLastIndex + 1) < queueModel.count) ?
                            root.queueLastIndex + 1 : 0)
            }
            nextIndex = queueModel.get(queueLastIndex).listIndex
        }
        else{
            if(isShuffle){
                nextIndex = generateRandom(nameModel.count, root.playingIndex)
            }
            else{
                nextIndex = (((root.playingIndex + 1) < nameModel.count) ?
                                 root.playingIndex + 1 : 0)
            }
        }
        audioPlayer.seek(0)
        playAudio(nameModel.get(nextIndex).path)
        playingIndex = nextIndex
    }

    /* Plays previously played media */
    function prewMedia(){
        root.queueLastIndex = (((root.queueLastIndex - 1) >= 0) ?
                    root.queueLastIndex - 1 : queueModel.count-1)
        var nextIndex = queueModel.get(queueLastIndex).listIndex
        audioPlayer.source = nameModel.get(nextIndex).path
        audioPlayer.seek(0)
        playingIndex = nextIndex
    }

    /* Sets player to shuffle mode */
    function shuffleMedia(){
        isShuffle = true;
    }

    function pauseAudio(){
        root.userPause = true
        root.lastPosition = audioPlayer.position
        audioPlayer.stop()
        audioPlayer.source =""
//        root.userPause = true
    }
    function playAudio(src){
        if(src === "" || src === undefined)
            audioPlayer.source = root.lastSource
        else{
            audioPlayer.source = src
            root.lastSource = src
        }
        audioPlayer.play()

        root.userStop = false

    }
    MediaPlayerBackend{
        id: mPlayerBackend
        onPlayingMediaChanged: console.log(playingTitle)
    }
    ListView{
        id: playList
        model: mPlayerBackend.trackList()
        delegate: Text {
//            Component.onCompleted: if(index ===2) mPlayerBackend.play(path)
//            text: model.track
        }
    }

    Audio{
        id: audioPlayer
        source :""
        autoPlay: true
        onSourceChanged: {
            if(audioPlayer.source !== "" && audioPlayer.source !== undefined){

            }
        }
        onDurationChanged: root.lastDuration = duration
        onStatusChanged: {

            if(status === Audio.EndOfMedia){
                nextMedia()
            }
            if(status === Audio.Buffered ||
                    status === Audio.Loaded||
                    status === Audio.Loading){
                if(root.userPause){
                    audioPlayer.seek(root.lastPosition)
                    root.userPause = false
                }
            }
        }

        onPlaybackStateChanged: {
            if(audioPlayer.playbackState === Audio.PlayingState && root.userPause){

            }
        }

        onStopped: {
            if(!userStop && (status === Audio.Buffered ||
                    status === Audio.Loaded||
                    status === Audio.Loading)){
                if(root.userPause)
                    audioPlayer.seek(root.lastPosition)
            }
        }
    }

    RowLayout{
        id: mainLayout
        anchors{
            fill: parent
            topMargin: 128
            bottomMargin: 96
        }
        spacing: 0
        Item{
            Layout.fillHeight: true
            Layout.fillWidth: true
            clip: true
            Image{
                id: backgroundImage
                width: parent.width
                height: parent.height
                anchors.centerIn: parent
                visible: false
                source: "qrc:/design/media/MediaPlayer/background.png"

            }
            Canvas{
                id: drawingCanvas
                anchors.fill: parent
                onPaint:
                {
                    var ctx = getContext("2d")

                    // create a triangle as clip region
                    ctx.beginPath()
                    ctx.moveTo(0, 42)
                    ctx.lineTo(230, 42)
                    ctx.lineTo(266,0)
                    ctx.lineTo(drawingCanvas.width,0)
                    ctx.lineTo(drawingCanvas.width, drawingCanvas.height)
                    ctx.lineTo(0, drawingCanvas.height)
                    ctx.lineTo(0, 42)
                    ctx.closePath()
                    // translate coordinate system
                    ctx.clip()  // create clip from the path
                    // draw image with clip applied
                    ctx.drawImage('qrc:/design/media/MediaPlayer/background.png', -30, -240)
                    // draw stroke around path
                    // restore previous context
                    ctx.restore()
                }
            }
            StackView{
                id: stackView
                anchors.fill: parent
                initialItem: "MediaPlayer/Home.qml"
            }
        }
        Rectangle{
            Layout.fillHeight: true
            width: 220
            color: "#272727"
            Rectangle{
                anchors{
                    left: parent.left
                    leftMargin: - parent.height/2
                    verticalCenter: parent.verticalCenter
                }
                width: parent.height
                height : 4
                rotation: -90
                gradient: Gradient{
                    GradientStop { position: 0.0; color: "#464646" }
                    GradientStop { position: 1.0; color: "#272727" }
                }
            }
            ColumnLayout{
                anchors{
                    fill: parent
                    leftMargin: 20
                    rightMargin: 50
                    topMargin: 50
                }
                spacing: 12
                RowLayout{
                    id: row
                    Layout.fillWidth: true
                    height: childrenRect.height
                    Image{
                        Layout.alignment: Qt.AlignVCenter
                        sourceSize.width: 32
                        sourceSize.height: 32
                        source: "qrc:/design/media/MediaPlayer/home.png"
                    }
                    Text{
                        Layout.alignment: Qt.AlignVCenter
                        text: qsTr("Home")
                        color: "#a5a5a7"
                        font.pixelSize: 20
                    }
                }
                RowLayout{
                    Layout.fillWidth: true
                    height: childrenRect.height
                    Image{
                        Layout.alignment: Qt.AlignVCenter
                        sourceSize.width: 32
                        sourceSize.height: 32
                        source: "qrc:/design/media/MediaPlayer/explore.png"
                    }
                    Text{
                        Layout.alignment: Qt.AlignVCenter
                        text: qsTr("Explore")
                        color: "#a5a5a7"
                        font.pixelSize: 20
                    }
                }
                RowLayout{
                    Layout.fillWidth: true
                    height: childrenRect.height
                    Image{
                        Layout.alignment: Qt.AlignVCenter
                        sourceSize.width: 32
                        sourceSize.height: 32
                        source: "qrc:/design/media/MediaPlayer/artist.png"
                    }
                    Text{
                        Layout.alignment: Qt.AlignVCenter
                        text: qsTr("Artists")
                        color: "#a5a5a7"
                        font.pixelSize: 20
                    }
                }
                Item{
                    Layout.fillHeight: true
                }

            }
        }

    }




}
