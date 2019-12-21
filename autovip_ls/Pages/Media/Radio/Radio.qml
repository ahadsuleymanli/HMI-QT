import QtQuick 2.11
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4
import QtGraphicalEffects 1.0
import QtQuick.Extras 1.4
import "../../../Components"
import "../Radio"

BasePage {
    caption: qsTr("RADIO") + mytrans.emptyString
    property real minFrequency:87.5
    property real maxFrequency:108.0
    pageName: "Radio"
    Component.onCompleted: {

    }
    Item {
        id: raioArea
        x: 0
        y: contentTopMargin
        height: parent.height - y - contentBottomMargin
        width: parent.width
        Image{
            id: bg
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            height: parent.height
            source:"qrc:/design/media/Radio/background.png"
        }
        Item {
            id:display
            x:10
            y:8
            height: 210
            width: 1004
            signal numpadEnterPressed()
            onNumpadEnterPressed: {
                frequencySlider.frequency=frequencyText.getFreqText()
                frequencyText.wholePartAnimation.stop()
                frequencyText.fractionPartAnimation.stop()
                buttons.pointPressed=false
                buttons.numpadNumWhole=0
                buttons.numpadNumFraction=0
            }
            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/design/media/Radio/equalizer.png"
            }
            FrequencySlider {
                id: frequencySlider
                anchors.fill: parent
                anchors.leftMargin: 21
                anchors.rightMargin: 21
            }
            FrequencyText{
                id: frequencyText
                anchors.fill: parent
            }
            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                height: 22
                width: parent.width - 48
                source: "qrc:/design/media/Radio/frequency2.png"
            }
            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: -1
                height: 43
                source: "qrc:/design/media/Radio/line.png"
            }
        }
        Buttons{
            id:buttons
            y:227
            x:0
            height: parent.height - 227 - 8
            width: parent.width

        }
    }

}
