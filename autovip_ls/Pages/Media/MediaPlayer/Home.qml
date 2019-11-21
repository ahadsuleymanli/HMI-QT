import QtQuick 2.4

HomeForm {


    durationText.text : audioDurationStr
    currentPositionText.text: audioPositionStr
    progressCurrent.width: positionRatio * progressBackground.width

    infoLayout.visible: (infoTitle.text === "" ? false : true)
    infoTitle.text: mPlayerBackend.playingTitle
    infoYear.text: (mPlayerBackend.playingYear === "" ? "" : ("("+mPlayerBackend.playingYear+")"))
    infoArtist.text : (mPlayerBackend.playingArtist === "" ? "unknown" : mPlayerBackend.playingArtist)
    coverImage.source: (mPlayerBackend.playingCover === "" ? "qrc:/design/media/MediaPlayer/melody.png":
                                                             mPlayerBackend.playingCover)
    playPauseImage.source:(mPlayerBackend.state === 1 ? "qrc:/design/media/MediaPlayer/pause.png":
                                                                "qrc:/design/media/MediaPlayer/2.png")
    progressArea.onMouseXChanged:{
        var pos = Math.min(mPlayerBackend.duration*(progressArea.mouseX/progressArea.width),mPlayerBackend.duration-50)
        mPlayerBackend.setPosition(pos)
    }

    shuffleButton.onClicked: mPlayerBackend.setShuffle()


    playPauseButton.onClicked: {
        mPlayerBackend.playPause()

    }

    prewButton.onClicked: {
        mPlayerBackend.previous()
    }

    nextButton.onClicked: {
        mPlayerBackend.next()
    }
    repeatButton.onClicked: {

    }


}
