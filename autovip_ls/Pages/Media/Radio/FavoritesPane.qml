import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Item {
//    opacity: 0.8
    GridView {
        cellWidth: width/2
        anchors.fill: parent
        clip: true
//        anchors.top: parent.top
//        anchors.left: parent.left
//        anchors.right: parent.right
        model: presetsModel
        delegate: Rectangle {
            color: "red"
            Rectangle{
                anchors.bottom: parent.bottom
                width: parent.width
                height: 2
                color: "#ffff8888"
            }
            Text {
                id: frequencyText
                text: frequency
            }
//            Image {
//                width: 200
//                height: 60

////                fillMode:
//                source: "qrc:/design/media/Radio/button.png";
//                anchors.horizontalCenter: parent.horizontalCenter }
////            Text { text: name; anchors.horizontalCenter: parent.horizontalCenter }

//        }


        }
    }
    ListModel{
        id:presetsModel
    }
    Component.onCompleted: {
        for (var i = 0 ;i<50; i++)
            presetsModel.append({frequency:100.5})
    }

}
