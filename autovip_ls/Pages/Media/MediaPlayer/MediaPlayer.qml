import QtQuick 2.11
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtMultimedia 5.11
import QtQuick.Controls.Material 2.3
import ck.gmachine 1.0
import "../../../Components"
import QtGraphicalEffects 1.0

BasePage {
    id:root
    caption: qsTr("MEDIA PLAYER") + mytrans.emptyString
    pageName: "MediaPlayer"
    property int musicPlayerSoundSource
    property string audioPositionStr: {
        var pos = mPlayerBackend.position
        var posMin = Math.floor(pos / 60)
        var posSec = Math.floor(pos / 1 - posMin * 60)
        return posMin + ":" + (posSec < 10 ? "0" + posSec : posSec);
    }
    property string audioDurationStr: {
        var durMin = Math.floor(mPlayerBackend.duration / 60)
        var durSec = Math.floor(mPlayerBackend.duration / 1 - durMin * 60)
        return durMin + ":" + (durSec < 10 ? "0" + durSec : durSec);
    }
    Component.onCompleted: {
        if (SM.bganim()){
            backgroundImage.visible=false
        }else{
            backgroundImage.visible=true
            backgroundImage.source ="qrc:/design/media/MediaPlayer/background.png"
        }
        musicPlayerSoundSource = 3;
    }
    function init()
    {
        if (SM.ampInput()){
            serial_mng.sendRadioOff();
        }
        else
            serial_mng.sendSoundSource(musicPlayerSoundSource);

    }
    RowLayout{
        id: mainLayout
        anchors{
            fill: parent
            topMargin: root.contentTopMargin
            bottomMargin: root.contentBottomMargin
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
//                anchors.centerIn: parent

            }
//            Canvas{
//                id: drawingCanvas
//                anchors.fill: parent
//                onPaint:
//                {
//                    var ctx = getContext("2d")

//                    // create a triangle as clip region
//                    ctx.beginPath()
//                    ctx.moveTo(0, 42)
//                    ctx.lineTo(230, 42)
//                    ctx.lineTo(266,0)
//                    ctx.lineTo(drawingCanvas.width,0)
//                    ctx.lineTo(drawingCanvas.width, drawingCanvas.height)
//                    ctx.lineTo(0, drawingCanvas.height)
//                    ctx.lineTo(0, 42)
//                    ctx.closePath()
//                    // translate coordinate system
//                    ctx.clip()  // create clip from the path
//                    // draw image with clip applied
//                    ctx.drawImage('qrc:/design/media/MediaPlayer/background.png', -30, -240)
//                    // draw stroke around path
//                    // restore previous context
//                    ctx.restore()
//                }
//            }
            Loader{
                id: formLoader
                anchors.fill: parent
                source:"Home.qml"
                property string sourceName: "Home.qml"
                function setSource(source_){
                    sourceName = source_
                    source = source_
                }
            }
        }
        Rectangle{
            id: menuBar
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
                Item{
                    Layout.fillWidth: true
                    height: row.height
                    RowLayout{
                        id: row
                        width: childrenRect.width
                        height: childrenRect.height
                        Image{
                            id:homeImage
                            Layout.alignment: Qt.AlignVCenter
                            sourceSize.width: 32
                            sourceSize.height: 32
                            source: "qrc:/design/media/MediaPlayer/home.png"
                        }
                        Text{
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                            text: qsTr("Home")
                            color: "#a5a5a7"
                            font.pixelSize: 20
                        }

                    }
                    Rectangle {
                        id:homeButtonClickEffect
                        anchors.fill: parent
                        anchors.leftMargin: -6
                        radius: 6
                        z:-1
                        color:  "#447b8b8b"
                        visible: homeArea.pressed
                    }
                    MouseArea{
                        id: homeArea
                        anchors.fill: parent
                        anchors.margins: -8
                        onPressed: {if (formLoader.sourceName=="Home.qml") notAvailableAnimation.start();}
                        onReleased: formLoader.setSource("Home.qml")
                    }
                }
                RowLayout{
                    opacity: 0
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
                    opacity: 0
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
                    height: 50
                }
                Text {
                    Layout.leftMargin: 3
                    text: qsTr("Playlist")
                    color: "#a5a5a7"
                    font.pixelSize: 25
                }
                Item{
                    Layout.fillWidth: true
                    height: libraryRow.height
                    RowLayout{
                        id:libraryRow
                        width: childrenRect.width
                        height: childrenRect.height
                        Image{
                            Layout.alignment: Qt.AlignVCenter
                            sourceSize.width: 32
                            sourceSize.height: 32
                            source: "qrc:/design/media/MediaPlayer/library.png"
                        }
                        Text{
                            Layout.alignment: Qt.AlignVCenter
                            text: qsTr("My Library")
                            color: "#a5a5a7"
                            font.pixelSize: 20
                        }
                    }
                    Rectangle {
                        anchors.fill: parent
                        anchors.leftMargin: -6
                        z:-1
                        radius: 6
                        color: "#447b8b8b"
                        visible: libraryArea.pressed
                    }
                    MouseArea{
                        id: libraryArea
                        anchors.fill: parent
                        anchors.margins: -8
                        onReleased: formLoader.sourceName=="Library.qml"?formLoader.setSource("Home.qml"):formLoader.setSource("Library.qml")
                    }
                }


                RowLayout{
                    Layout.fillWidth: true
                    height: childrenRect.height
                    opacity: 0
                    Image{
                        Layout.alignment: Qt.AlignVCenter
                        sourceSize.width: 32
                        sourceSize.height: 32
                        source: "qrc:/design/media/MediaPlayer/favorite_song.png"
                    }
                    Text{
                        Layout.alignment: Qt.AlignVCenter
                        text: qsTr("Favorite Songs")
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
