import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Item {
//    opacity: 0.8
    Image {
        anchors.fill: parent
        source: "qrc:/design/media/Radio/favoritespane.png"
        opacity: 0.3
    }
    GridView {
        cellWidth: width/2
        cellHeight: 52
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.topMargin: 9+4+10
        anchors.rightMargin: 12
        topMargin: 2
        clip: true
        model: presetsModel
        delegate: Item {
            id:delegateItem
            height: 50
            width: parent.width/2
            Rectangle{
                anchors.bottom: parent.top
                anchors.left: parent.left
                width: parent.width - 2
                height: 2
//                color: "#ffff8888"
                color: "#884c4c4c"
//                color: "white"

            }
            Rectangle{
                anchors.top: parent.bottom
                anchors.left: parent.left
                width: parent.width - 2
                height: 2
//                color: "#ffff8888"
                color: "#884c4c4c"
//                color: "white"
            }
//            Rectangle{
//                anchors.verticalCenter: parent.verticalCenter
//                anchors.left: parent.left
//                anchors.top:parent.top
//                width: parent.width - 2
////                color: "#ff4c4c4c"
//                gradient: Gradient{
//                    GradientStop { position: 0.0; color: "#ff4c4c4c" }
//                    GradientStop { position: 1.0; color: "#44272727" }
//                }
//            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                id: frequencyText
                color: "white"
                text: frequency.toFixed(1)
            }
        }
        Component.onCompleted: {

        }
    }
    ListModel{
        id:presetsModel
    }
    Component.onCompleted: {
        for (var i = 0 ;i<5; i++){
            presetsModel.append({frequency:87.5+i/10})
        }
    }

}
