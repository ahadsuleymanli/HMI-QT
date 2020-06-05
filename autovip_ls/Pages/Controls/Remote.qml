import QtQuick 2.4
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import ck.gmachine 1.0
import "../../Components"
BasePage {
    id:root
    caption: qsTr("Streamer") + mytrans.emptyString
    pageName: "Streamer"
    function init(){
        serial_mng.sendKey("switcher/iptv1");
        serial_mng.sendKey("switcher/iptv2");
    }
    Rectangle{
        anchors.fill: root
        color: "gray"
        opacity: 0.1
    }
    Item {
        anchors.top: contentTopMargin
        Loader{
            anchors.fill: parent
            id: formLoader
            source:"Remote_ui.qml"
        }
    }

}




