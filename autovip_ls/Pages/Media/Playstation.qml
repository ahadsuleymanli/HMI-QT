import QtQuick 2.4
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import ck.gmachine 1.0
import "../../Components"

BasePage {
    id:root
    caption: qsTr("PLAYSTATION") + mytrans.emptyString
    pageName: "Playstation"
    Image{
        source:"qrc:/design/media/ikon-PS4.svg"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        sourceSize.width: 400
        sourceSize.height: 400
        MouseArea{
            anchors.fill: parent
            onClicked: {
                serial_mng.sendKey("media/play_station");
            }
        }
    }

}
