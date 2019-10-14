import QtQuick 2.4
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import ck.gmachine 1.0
import "../../Components"

BasePage {
    id:root
    caption:  qsTr("SEATS") + mytrans.emptyString
    function init()
    {
//        ani.restart();
    }
    function end()
    {
//        ani.stop();
    }
    function selectSeat(seat_no)
    {
        var data = seatsModel.get(seat_no - 1);
        GSystem.selectedSeat = seat_no
        GSystem.selectedSeatText = data.name;
        GSystem.state = data.name;
        GSystem.changePage(data.st);
    }
    Image{
        id: seatsimg
//        anchors.centerIn: parent
        anchors.verticalCenter: parent.verticalCenter
        x:250
        width:700
        source:"qrc:/design/seats/topview/seats.png"
        fillMode: Image.PreserveAspectFit
            Image{
                id:one
                x:296
                y:88
                source:"qrc:/design/general/one.png"
                sourceSize.height: 55
                fillMode: Image.PreserveAspectFit
            }
            Image{
                id:two
                x:296
                y:199
                source:"qrc:/design/general/two.png"
                sourceSize.height: 55
                fillMode: Image.PreserveAspectFit
            }
            Image{
                id:three
                x:136
                y:96
                source:"qrc:/design/general/three.png"
                sourceSize.height: 55
                fillMode: Image.PreserveAspectFit
            }
            Image{
                id:four
                x:136
                y:194
                source:"qrc:/design/general/four.png"
                sourceSize.height: 55
                fillMode: Image.PreserveAspectFit
            }

            Rectangle {
                id: firstoverlay
                x: 285
                y: 80
                width: 91
                height: 71
                color: "transparent"
                radius: 20
                opacity: 0.35
                MouseArea{
                    anchors.rightMargin: 0
                    anchors.bottomMargin: 0
                    anchors.leftMargin: 0
                    anchors.topMargin: 0
                    anchors.fill: parent
                    onClicked: selectSeat(1)
                    onPressed: firstoverlay.color = "#db0000"
                    onReleased: firstoverlay.color = "transparent"
                }
            }

            Rectangle {
                id: secondoverlay
                x: 285
                y: 194
                width: 91
                height: 71
                color: "transparent"
                radius: 20
                opacity: 0.35
                MouseArea{
                    anchors.rightMargin: 0
                    anchors.bottomMargin: 0
                    anchors.leftMargin: 0
                    anchors.topMargin: 0
                    anchors.fill: parent
                    onClicked: selectSeat(2)
                    onPressed: secondoverlay.color = "#db0000"
                    onReleased: secondoverlay.color = "transparent"
                }
            }

            Rectangle {
                id: thirdoverlay
                x: 80
                y: 88
                width: 106
                height: 71
                color: "transparent"
                radius: 20
                opacity: 0.35
                MouseArea{
                    anchors.rightMargin: 0
                    anchors.bottomMargin: 0
                    anchors.leftMargin: 0
                    anchors.topMargin: 0
                    anchors.fill: parent
                    onClicked: selectSeat(3)
                    onPressed: thirdoverlay.color = "#db0000"
                    onReleased: thirdoverlay.color = "transparent"
                }
            }

            Rectangle {
                id: fourthoverlay
                x: 80
                y: 186
                width: 106
                height: 71
                color: "transparent"
                radius: 20
                opacity: 0.35
                MouseArea{
                    anchors.rightMargin: 0
                    anchors.bottomMargin: 0
                    anchors.leftMargin: 0
                    anchors.topMargin: 0
                    anchors.fill: parent
                    onClicked: selectSeat(4)
                    onPressed: fourthoverlay.color = "#db0000"
                    onReleased: fourthoverlay.color = "transparent"
                }
            }
    }
    LeftTextMenu{
            id:leftMenu
            model:seatsModel
            //delegate: menuDelegate
            onClicked: function(ind)
            {
                var item = leftMenu.model.get(ind);
                GSystem.selectedSeat = item.seat_no
                GSystem.selectedSeatText = item.name;
                GSystem.state = item.st;
                GSystem.changePage(item.st);
            }
            /*
            Component {
                id:menuDelegate
                LeftTextButton{
                   text: qsTr(name) + mytrans.emptyString
                   area.onClicked: {
                        GSystem.selectedSeat = seat_no
                        GSystem.selectedSeatText = text;
                        GSystem.state = name;
                        GSystem.changePage(st);
                    }

                }
            }
            */

            ListModel {
                id: seatsModel

                ListElement {
                   name: qsTr("First Seat")
                   st: "OneSeat"
                   seat_no:1
                }
                ListElement {
                   name: qsTr("Second Seat")
                   st: "OneSeat"
                   seat_no:2
                }
                ListElement {
                   name: qsTr("Third Seat")
                   st: "OneSeat"
                   seat_no:3
                }
                ListElement {
                   name: qsTr("Fourth Seat")
                   st: "OneSeat"
                   seat_no:4
                }
            }

        }
//    SequentialAnimation{
//        id:ani
//        loops: Animation.Infinite
//        running: true
//        SequentialAnimation{
//            NumberAnimation{
//                target:one
//                properties:"y"
//                to:110
//                duration:500
//            }
//            NumberAnimation{
//                target:one
//                properties:"y"
//                to:122
//                duration:500
//            }
//        }
//        SequentialAnimation{
//            NumberAnimation{
//                target:two
//                properties:"y"
//                to:149
//                duration:500
//            }
//            NumberAnimation{
//                target:two
//                properties:"y"
//                to:159
//                duration:500
//            }
//        }
//        SequentialAnimation{
//            NumberAnimation{
//                target:three
//                properties:"y"
//                to:124
//                duration:500
//            }
//            NumberAnimation{
//                target:three
//                properties:"y"
//                to:134
//                duration:500
//            }
//        }
//        SequentialAnimation{
//            NumberAnimation{
//                target:four
//                properties:"y"
//                to:155
//                duration:500
//            }
//            NumberAnimation{
//                target:four
//                properties:"y"
//                to:165
//                duration:500
//            }
//        }
//    }
}
