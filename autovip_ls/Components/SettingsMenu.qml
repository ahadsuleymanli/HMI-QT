import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import ck.gmachine 1.0

Rectangle{
            color:"#99000000"
            width: 246
            height:360
            ColumnLayout
            {
                width:parent.width
                height:parent.height
                LeftButton{
                   text: qsTr("General") + mytrans.emptyString
                   onClicked: {
                       GSystem.state = "GeneralSettings";
                       GSystem.changePage("GeneralSettings");
                   }
                }
                LeftButton{
                   text: qsTr("Media") + mytrans.emptyString
                   onClicked: {
                       GSystem.state = "MediaSettings";
                       GSystem.changePage("MediaSettings");
                   }
                }

                LeftButton{
                   text: qsTr("Serial") + mytrans.emptyString
                   onClicked: {
                       GSystem.state = "SerialSettings";
                       GSystem.changePage("SerialSettings");
                   }
                }

            }
}
