import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import "../Radio"
Item {
    id: root
//    y:227
//    x:0
//    height: parent.height - 227 - 8
//    width: parent.width
    readonly property int btnLongTextSize: 18
    property int numpadNumWhole: 0
    property int numpadNumFraction: 0
    property bool pointPressed: false
    signal numpadEnterPressed
    GridLayout {
        id: numpad
        x:42 - 4
        height: 280 + 8
        width: 395 + 28
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 2
        columns: 3
        function numPadInput(num){
            if (pointPressed){
                root.numpadNumFraction=num;
            }
            else if (root.numpadNumWhole==0){
                root.numpadNumWhole=num;
            }
            else if (root.numpadNumWhole<10){
                root.numpadNumWhole*=10;
                root.numpadNumWhole+=num;
            }
            else if (root.numpadNumWhole<100){
                root.numpadNumWhole*=10;
                root.numpadNumWhole+=num;
            }
            console.log(numpadNumWhole + "." + numpadNumFraction)
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
                pointPressed=true
            }
        }
        NumpadButton{number: 0}
        Button{text.text: "ENTER"; text.font.pixelSize:root.btnLongTextSize}
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
            Button{width: centerBtns.btnWidth;height: centerBtns.btnHeight;image.source:"qrc:/design/media/Radio/c.png"}
            Item{width: centerBtns.btnWidth;height: centerBtns.btnHeight;}
            Button{width: centerBtns.btnWidth;height: centerBtns.btnHeight;image.source:"qrc:/design/media/Radio/d.png"}
        }
        RowLayout{
            height: centerBtns.btnHeight
            Layout.fillWidth: children
            Layout.alignment:Qt.AlignHCenter
            Button{width: centerBtns.btnWidth;height:centerBtns.btnHeight;image.source:"qrc:/design/media/Radio/fav.png"}
        }
        RowLayout{
            height: centerBtns.btnHeight
            Layout.alignment:Qt.AlignHCenter
            Layout.fillWidth: children
            Button{width: centerBtns.btnWidth; height:centerBtns.btnHeight;image.source:"qrc:/design/media/Radio/a.png"}
            Item{width: centerBtns.btnWidth;height:centerBtns.btnHeight;}
            Button{width: centerBtns.btnWidth;height:centerBtns.btnHeight;image.source:"qrc:/design/media/Radio/b.png"}
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
            Button{id:fmButton;text.text: "FM";text.font.pixelSize:root.btnLongTextSize;}
        }
        Item {height: 60; width: 120;
            Button{id:amButton;height: 60; width: 120; text.text: "AM";text.font.pixelSize:root.btnLongTextSize;}
        }
        Item {height: 60; width: 120;
            Button{id:dabButton;height: 60; width: 120; text.text: "DAB";text.font.pixelSize:root.btnLongTextSize;}
        }
        Item {height: 60; width: 120;
            Button{text.text: "PRESETS" ;text.font.pixelSize:root.btnLongTextSize;}
        }




    }


    Component.onCompleted: {
        fmButton.setInactive()
        amButton.setInactive()
        dabButton.setInactive()
        //enable disable buttons here
    }

}

