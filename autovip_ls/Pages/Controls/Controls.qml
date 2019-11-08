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
    property ListModel controlsModel: GSystem.controlsModel


    AniCogWheel{
        anchors{
            horizontalCenter: parent.horizontalCenter
            top:parent.top
            topMargin: 135
        }

        width:110
        height: 110
    }
    Item{
        anchors.fill: parent
        anchors.topMargin: 250
        anchors.leftMargin: 10
        anchors.bottomMargin: 120
        GridView{
            id: controlView
            anchors.fill : parent
            cellWidth: 200
            cellHeight: 200
            clip:true
            model: root.controlsModel
            delegate: Item{
                width: controlView.cellWidth
                height: controlView.cellHeight
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
        GSystem.createControlsModel();
        root.controlsModel = GSystem.controlsModel;
   }
}
