import QtQuick 2.4
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import ck.gmachine 1.0
import "../../Components"

BasePage {
    id:root
    caption: qsTr("CURTAINS") + mytrans.emptyString
    pageName: "Curtains"
    function init()
    {
        ani.restart();
    }
    function end()
    {
        ani.stop();
    }
    Image{
        x:0
        y:0
        width:parent.width
        height:parent.height+40
        LeftTextMenu
        {
            id:leftmenu
            model:tmodel
            height: parent.height

        }
        ListModel{
            id: tmodel
            ListElement{
                name: qsTr("First Curtain")
                st:"LeftCurtain"
            }
            ListElement{
                name: qsTr("Second Curtain")
                st:"RightCurtain"
            }
            ListElement{
                name: qsTr("Third Curtain")
                st:"LeftCurtain2"
            }
            ListElement{
                name: qsTr("Fourth Curtain")
                st:"RightCurtain2"
            }
            ListElement{
                name: qsTr("Luggage Curtain")
                st:"LuggageCurtain"
            }
        }
//        Repeater {
//            model:tmodel
//            Text {
//                text: name
//            }
//        }

        Image{
            x:247
            anchors.verticalCenter: parent.verticalCenter
            source:"qrc:/design/controls/curtains.png"
            Image{
                id:c1
                x:68
                y:122
                sourceSize.height:48
                fillMode: Image.PreserveAspectFit
                source:"qrc:/design/general/two.png"
                MouseArea{
                    width: 75
                    height: 75
                    x: -35
                    y: -35
                    onClicked: {
                                GSystem.state = "LeftCurtain";
                                GSystem.changePage("LeftCurtain");
                        }
                }
            }
            Image{
                id:c2
                x:704
                y:122
                sourceSize.height:48
                fillMode: Image.PreserveAspectFit
                source:"qrc:/design/general/one.png"
                MouseArea{
                    width: 75
                    height: 75
                    x: -35
                    y: -35
                   onClicked: {
                                GSystem.state = "RightCurtain";
                                GSystem.changePage("RightCurtain");
                        }
                }
            }
            Image{
                id:c3
                x:166
                y:68
                sourceSize.height:48
                fillMode: Image.PreserveAspectFit
                source:"qrc:/design/general/four.png"
                MouseArea{
                    width: 75
                    height: 75
                    x: -35
                    y: -35
                   onClicked: {
                                GSystem.state = "LeftCurtain2";
                                GSystem.changePage("LeftCurtain2");
                        }
                }
            }
            Image{
                id:c4
                x:610
                y:68
                sourceSize.height:48
                fillMode: Image.PreserveAspectFit
                source:"qrc:/design/general/three.png"
                MouseArea{
                    width: 75
                    height: 75
                    x: -35
                    y: -35
                   onClicked: {
                                GSystem.state = "RightCurtain2";
                                GSystem.changePage("RightCurtain2");
                        }
                }
            }
            Image{
                id:c5
                y:12
                anchors.horizontalCenter: parent.horizontalCenter
                sourceSize.height:48
                fillMode: Image.PreserveAspectFit
                source:"qrc:/design/general/five.png"
                MouseArea{
                    width: 75
                    height: 75
                    x: -35
                    y: -35
                    cursorShape:Qt.DragMoveCursor
                   onClicked: {
                                GSystem.state = "LuggageCurtain";
                                GSystem.changePage("LuggageCurtain");
                        }
                }
            }
        }

        }
//    SequentialAnimation{
//        id:ani
//        loops: Animation.Infinite
//        running: true
//        SequentialAnimation{
//            NumberAnimation{
//                target:c1
//                properties:"y"
//                to:110
//                duration:500
//            }
//            NumberAnimation{
//                target:c1
//                properties:"y"
//                to:122
//                duration:500
//            }
//        }
//        SequentialAnimation{
//            NumberAnimation{
//                target:c2
//                properties:"y"
//                to:110
//                duration:500
//            }
//            NumberAnimation{
//                target:c2
//                properties:"y"
//                to:122
//                duration:500
//            }
//        }
//        SequentialAnimation{
//            NumberAnimation{
//                target:c3
//                properties:"y"
//                to:58
//                duration:500
//            }
//            NumberAnimation{
//                target:c3
//                properties:"y"
//                to:68
//                duration:500
//            }
//        }
//        SequentialAnimation{
//            NumberAnimation{
//                target:c4
//                properties:"y"
//                to:58
//                duration:500
//            }
//            NumberAnimation{
//                target:c4
//                properties:"y"
//                to:68
//                duration:500
//            }
//        }
//        SequentialAnimation{
//            NumberAnimation{
//                target:c5
//                properties:"y"
//                to:2
//                duration:500
//            }
//            NumberAnimation{
//                target:c5
//                properties:"y"
//                to:12
//                duration:500
//            }
//        }
//    }
}
