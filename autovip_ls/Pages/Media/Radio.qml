import QtQuick 2.0
import QtQuick.Layouts 1.1
import "../../Components"

BasePage {
    id:root
    caption:qsTr("RADIO FM") + mytrans.emptyString
    ColumnLayout{
        anchors.fill: parent
        anchors.bottomMargin: 100
        anchors.topMargin: 160
        Rectangle{
            Layout.fillWidth: true
            height: 100
        }
        Rectangle{
            Layout.fillWidth: true
            height: 100
        }
        Rectangle{
            Layout.fillWidth: true
            height: 100
        }
        Rectangle{
            Layout.fillWidth: true
            height: 100
        }
    }
}
