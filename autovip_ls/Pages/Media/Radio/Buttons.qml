import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import "../Radio"
Item {
    id: root
//    property alias numpad: numpad
    property alias numpadEmptyMousearea: numpadEmptyMousearea
    readonly property int btnLongTextSize: 18
    property int numpadNumWhole: -1
    property int numpadNumFraction: -1
    property bool numpadPointPressed: false

    MouseArea{
        id:numpadEmptyMousearea
        anchors.top: numpad.top
        anchors.left: numpad.left
        anchors.topMargin: -30
        anchors.leftMargin: - 40
        width: numpad.width + 60
        height:numpad.height + 70
//        Rectangle{anchors.fill: parent;color: "red";opacity: 0.5;}
    }
    FavoritesPane{
        id:favoritesPane
        visible: false
        anchors{
            top:parent.top
            topMargin: -9
            bottomMargin: -8
            bottom: parent.bottom
            left: parent.left
            right: numpad.right

        }


    }
    GridLayout {
        id: numpad
        x:42 - 4
        height: 280 + 8
        width: 395 + 28
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 2
        columns: 3
        function numPadInput(num){
            if (numpadPointPressed){
                root.numpadNumFraction=num;
                frequencyText.textAnimation.restart()
            }else{
                frequencyText.textAnimation.restart()
                if (root.numpadNumWhole==-1){
                    root.numpadNumWhole=num;
                }
                else if (root.numpadNumWhole<10){
                    root.numpadNumWhole*=10;
                    root.numpadNumWhole+=num;
                }
                else if (root.numpadNumWhole<100){
                    root.numpadNumWhole*=10;
                    root.numpadNumWhole+=num;
                    if (root.numpadNumWhole>maxFrequency)
                        root.numpadNumWhole=maxFrequency
                }
            }

        }
        NumpadButton{number: 1}
        NumpadButton{number: 2}
        NumpadButton{number: 3}
        NumpadButton{number: 4}
        NumpadButton{number: 5}
        NumpadButton{number: 6}
        NumpadButton{number: 7}
        NumpadButton{number: 8}
        NumpadButton{number: 9}
        Button{text.text: ".";
            mouseArea.onPressed: {
                pressed=true;
                numpadPointPressed=true
                frequencyText.textAnimation.restart()
            }
        }
        NumpadButton{number: 0}
        Button{text.text: "ENTER"; text.font.pixelSize:root.btnLongTextSize;
            mouseArea.onPressed: {
            pressed=true;
            display.numpadEnterPressed()
            }
        }
    }
    ColumnLayout {
        id: centerBtns
        x:505
        height: 220
        width: 275
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 8
        property int btnWidth: 72 //86
        property int btnHeight: 72
        RowLayout{
            height: centerBtns.btnHeight
            Layout.alignment:Qt.AlignHCenter
            Layout.fillWidth: children
            Button{width: centerBtns.btnWidth;height: centerBtns.btnHeight;image.source:"qrc:/design/media/Radio/c.png"
                mouseArea.onPressed: {pressed=true;/*frequencySlider.increment(-0.1);*/resetFrequencyEditing();
                    serial_mng.sendKey("radio/channel_preceding",true,serialDelay);
                }
//                mouseArea.onPressAndHold: {pressedelayd=true;frequencySlider.autoIncrement(-0.2);}
                mouseArea.onReleased: {pressed=false;/*frequencySlider.autoIncrement(0);*/}
            }
            Item{width: centerBtns.btnWidth;height: centerBtns.btnHeight;}
            Button{width: centerBtns.btnWidth;height: centerBtns.btnHeight;image.source:"qrc:/design/media/Radio/d.png"
                mouseArea.onPressed: {pressed=true;resetFrequencyEditing();
                    serial_mng.sendKey("radio/channel_next",true,serialDelay);
                }
//                mouseArea.onPressAndHold: {pressed=true;frequencySlider.autoIncrement(0.2);}
                mouseArea.onReleased: {pressed=false;/*frequencySlider.autoIncrement(0);*/}
            }
        }
        RowLayout{
            height: centerBtns.btnHeight
            Layout.fillWidth: children
            Layout.alignment:Qt.AlignHCenter
            Button{width: centerBtns.btnWidth;height:centerBtns.btnHeight;image.source:"qrc:/design/media/Radio/fav.png"
                mouseArea.onPressed: {pressed=true;resetFrequencyEditing();}
                mouseArea.onReleased: {pressed=false;}
                mouseArea.onClicked: {SM.datafileAddRadioStation(frequencySlider.frequency.toFixed(1));favoritesPane.favoritesUpdated();}
            }
        }
        RowLayout{
            height: centerBtns.btnHeight
            Layout.alignment:Qt.AlignHCenter
            Layout.fillWidth: children
            Button{width: centerBtns.btnWidth; height:centerBtns.btnHeight;image.source:"qrc:/design/media/Radio/a.png"
                mouseArea.onPressed: {pressed=true;resetFrequencyEditing();favoritesPane.previousPreset();}
                mouseArea.onReleased: {pressed=false;}
            }
            Item{width: centerBtns.btnWidth;height:centerBtns.btnHeight;}
            Button{width: centerBtns.btnWidth;height:centerBtns.btnHeight;image.source:"qrc:/design/media/Radio/b.png"
                mouseArea.onPressed: {pressed=true;resetFrequencyEditing();favoritesPane.nextPreset();}
                mouseArea.onReleased: {pressed=false;}
            }
        }
    }

    ColumnLayout {
        id: rightColumn
        x:844
        height: 280 + 8
        width: 122
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 2

        Item {height: 60; width: 120;
            Button{id:fmButton;text.text: "FM";text.font.pixelSize:root.btnLongTextSize;visible: false}
        }
        Item {height: 60; width: 120;
            Button{id:amButton;height: 60; width: 120; text.text: "AM";text.font.pixelSize:root.btnLongTextSize; visible: false;}
        }
        Item {height: 60; width: 120;
            Button{id:dabButton;height: 60; width: 120; text.text: "DAB";text.font.pixelSize:root.btnLongTextSize; visible: false;}
        }
        Item {height: 60; width: 120;
            Button{text.text: "PRESETS" ;text.font.pixelSize:root.btnLongTextSize;
                mouseArea.onPressed: {pressed=true;resetFrequencyEditing();}
                mouseArea.onReleased: {pressed=false;favoritesPane.visible=!favoritesPane.visible;numpad.visible=!numpad.visible;}
            }
        }
    }
    Item {
        id: powerBtn
        x:844
        height: 280 + 8
        width: 122
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 2
        Item {height: 72; width: 72;anchors.top: parent.top;anchors.right: parent.right;
            Button{id:onOffButton;height: parent.height; width: parent.width;image.source:"qrc:/design/media/Radio/Power.png";/*text.text: serial_mng.radioPlaying?"OFF":"ON";text.font.pixelSize:root.btnLongTextSize;*/
                mouseArea.onPressed: {pressed=true;resetFrequencyEditing();serial_mng.radioPlaying=!serial_mng.radioPlaying;}
                mouseArea.onReleased: {pressed=false;}
            }
        }
    }

    Component.onCompleted: {
        fmButton.setInactive()
        amButton.setInactive()
        dabButton.setInactive()
        //enable disable buttons here
    }

}

