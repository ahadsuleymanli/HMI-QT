import QtQuick 2.4
HomeForm {


    durationText.text : audioDurationStr
    currentPositionText.text: audioPositionStr
    property bool progressAreaPressed: false
    function adjustedProgressAreaMouseX(){
        if (progressArea.mouseX<0)
            return 0;
        else if (progressArea.mouseX>progressArea.width)
            return progressArea.width;
        else
            return progressArea.mouseX;
    }

    progressCurrent.width: progressAreaPressed? adjustedProgressAreaMouseX()
                             :(mPlayerBackend.duration>0?mPlayerBackend.position/mPlayerBackend.duration:0) * progressBackground.width

    infoLayout.visible: (infoTitle.text === "" ? false : true)
    infoTitle.text: mPlayerBackend.playingTitle
    infoYear.text: (mPlayerBackend.playingYear === "" ? "" : ("("+mPlayerBackend.playingYear+")"))
    infoArtist.text : (mPlayerBackend.playingArtist === "" ? "unknown" : mPlayerBackend.playingArtist)
    coverImage.source: (mPlayerBackend.playingCover === "" ? "qrc:/design/media/MediaPlayer/melody.png":
                                                             mPlayerBackend.playingCover)
    playPauseImage.source:(mPlayerBackend.state === 2 ? "qrc:/design/media/MediaPlayer/pause.png":
                                                                "qrc:/design/media/MediaPlayer/2.png")
    repeatImage.source: (mPlayerBackend.loop===2 ? "qrc:/design/media/MediaPlayer/repeat_1.png": mPlayerBackend.loop===1 ? "qrc:/design/media/MediaPlayer/repeat_all.png": "qrc:/design/media/MediaPlayer/repeat.png")

    shuffleImageToggled: mPlayerBackend.shuffle
    repeatImageToggled: mPlayerBackend.loop > 0

    progressArea.onReleased: {
        mPlayerBackend.position = mPlayerBackend.duration*(adjustedProgressAreaMouseX()/progressArea.width)
        progressAreaPressed = false;
    }
    progressArea.onPressed: {
        progressAreaPressed = true;
    }

    shuffleButton.onReleased: {
        mPlayerBackend.setShuffle();
    }

    repeatButton.onReleased: {
        mPlayerBackend.setLoop()
    }

    playPauseButton.onReleased: {
        mPlayerBackend.playPause()

    }

    prewButton.onReleased: {
        mPlayerBackend.previous()
    }

    nextButton.onReleased: {
        mPlayerBackend.next()
    }



}
