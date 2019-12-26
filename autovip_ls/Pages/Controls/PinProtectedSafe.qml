import QtQuick 2.4
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import ck.gmachine 1.0
import "../../Components"
import "../../Components/Numpad"
BasePage {
    id:root
    caption: qsTr("Pin Protected Safe") + mytrans.emptyString
    pageName: "PinProtectedSafe"
    Image{
        id:safeBox
        enabled: !authScreen.visible
        x:0
        y:0
        width:parent.width
        height:parent.height
        LeftTextMenu{id: leftMenu; model: tmodel}
        ListModel{
            id: tmodel
            ListElement{
                name: qsTr("Open")
                beforecode:"controls/espresso_open"
            }
            ListElement{
                name: qsTr("Close")
                beforecode:"controls/espresso_close"
            }
        }
        Image{
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter:  parent.horizontalCenter
            height: 329
            fillMode: Image.PreserveAspectFit
            source:"qrc:/design/controls/safebox.svg"
        }
        }

    Rectangle {
        id: authScreen
        visible: true
        anchors.fill: parent
        anchors.topMargin: contentTopMargin
        anchors.bottomMargin: contentBottomMargin
        color: "#88000000"
        Rectangle{
            id:passwordPromptArea
            anchors.centerIn: parent
            height: 380
            width: 500
            color: "#ff383838"
            border.color: "#88ff3838"
            border.width: 4
            ColumnLayout{
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottomMargin: 20
                TextField {
                    Layout.alignment: Qt.AlignHCenter
                    id:pinTextField
                    placeholderText: qsTr("pin")
                }
                RowLayout{

                }
                Numpad{
                    id: numpad
                    onNumpadPressed: pinTextField.text = key;
//                    height: 275
//                    width: 390
                }
            }

        }
    }
}
