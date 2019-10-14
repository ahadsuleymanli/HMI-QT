import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import ck.gmachine 1.0
import "../../Components"
import QtGraphicalEffects 1.0

BasePage {
    id:root
    caption:qsTr("CONTROLS") + mytrans.emptyString
    pageName: "Controls"
    property alias leftMenu: leftMenu

        LeftMenu{
            id:leftMenu
        }
        AniCogWheel{
            anchors.centerIn: root
            width:200
            height: 200
        }

      Component.onCompleted: {
        GSystem.createControlsModel();
        leftMenu.model = GSystem.controlsModel;
       }
}
