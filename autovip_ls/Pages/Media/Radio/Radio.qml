import QtQuick 2.11
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4
import QtGraphicalEffects 1.0
import QtQuick.Extras 1.4
import "../../../Components"
import "../Radio"
import ck.gmachine 1.0

BasePage {
    id:root
    caption: qsTr("RADIO") + mytrans.emptyString
    pageName: "Radio"
    property real minFrequency:87.5
    property real maxFrequency:108.0
    property int serialDelay: -1
    property int previousSoundSource: 2

    Component.onCompleted: {
    }
    function init()
    {
        mPlayerBackend.pause();
        if (serial_mng.soundSource!==1)
            previousSoundSource=serial_mng.soundSource;
        serial_mng.sendSoundSource(1);
    }
    function resetFrequencyEditing(){
        frequencyText.textAnimation.stop()
        buttons.numpadPointPressed=false
        buttons.numpadNumWhole=-1
        buttons.numpadNumFraction=-1
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
        MouseArea{
            id:emptyMousearea
            anchors.fill: parent
            onPressed: root.resetFrequencyEditing()
        }
        Buttons{
            id:buttons
            y:227
            x:0
            height: parent.height - 227 - 8
            width: parent.width
        }
        Item {
            id:display
            x:10
            y:8
            height: 210
            width: 1004
            signal numpadEnterPressed()
            onNumpadEnterPressed: {
                frequencySlider.setFrequency(frequencyText.getFreqText())
                root.resetFrequencyEditing()
            }
            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/design/media/Radio/equalizer.png"
            }
            FrequencySlider {
                id: frequencySlider
                anchors.fill: parent

            }
            FrequencyText{
                id: frequencyText
                anchors.fill: parent
            }

        }

    }

}
