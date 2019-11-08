import QtQuick 2.4

HomeForm {
    durationText.text : audioDurationStr
    currentPositionText.text: audioPositionStr
    progressCurrent.width: positionRatio * progressBackground.width

    infoTitle.text: mPlayerBackend.playingTitle
    infoYear.text: (mPlayerBackend.playingYear === "" ? "" : ("("+mPlayerBackend.playingYear+")"))
    infoArtist.text : (mPlayerBackend.playingArtist === "" ? "unknown" : mPlayerBackend.playingArtist)
    coverImage.source: (mPlayerBackend.playingCover === "" ? "qrc:/design/media/MediaPlayer/melody.png":
                                                             mPlayerBackend.playingCover)


    shuffleButton.onClicked: mPlayerBackend.shuffle()

    playPauseButton.onClicked: mPlayerBackend.play()

    prewButton.onClicked: {
        mPlayerBackend.previous()
    }

    nextButton.onClicked: {
        mPlayerBackend.next()
    }
    backButton.onClicked: {

    }
    Component.onCompleted: {

    }
}
