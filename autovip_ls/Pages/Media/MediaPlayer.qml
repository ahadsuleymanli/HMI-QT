import QtQuick 2.4
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtMultimedia 5.11
import QtQuick.Controls.Material 2.3
import ck.gmachine 1.0
import "../../../Components"

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

    property string audioPositionStr: {
        var pos = root.userPause ? root.lastPosition : audioPlayer.position
        var posMin = Math.floor(pos / 60000)
        var posSec = Math.floor(pos / 1000 - posMin * 60)
        return posMin + ":" + (posSec < 10 ? "0" + posSec : posSec);
    }
    property string audioDurationStr: {
        var durMin = Math.floor(audioPlayer.duration / 60000)
        var durSec = Math.floor(audioPlayer.duration / 1000 - durMin * 60)
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
    Text{
        id: debugText
        text: root.userPause
    }

    Audio{
        id: audioPlayer
        source :""

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
        onPositionChanged: {
//            if(audioPlayer.position !== 0)
//                root.userPause = false
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
//                play()
            }

        }

    }


    ListModel{
        id: menuModel
        ListElement{name : qsTr("Now Playing"); }
        ListElement{name : qsTr("Playlist"); }
        ListElement{name : qsTr("Search");}
    }
    ListModel{
        id: queueModel

    }

    RowLayout{
        anchors{
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: parent.bottom
            topMargin: 170
        }
        ListView{
            id: menuList
            Layout.fillHeight: true
            width: 230
            model: menuModel
            spacing: 1
            onCurrentIndexChanged: {
                if(currentIndex === 0)
                    pageLoader.sourceComponent = playingComponent
                if(currentIndex === 1)
                    pageLoader.sourceComponent = playListComponent
            }

            delegate: Item{
                width: menuList.width
                height: 100
                ItemDelegate{
                    anchors.fill: parent

                    text: (menuList.currentIndex != index ? "" : "     ") + name
                    font.pixelSize: 18
                    onClicked: menuList.currentIndex = index
                }
            }

            highlight: Item{
                y: ListView.view.currentItem.y

                Behavior on y {
                    SequentialAnimation {
                        PropertyAnimation { target: highlightRectangle; property: "opacity"; to: 0; duration: 200 }
                        NumberAnimation { duration: 1 }
                        PropertyAnimation { target: highlightRectangle; property: "opacity"; to: 1; duration: 200 }
                    }
                }
                Rectangle{
                    id: highlightRectangle
                    height: parent.height
                    width: 10
                    radius: 2
                    color: "#ff1c7ece"
                }
            }
        }
        Item{
            id: spacer
            width: 5
            Layout.fillHeight: true
        }

        Loader{
            id: pageLoader
            Layout.fillHeight: true
            Layout.fillWidth: true
            sourceComponent: playingComponent
        }

    }
    Component{
        id: playingComponent
        Item{
            RowLayout{
                id: infoLayout
                Layout.fillHeight: true
                Layout.fillWidth: true
                spacing: 10
                Item{
                    Layout.fillHeight: true
                    width: 380
                    Label{
                        id: nowPlayingLabel
                        anchors{
                            left: imageItem.left
                            top: parent.top
                            topMargin: 10
                        }
                        font.pixelSize: 14
                        text: qsTr("NOW PLAYING")
                        color : "#a7a4a1"
                    }


                    Item{
                        id: imageItem
                        anchors{
                            top: nowPlayingLabel.bottom
                            horizontalCenter: parent.horizontalCenter
                            topMargin: 10
                        }
                        property real sizeRatio: playingNowImage.sourceSize.height /
                                       playingNowImage.sourceSize.width
                        height: 300
                        width: 340

                        Rectangle{
                            anchors.fill: parent
                            gradient:Gradient {
                                GradientStop { position: 0.0; color: "#1020a1ff" }
                                GradientStop { position: 1.0; color: "#10bfdfff" }
                            }
                        }

                        Image{
                            id: playingNowImage
                            anchors.fill: parent

                            source: playingIndex != -1 ?
                                        trackModel.imageAt(playingIndex) : ""
                            fillMode: Image.PreserveAspectFit
                        }
                    }

                    Item{
                        id: infoItem
                        anchors{
                            top: imageItem.bottom
                            left: imageItem.left
                            topMargin: 10
                            leftMargin: -10
                        }
                        width: 360
                        height: 50
                        Rectangle{
                            anchors.fill: parent
                            color: "#ee202020"
                            radius: 2
                        }
                        Rectangle{
                            id: playPauseButton
                            anchors{
                                left: parent.left
                                leftMargin: 5
                                verticalCenter: parent.verticalCenter
                            }
                            color: "transparent"
                            Image{
                                anchors.fill: parent
                                source: (audioPlayer.playbackState === Audio.PlayingState ?
                                        "qrc:/design/media/kodi/pauseBtn.svg":
                                            "qrc:/design/media/kodi/playBtn.svg")
                            }
                            MouseArea{
                                anchors.fill: parent
                                onClicked: (audioPlayer.playbackState === Audio.PlayingState ?
                                                pauseAudio() : playAudio())
                            }

                            width: 40
                            height: 40
                        }

                        ColumnLayout{
                            spacing: 0
                            anchors{
                                left: playPauseButton.right
                                leftMargin: 10
                                verticalCenter: parent.verticalCenter
                            }
                            Label{
                                text : audioPlayer.metaData.title
                                color: "#a1e3fa"
                            }
                            Label{
                                text : audioPlayer.metaData.contributingArtist
                                color: "#a1e3fa"
                            }
                        }
                    }
                }
                Item{
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Rectangle{
                        anchors{
                            left: parent.left
                            top: queueLabel.bottom
                            topMargin: 10
                        }
                        width: 340
                        height: 360
                        color: "#bb121212"
                        border.color: Qt.lighter("92a2b2")

                    }

                    Label{
                        id: queueLabel
                        anchors{
                            left: queuelist.left
                            top: parent.top
                            topMargin: 10
                        }
                        text: qsTr("Queue")
                        color: "#a7a4a1"
                    }
                    ListView{
                        id: queueList
                        anchors{
                            left: parent.left
                            top: queueLabel.bottom
                            topMargin: 10
                        }
                        width: 340
                        height: 360
                        Layout.fillHeight: true
                        currentIndex: queueLastIndex
                        clip: true
                        model: queueModel
                        delegate: queueListDelegate
                        highlight: Item{
                            y: ListView.view.currentItem.y
                            Behavior on y {
                                SequentialAnimation {
                                    PropertyAnimation { target: highlightRectangle; property: "opacity"; to: 0; duration: 200 }
                                    NumberAnimation { duration: 1 }
                                    PropertyAnimation { target: highlightRectangle; property: "opacity"; to: 1; duration: 200 }
                                }
                            }
                            Rectangle{
                                id: highlightRectangle
                                height: parent.height
                                width: 9
                                color: "#ff37b4d8"
                            }
                        }
                    }
                    Component{
                        id: queueListDelegate
                        Item{
                            id: wrapper
                            width: queueList.width
                            height: 60
                            Rectangle{
                                anchors{
                                    left: parent.left
                                    top: parent.top
                                    bottom: parent.bottom
                                }
                                width: 10
                                color : (queueList.currentIndex === index) ?
                                            "transparent" : delegateBackground.color
                            }

                            Rectangle{
                                id: delegateBackground
                                anchors.fill: parent
                                anchors.leftMargin: 10
                                color : (index%2 == 0) ? "#dd080808": "#40404040"
                                ColumnLayout{
                                    anchors{
                                        left: parent.left
                                        leftMargin: 2
                                        verticalCenter: parent.verticalCenter
                                    }
                                    spacing: 0
                                    Label{
                                        text: nameModel.get(listIndex).title

                                    }
                                    Label{
                                        text: nameModel.get(listIndex).artist
                                    }
                                }
                            }
                            MouseArea{
                                anchors.fill: parent
                                onClicked: {
                                    playAudio(nameModel.get(listIndex).path)
                                    root.queueLastIndex = index
                                    playingIndex = listIndex
                                }
                            }
                        }
                    }
                }
            }
            Item{
                id: controlItem
                anchors{
                    bottom: parent.bottom
                    bottomMargin: 130
                    left: parent.left
                    right: parent.right
                    rightMargin: 64
                }
                width: infoItem.width
                height: 50
                Rectangle{
                    id: controlBackground
                    anchors.fill: parent
                    color: "#1a1a1a"
                    border.color: Qt.lighter("#1a1a1a")
                }
                Label{
                    id: controlPositionLabel
                    anchors{
                        left: parent.left
                        leftMargin: 4
                        verticalCenter: parent.verticalCenter
                    }
                    width: controlDurationLabel.width
                    text: audioPositionStr
                }

                Label{
                    id: controlDurationLabel
                    anchors{
                        right: controls.left
                        rightMargin: 4
                        verticalCenter: parent.verticalCenter
                    }
                    text: audioDurationStr
                }
                Item{
                    id: controls
                    anchors{
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }
                    height: parent.height
                    width: 200

                    RowLayout{
                        anchors.fill: parent
                        spacing: 4
                        Rectangle{
                            id: prewControlButton
                            Layout.alignment: Layout.left
                            height: 40
                            width: 40
                            color: "#f4df5a"
                            MouseArea{
                                anchors.fill: parent
                                onClicked: prewMedia()
                            }
                        }
                        Rectangle{
                            id: playControlButton
                            Layout.alignment: Layout.left
                            height: 40
                            width: 40
                            color: "#74df5a"
                        }
                        Rectangle{
                            id: nextControlButton
                            Layout.alignment: Layout.left
                            height: 40
                            width: 40
                            color: "#f4df5a"
                            MouseArea{
                                anchors.fill: parent
                                onClicked: nextMedia()
                            }
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                        Rectangle{
                            id: shuffleControlButton
                            Layout.alignment: Layout.right
                            height: 40
                            width: 40
                            color: "#f4df5a"
                            MouseArea{
                                anchors.fill: parent
                                onClicked: shuffleMedia()
                            }
                        }

                        Item{
                            Layout.fillWidth: true
                        }
                    }
                }

                Item{
                    id: positionItem
                    anchors{
                        left: controlPositionLabel.right
                        right: controlDurationLabel.left
                        top: parent.top
                        bottom: parent.bottom
                        topMargin: 10
                        bottomMargin: 10
                        leftMargin: 5
                        rightMargin: 5
                    }
                    Rectangle{
                        id: positonStatusBackground
                        anchors.fill: parent
                        color: "#252525"
                        border.color: Qt.lighter("#252525")
                    }
                    Rectangle{
                        id: positionStatus
                        anchors{
                            left: parent.left
                            top: parent.top
                            bottom: parent.bottom
                            margins: 2
                        }
                        color: "#989898"
                        radius: 2
                        width: (parent.width - 4) *
                               ((root.userPause ? root.lastPosition / root.lastDuration
                                                : audioPlayer.position / audioPlayer.duration))

                    }
                    MouseArea{
                        anchors.fill: parent
                        anchors.margins: 2
                        onMouseXChanged: {
                            var xAbs = Math.max(0, mouseX)
                            if(userPause)
                                root.lastPosition = Math.min(root.lastDuration * (xAbs / width),
                                                             root.lastDuration)
                            else
                                audioPlayer.seek(Math.min(audioPlayer.duration * (xAbs / width),
                                                      audioPlayer.duration))
                        }
                    }
                }
            }
        }
    }

    Component{
        id: playListComponent
        ColumnLayout{
            Layout.fillHeight: true
            Layout.fillWidth: true
            Item{

                Layout.fillWidth: true
                height: 80
                visible: playingIndex != -1
                Rectangle{
                    anchors.fill: parent
                    color: "#aa0c0c0c"
                    border.color: Qt.lighter("8c8c8c")
                    radius: 2
                }

                Image{
                    id: playingListImage
                    anchors{
                        left: parent.left
                        leftMargin: 5
                        verticalCenter: parent.verticalCenter
                    }
                    height: 100
                    width: 100
                    source: playingIndex != -1 ?
                                trackModel.imageAt(playingIndex) : ""
                    fillMode: Image.PreserveAspectFit
                }
                ColumnLayout{
                    spacing: 0
                    anchors{
                        left: playingListImage.right
                        leftMargin: 10
                        verticalCenter: parent.verticalCenter
                    }
                    Label{
                        text : audioPlayer.metaData.title
                    }
                    Label{
                        text : audioPlayer.metaData.contributingArtist
                    }

                    Label{
                        color: "#a0a0a0"
                        text : audioPositionStr + " - " + audioDurationStr
                    }

                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: menuList.currentIndex = 0
                }
            }

            ListView{
                id: musicList
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                currentIndex: playingIndex
                model: nameModel
                delegate: musicListDelegate

                highlight: Item{
                    y: ListView.view.currentItem.y

                    Behavior on y {
                        SequentialAnimation {
                            PropertyAnimation { target: highlightRectangle2; property: "opacity"; to: 0; duration: 200 }
                            NumberAnimation { duration: 1 }
                            PropertyAnimation { target: highlightRectangle2; property: "opacity"; to: 1; duration: 200 }
                        }
                    }
                    Rectangle{
                        id: highlightRectangle2
                        height: parent.height
                        width: parent.width
                        color: "#ff37b4d8"
                    }
                }

            }
            Component{
                id: musicListDelegate
                Item{
                    id: wrapper

                    width: musicList.width
                    height: 50

                    Rectangle{
                        anchors.fill: parent
                        color: (index %2 && musicList.currentIndex != index)
                               ? "#dd101010": "#40404040"

                        Rectangle{
                            id: imageRect
                            anchors{
                                verticalCenter: parent.verticalCenter
                                left: parent.left
                                leftMargin: 10
                            }
                            width: 60
                            height: 40
                            color: "transparent"
                            Image{
                                id: audioImage
                                anchors.fill: parent
                                source: image
                                fillMode: Image.PreserveAspectFit
                            }
                        }


                        ColumnLayout{
                            anchors{
                                verticalCenter: parent.verticalCenter
                                left: imageRect.right
                                leftMargin: 5

                            }
                            Text {
                                id: audioName
                                color: musicList.currentIndex != index ?
                                           "#fff9e0" : "#131313"
                                text: title
                            }
                            Text{
                                id: artistName
                                color: musicList.currentIndex != index ?
                                           "#85a5af" : "#232323"
                                text: artist
                            }
                        }


                    }
                    Image {
                        id: addQueueImage
                        anchors{
                            right: parent.right
                            rightMargin: 40
                            verticalCenter: parent.verticalCenter
                        }
                        width: 40
                        height: 40
                        source: "qrc:/design/media/kodi/atQueue.png"
                        fillMode: Image.PreserveAspectFit
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            playAudio(path)
                            playingIndex = index
                            musicList.currentIndex = index
                        }
                    }
                    MouseArea{
                        anchors.fill: addQueueImage
                        hoverEnabled: true
                        onClicked: {
                            queueModel.append({"listIndex" : index})
                        }

                        onPressed: addQueueImage.source = "qrc:/design/media/kodi/addQueue.png"
                        onReleased: addQueueImage.source = "qrc:/design/media/kodi/atQueue.png"
                        onExited: addQueueImage.source = "qrc:/design/media/kodi/atQueue.png"
                    }
                }
            }
        }
    }

    ListModel {
        id: nameModel

    }
    Connections{
        target: trackModel
        onListReady: createListModel()
    }

    function createListModel(){
        for(var i=0; i< trackModel.count(); ++i){
           nameModel.append({"title": trackModel.titleAt(i),
                            "artist": trackModel.artistAt(i),
                            "path" : trackModel.pathAt(i),
                            "image": trackModel.imageAt(i)});
        }
    }
}
