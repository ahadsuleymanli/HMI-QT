import QtQuick 2.4
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import ck.gmachine 1.0
//import QtQuick.Controls.Styles 1.4

TextField {
    id:root
    font.pixelSize: 30
    text: ""
    echoMode: TextInput.Password
    readOnly: true
    color: wrongPinAnimation.running? "#88ff0000":"#ffffffff"
    horizontalAlignment: TextInput.AlignHCenter
    property alias wrongPinAnimation: wrongPinAnimation
    property alias bgRectangle: bgRectangle
    property int pinMaxLength: 8
    property int pwFieldId: -1
    function enterPin(key){
        if (text.length<pinMaxLength){text += key;}
    }
    function backspace(){
        if (text.length>0){text=text.slice(0,text.length-1)}
    }
    Rectangle{
        id:bgRectangle
        visible: false
        anchors.fill: parent
        anchors.topMargin: 5
        anchors.leftMargin: -2
        anchors.rightMargin: -2
        z:-1
        radius: 2
        color: "#88999999"
        border.color: "#44ff0000"
        border.width: 1
    }

    NumberAnimation{
        id: wrongPinAnimation
        target: root
        properties: "Layout.leftMargin"
        from:-40
        to:40
        duration:100
        running: false
        alwaysRunToEnd:true
        loops: 3
        onRunningChanged: if (running==false) root.Layout.leftMargin = 0;
    }
}
