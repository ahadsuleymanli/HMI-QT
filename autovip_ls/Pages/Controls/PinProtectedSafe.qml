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
            color: "#aa383838"
            border.color: "#88ff3838"
            border.width: 4
            visible: !passwordChangeArea.visible

            ColumnLayout{
                anchors.bottom: parent.bottom
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
                        extraBtn2.opacity=0;
                        extraBtn3.visible=true;
                        extraBtn3.text.text=qsTr("Change Pin");
                    }
                    extraBtn0.mouseArea.onPressed: {
                        pinTextField.backspace();
                    }
                    extraBtn3.mouseArea.onReleased: {
                        passwordChangeArea.visible=true;
                    }
                }
            }
        }
        Rectangle{
            id:passwordChangeArea
            anchors.centerIn: parent
            height: 380 + 80
            width: 500
            color: "#cc303030"
            border.color: "#88ff3838"
            border.width: 4
            property int selectedField: -1
            visible: false
            RowLayout{
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 25
                spacing: 20
                PasswordField{
                    id:oldPinField
                    bgRectangle.visible: true
                    pwFieldId:0
                    onPressed: passwordChangeArea.selectedField=pwFieldId
                    Text {
                        text: qsTr("Old Pin")+":"
                        anchors.bottom: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: "white"
                    }
                }
                PasswordField{
                    id:newPinField
                    bgRectangle.visible: true
                    pwFieldId:1
                    onPressed: passwordChangeArea.selectedField=pwFieldId
                    Text {
                        text: qsTr("New Pin")+":"
                        anchors.bottom: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: "white"
                    }

                }
                PasswordField{
                    id:newPinField2
                    bgRectangle.visible: true
                    pwFieldId:2
                    onPressed: passwordChangeArea.selectedField=pwFieldId
                    Text {
                        text: qsTr("New Pin")+"2:"
                        anchors.bottom: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: "white"
                    }

                }

            }
            Numpad{
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter
                id: pwChangeNumpad
                onNumpadPressed: {
                    if (passwordChangeArea.selectedField===0)
                        oldPinField.enterPin(key);
                    else if (passwordChangeArea.selectedField===1)
                        newPinField.enterPin(key);
                    else if (passwordChangeArea.selectedField===2)
                        newPinField2.enterPin(key);
                }
                Component.onCompleted: {
                    extraBtn0.visible=true;
                    extraBtn0.text.text=qsTr("Del");
                    extraBtn1.visible=true;
                    extraBtn1.opacity=0;
                    extraBtn2.visible=true;
                    extraBtn2.text.text=qsTr("Apply");
                    extraBtn2.text.font.pixelSize=18;
                    extraBtn3.visible=true;
                    extraBtn3.text.text=qsTr("Back");
                    enterButton.setDisabled();
                }
                extraBtn0.mouseArea.onPressed: {
                    if (passwordChangeArea.selectedField===0)
                        oldPinField.backspace();
                    else if (passwordChangeArea.selectedField===1)
                        newPinField.backspace();
                    else if (passwordChangeArea.selectedField===2)
                        newPinField2.backspace();

                }
                extraBtn2.mouseArea.onPressed: {
                    if (oldPinField.text===authScreen.correctPin){
                        if (newPinField.text.length<4){
                            passwordChangeNotification.notifyFailure(qsTr("Pin has to be at least 4 characters long!"));
                        }
                        else if (newPinField.text===newPinField2.text){
                            SM.datafileSetSafePin(newPinField.text);
                            passwordChangeNotification.notifySuccess(qsTr("Pin has been successfully changed!"));
                            passwordChangeArea.visible=false;
                        }
                        else{
                            passwordChangeNotification.notifyFailure(qsTr("New Pins do not match."));
                        }
                    }else{
                        passwordChangeNotification.notifyFailure(qsTr("Old Pin was not entered correctly."));
                    }
                    oldPinField.text = "";
                    newPinField.text = "";
                    newPinField2.text = "";
                }
                extraBtn3.mouseArea.onReleased: {
                    passwordChangeArea.visible=false;
                }
            }
            onVisibleChanged: {
                oldPinField.text = newPinField.text = newPinField2.text = "";
                selectedField = -1;
                oldPinField.activeFocusOnPress = false;
                newPinField.activeFocusOnPress = false;
                newPinField2.activeFocusOnPress = false;

            }

        }
        Rectangle{
            id:passwordChangeNotification
            visible: false
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            width: 600
            height: 300
            border.width: 2
            color: "#ff303030"
            border.color: "gray"
            function notifySuccess(text){
                border.color= "green"
                notificationText.color="green"
                notificationText.text=text;
                visible=true;
            }
            function notifyFailure(text){
                border.color= "gray"
                notificationText.color="red"
                notificationText.text=text;
                visible=true;
            }

            onVisibleChanged:{
                if (visible===false)
                    passwordChangeArea.enabled=true
                else if (visible===true)
                    passwordChangeArea.enabled=false
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 20
                id: notificationText
                text: ""
                font.pixelSize: 30
                color: "white"
            }
            Button{
                anchors.bottom: parent.bottom;
                anchors.right: parent.right;
                anchors.margins: 4
                border.color: passwordChangeNotification.border.color
                id:backButton; text.text: qsTr("Back"); text.font.pixelSize:18;mouseArea.onReleased: passwordChangeNotification.visible=false;}

        }
        Component.onCompleted: {
            authScreen.correctPin = SM.datafileGetSafePin();
        }
    }
    function init(){
        pinTextField.text = "";
    }

}
