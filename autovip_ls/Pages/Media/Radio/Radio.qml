import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import "../../../Components"

BasePage {
    id:root
    caption: qsTr("RADIO") + mytrans.emptyString
    pageName: "Radio"

    Item {
        id: raioArea
        x: 0
        y: contentTopMargin + 43 - 3
//        y: contentTopMargin
        height: parent.height - y - contentBottomMargin
        width: parent.width
//        anchors{
//            left: parent.left
//            right: parent.right
//            top: parent.top
//            bottom: parent.bottom
////            topMargin: 43
//        }
        Image{
            x:0
            y:0
            id: backgroundImage
            width: parent.width
            height: 400
            source:"qrc:/design/radio/manualbg.svg"
            visible: false
        }
        Image{
            id: radioReference
            anchors.horizontalCenter: parent.horizontalCenter
//            anchors.right: parent.right
            width: parent.width
            height: parent.height
            source:"qrc:/design/radio/reference_1.png"
        }
        ColumnLayout{
            anchors{
                left: parent.left
                right: parent.right
                top: parent.top

            }
            Rectangle {
                id: slider
                height: 500
                width: parent.width-50
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "#33654321"
            }

        }
    //    Image{

    //        width:parent.width
    //        height:parent.height
    //        Rectangle{
    //            id:leftMenu
    //            color:"#99000000"
    //            width: 246
    //            height:280
    //            x:0
    //            y:273

    //            ColumnLayout
    //            {
    //                width:parent.width
    //                height:parent.height
    //                LeftButton{
    //                   text: "PS4"

    //                }

    //                LeftButton{
    //                   text: "Apple TV"
    //                }

    //                LeftButton{
    //                   text: "DVD"
    //                }

    //                LeftButton{
    //                   text: "Radyo"
    //                   onClicked: {
    //                                GSystem.state = "Radio";
    //                                GSystem.changePage("Radio");
    //                        }
    //                }

    //            }
    //        }

    //        }
    }

}
