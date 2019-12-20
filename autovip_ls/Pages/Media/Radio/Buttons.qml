import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import "../Radio"
Item {
    id: root
    y:227
    x:0
    height: parent.height - 227 - 8
    width: parent.width
    property int btnLongTextSize: 18
    GridLayout {
        id: numpad
        x:42 - 4
        height: 280 + 8
        width: 395 + 28
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 2
        columns: 3
        NumpadButton{text.text: "1"}
        NumpadButton{text.text: "2"}
        NumpadButton{text.text: "3"}
        NumpadButton{text.text: "4"}
        NumpadButton{text.text: "5"}
        NumpadButton{text.text: "6"}
        NumpadButton{text.text: "7"}
        NumpadButton{text.text: "8"}
        NumpadButton{text.text: "9"}
        NumpadButton{text.text: "."}
        NumpadButton{text.text: "0"}
        Button{text.text: "ENTER"; text.font.pixelSize:root.btnLongTextSize}
    }
    ColumnLayout {
        id: centerBtns
        x:505
        height: 220
        width: 275
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 8
        property int btnWidth: 86
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
        height: 280
        width: 122
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 2
        Item{height: 60; width: 120;}
        Item{height: 60; width: 120;}
        Item{height: 60; width: 120;}
        Button{text.text: "PRESETS" ;text.font.pixelSize:root.btnLongTextSize;}
    }


    RowLayout{
        visible: false
        id: buttonsRowLayout
        y:227
        x:0
        height: parent.height - 227 - 8
    //            width: children.width
        width: parent.width
    //            Layout.leftMargin: 50
    //            Layout.rightMargin: 50
    //            anchors.horizontalCenter: parent.horizontalCenter
        Rectangle {

            x:100
    //                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
    //                anchors.centerIn: parent
            width: 395
            height: 227
            color: "#550000ff"
    //                visible: false
        }
        spacing: 6
    }

}

