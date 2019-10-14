import QtQuick 2.4
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import ck.gmachine 1.0
import "../../Components"
import QtGraphicalEffects 1.0

BasePage {
    id:root
    caption: qsTr("MEDIA") + mytrans.emptyString
    pageName: "Media"
    Item{
        x:0
        y:0
        width:parent.width
        height:parent.height
        LeftMenu{
            id:leftMenu
        }
        }
   AniMedia{
            anchors.centerIn: root
        }
   Component.onCompleted: {
            GSystem.createMediaModel();
            leftMenu.model = GSystem.mediaModel;
   }

}
