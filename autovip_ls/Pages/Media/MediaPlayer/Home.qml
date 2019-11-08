import QtQuick 2.4

HomeForm {
    durationText.text : audioDurationStr
    currentPositionText.text: audioPositionStr
    progressCurrent.width: positionRatio * progressBackground.width

    infoTitle.text: mPlayerBackend.playingTitle

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
