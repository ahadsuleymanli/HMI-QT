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
    property ListModel mediaModel: GSystem.mediaModel

    AniMedia{
         anchors{
             horizontalCenter: parent.horizontalCenter
             top: parent.top
             topMargin: 140
         }
         width: 140
         height: 140
         running: root.visible
     }
    Item{
        anchors.fill: parent
        anchors.topMargin: 250
        anchors.leftMargin: 10
        anchors.bottomMargin: 120

        GridView{
            id: mediaView
            anchors.fill : parent
            model: root.mediaModel
            cellWidth: 200
            cellHeight: 200
            clip: true

            delegate: Item{
                width: mediaView.cellWidth
                height: mediaView.cellHeight
                LeftButton{
                   id:wrapper
                   anchors.fill: parent
                   bgsource: bg
                   text :qsTr(name) + mytrans.emptyString
                   onClicked: {
                        GSystem.state = name;
                        GSystem.changePage(st);
                    }
                }
            }
        }
    }

   Component.onCompleted: {
            GSystem.createMediaModel();
            root.mediaModel = GSystem.mediaModel;
   }

}
