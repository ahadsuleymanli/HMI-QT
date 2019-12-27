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
        LeftTextMenu{
            id: leftMenu;
            model: tmodel
            onClicked: if (index===1){authScreen.visible=true;}
        }
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
        property string correctPin: ""
        Rectangle{
            id:passwordPromptArea
            anchors.centerIn: parent
            height: 380 + 80
            width: 500
            color: "#ff383838"
            border.color: "#88ff3838"
            border.width: 4
            visible: !passwordChangeArea.visible

            ColumnLayout{
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 20
                anchors.bottomMargin: 20
                PasswordField{
                    id:pinTextField
                    Layout.alignment: Qt.AlignHCenter
                }
                Numpad{
                    id: numpad
                    onNumpadPressed: pinTextField.enterPin(key);
                    onEnterPressed: {
                        if (pinTextField.text===authScreen.correctPin){
                            pinTextField.text = "";
                            authScreen.visible=false;
                        }else{
                            pinTextField.wrongPinAnimation.start();
                        }
                    }
                    Component.onCompleted: {
                        extraBtn0.visible=true;
                        extraBtn0.text.text=qsTr("Del");
                        extraBtn1.visible=true;
                        extraBtn1.opacity = 0;
                        extraBtn2.visible=true;
                        extraBtn2.text.text=qsTr("Change Pin");
                    }
                    extraBtn0.mouseArea.onPressed: {
                        pinTextField.backspace();
                    }
                    extraBtn2.mouseArea.onPressed: {
                        passwordChangeArea.visible=true;
                    }
                }
            }
        }
        Rectangle{
            id:passwordChangeArea
            anchors.centerIn: parent
            height: 380
            width: 500
            color: "#aa383838"
            border.color: "#88ff3838"
            border.width: 4
            visible: false
            ColumnLayout{
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 20
                RowLayout{
                    Layout.alignment: Qt.AlignTop
                    PasswordField{
                        Rectangle{
                            anchors.fill: parent
                            color: "#ff333333"
                            z:-1
                        }
                        id:currentPinField
                    }
                    PasswordField{
                        id:newPinField
                        Rectangle{
                            anchors.fill: parent
                            color: "#ff333333"
                            z:-1
                        }
                    }
                    PasswordField{
                        id:newPinFieldRepeat
                    }
                }



            }
            RowLayout{
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottomMargin: 20
                Button{
                    text.text: qsTr("change");
                    mouseArea.onPressed: {
                    }
                }
                Button{text.text: qsTr("back");mouseArea.onPressed: passwordChangeArea.visible=false;}
            }
        }
        Component.onCompleted: {
            authScreen.correctPin = SM.datafileGetSafePin();
        }
    }
    function init(){
        pinTextField.text = "";
    }

}
