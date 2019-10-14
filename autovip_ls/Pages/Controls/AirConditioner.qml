import QtQuick 2.4
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import ck.gmachine 1.0
import QtGraphicalEffects 1.0
import "../../Components"

BasePage {
    id:root
    caption: qsTr("AIR CONDITIONER") + mytrans.emptyString
    pageName: "AirConditioner"

    property color shadowColor: "red"

    function init(){
        root.feedback();
    }
    function feedback()
    {
                            switch(SM.actype)
                            {
                                case 1:
                                    serial_mng.sendKey("controls/can_ai_feedback");
                                break;
                                case 2:
                                    serial_mng.sendKey("controls/modbus_ai_feedback");
                                break;
                            }
    }
    function upFandeg()
    {
                            switch(SM.actype)
                            {
                                case 1:
                                    if(serial_mng.fandeg !== 7)
                                    {
                                        serial_mng.fandeg++;
                                    }
                                break;
                                case 2:
                                    if(serial_mng.fandeg !== 5)
                                    {
                                        serial_mng.fandeg++;
                                    }
                                break;
                            }

    }
    function downFandeg()
    {
                            switch(SM.actype)
                            {
                                case 1:
                                    if(serial_mng.fandeg !== 0)
                                    {
                                        serial_mng.fandeg--;
                                    }
                                break;
                                case 2:
                                    if(serial_mng.fandeg !== 0)
                                    {
                                        serial_mng.fandeg--;
                                    }
                                break;
                            }

    }

    function upTemp()
    {
                if(serial_mng.acdeg < 13)
                {
                serial_mng.acdeg++;
//                }else if(serial_mng.acdeg == 13)
//                {
//                    degreeText.text = "MAX"
//                }
                }
    }
    function downTemp()
    {
                if(serial_mng.acdeg > -1 )
                {
                    serial_mng.acdeg--;
//                }else if(serial_mng.acdeg == 0)
//                {
//                    degreeText.text = "MIN"
//                }
                }
    }

Item{
    width:parent.width
    height:parent.height
    y:50
    x:-50
    Rectangle{
        id:leftmost
        width: 50
        height: 240
        x:350
        y:200
        color: "transparent"

        ColumnLayout{
            width:parent.width
            height:parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10

            Rectangle{
                id:airUp
                Layout.preferredWidth: 50
                Layout.preferredHeight: 50
                color: "transparent"
                anchors.horizontalCenter: parent.horizontalCenter

                Image{
                    id: airUpImage
                    source:"qrc:/design/controls/airconditioner/up.svg"
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            airUpDs.visible = true
                            if(SM.actype === 1)
                            {
                                serial_mng.sendKey("controls/can_ai_fan_up");
                            }else{
                                serial_mng.sendKey("controls/modbus_ai_fan_up");
                            }

//                            upFandeg();
                        }
                        onReleased: {
                            airUpDs.visible = false
                        }
                        onClicked: {
                            airUpDs.visible = false
                        }
                   }

                }
                DropShadow {
                  id: airUpDs
                  anchors.fill: airUpImage
                  horizontalOffset: 0
                  verticalOffset: 3
                  radius: 8.0
                  samples: 12
                  source: airUpImage
                  color: shadowColor
                  visible: false
                }

            }
            Rectangle{
                id: airFan
                Layout.preferredWidth: 40
                Layout.preferredHeight: 40
                color: "transparent"
                anchors.horizontalCenter: parent.horizontalCenter

                Image{
                    id: airFanImage
                    scale:0.8
                    source:"qrc:/design/controls/airconditioner/fan1.svg"
                }

            }

            Rectangle{
                id:airDown
                Layout.preferredWidth: 50
                Layout.preferredHeight: 50
                color: "transparent"
                anchors.horizontalCenter: parent.horizontalCenter

                Image{
                    id: airDownImage
                    source:"qrc:/design/controls/airconditioner/down.svg"
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            if(SM.actype === 1)
                            {
                                serial_mng.sendKey("controls/can_ai_fan_down");
                            }else if(SM.actype === 2)
                            {
                                serial_mng.sendKey("controls/modbus_ai_fan_down");
                            }
                            airDownDs.visible = true
//                            downFandeg();
                        }
                        onReleased:{
                            airDownDs.visible = false
                        }
                        onClicked: {
                            airDownDs.visible = false
                        }
                   }

                }
                DropShadow {
                  id: airDownDs
                  anchors.fill: airDownImage
                  horizontalOffset: 0
                  verticalOffset: 3
                  radius: 8.0
                  samples: 12
                  source: airDownImage
                  color: shadowColor
                  visible: false
                }

            }

        }

    }


    Rectangle{
        id:degreeBars
        width: 150
        height: 150
        x:480
        y:250
        color: "transparent"

        ColumnLayout{
            width:parent.width
            height:parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 2

            Rectangle{
                id:fan
                x: 510
                y: 350
                Layout.preferredWidth: 70
                Layout.preferredHeight: 70
                color: "transparent"

                Image{
                    id: fanImage
                    scale:1.2
                    source:"qrc:/design/controls/airconditioner/fan1.svg"
                }

            }
            Rectangle{
                id:bars
                width: 100
                height: 50
                color:"transparent"

                GridLayout{
                    id:typeCan
                    visible:SM.actype === 1
                    columns:7
                    width:parent.width
                    height:parent.height

                    Rectangle{
                        id: c_level1
                        width: 15
                        height: 10
                        color: serial_mng.fandeg === 0?"gray":GSystem.leftTextMenuItemPressedColor
                        radius: 2
                        Layout.alignment: Qt.AlignBottom

                    }
                    Rectangle{
                        id:c_level2
                        width: 15
                        height: 20
                        color: serial_mng.fandeg < 2?"gray":GSystem.leftTextMenuItemPressedColor
                        radius: 2
                        Layout.alignment: Qt.AlignBottom


                    }
                    Rectangle{
                        id:c_level3
                        width: 15
                        height: 30
                        color: serial_mng.fandeg < 3?"gray":GSystem.leftTextMenuItemPressedColor
                        radius: 2
                        Layout.alignment: Qt.AlignBottom


                    }
                    Rectangle{
                        id:c_level4
                        width: 15
                        height: 40
                        color: serial_mng.fandeg < 4?"gray":GSystem.leftTextMenuItemPressedColor
                        radius: 2
                        Layout.alignment: Qt.AlignBottom

                    }
                    Rectangle{
                        id:c_level5
                        width: 15
                        height: 50
                        color: serial_mng.fandeg < 5?"gray":GSystem.leftTextMenuItemPressedColor
                        radius: 2
                        Layout.alignment: Qt.AlignBottom

                    }
                    Rectangle{
                        id:c_level6
                        width: 15
                        height: 60
                        color: serial_mng.fandeg < 6?"gray":GSystem.leftTextMenuItemPressedColor
                        radius: 2
                        Layout.alignment: Qt.AlignBottom

                    }
                    Rectangle{
                        id:c_level7
                        width: 15
                        height: 70
                        color: serial_mng.fandeg < 7?"gray":GSystem.leftTextMenuItemPressedColor
                        radius: 2
                        Layout.alignment: Qt.AlignBottom

                    }

                    Rectangle{
                        id: alt_c_level1
                        width: 15
                        height: 5
                        color: serial_mng.fandeg < 1?"gray":GSystem.leftTextMenuItemPressedColor
                        radius: 2
                        Layout.alignment: Qt.AlignBottom

                    }
                    Rectangle{
                        id:alt_c_level2
                        width: 15
                        height: 5
                        color: serial_mng.fandeg < 2?"gray":GSystem.leftTextMenuItemPressedColor
                        radius: 2
                        Layout.alignment: Qt.AlignBottom


                    }
                    Rectangle{
                        id:alt_c_level3
                        width: 15
                        height: 5
                        color: serial_mng.fandeg < 3?"gray":GSystem.leftTextMenuItemPressedColor
                        radius: 2
                        Layout.alignment: Qt.AlignBottom


                    }
                    Rectangle{
                        id:alt_c_level4
                        width: 15
                        height: 5
                        color: serial_mng.fandeg < 4?"gray":GSystem.leftTextMenuItemPressedColor
                        radius: 2
                        Layout.alignment: Qt.AlignBottom

                    }
                    Rectangle{
                        id:alt_c_level5
                        width: 15
                        height: 5
                        color: serial_mng.fandeg < 5?"gray":GSystem.leftTextMenuItemPressedColor
                        radius: 2
                        Layout.alignment: Qt.AlignBottom

                    }
                    Rectangle{
                        id:alt_c_level6
                        width: 15
                        height: 5
                        color: serial_mng.fandeg < 6?"gray":GSystem.leftTextMenuItemPressedColor
                        radius: 2
                        Layout.alignment: Qt.AlignBottom

                    }
                    Rectangle{
                        id:alt_c_level7
                        width: 15
                        height: 5
                        color: serial_mng.fandeg< 7?"gray":GSystem.leftTextMenuItemPressedColor
                        radius: 2
                        Layout.alignment: Qt.AlignBottom

                    }


                }
                GridLayout{
                    id:modbus
                    visible:SM.actype === 2
                    columns:5
                    width:parent.width
                    height:parent.height

                    Rectangle{
                        id:mb_level1
                        width: 15
                        height: 10
                        color: serial_mng.fandeg === 0?"gray":GSystem.leftTextMenuItemPressedColor
                        radius: 2
                        Layout.alignment: Qt.AlignBottom

                    }
                    Rectangle{
                        id:mb_level2
                        width: 15
                        height: 20
                        color: serial_mng.fandeg < 2?"gray":GSystem.leftTextMenuItemPressedColor
                        radius: 2
                        Layout.alignment: Qt.AlignBottom


                    }
                    Rectangle{
                        id:mb_level3
                        width: 15
                        height: 30
                        color: serial_mng.fandeg < 3?"gray":GSystem.leftTextMenuItemPressedColor
                        radius: 2
                        Layout.alignment: Qt.AlignBottom


                    }
                    Rectangle{
                        id:mb_level4
                        width: 15
                        height: 40
                        color: serial_mng.fandeg < 4?"gray":GSystem.leftTextMenuItemPressedColor
                        radius: 2
                        Layout.alignment: Qt.AlignBottom

                    }
                    Rectangle{
                        id:mb_level5
                        width: 15
                        height: 50
                        color: serial_mng.fandeg < 5?"gray":GSystem.leftTextMenuItemPressedColor
                        radius: 2
                        Layout.alignment: Qt.AlignBottom

                    }



                    Rectangle{
                        id:level1_1
                        width: 15
                        height: 5
                        color: serial_mng.fandeg === 0?"gray":GSystem.leftTextMenuItemPressedColor
                        radius: 2
                        anchors.bottomMargin:1


                    }
                    Rectangle{
                        id:level2_1
                        width: 15
                        height: 5
                        color: serial_mng.fandeg < 2?"gray":GSystem.leftTextMenuItemPressedColor
                        radius: 2
                        anchors.bottomMargin:1


                    }
                    Rectangle{
                        id:level3_1
                        width: 15
                        height: 5
                        color: serial_mng.fandeg < 3?"gray":GSystem.leftTextMenuItemPressedColor
                        radius: 2
                        anchors.bottomMargin:1


                    }
                    Rectangle{
                        id:level4_1
                        width: 15
                        height: 5
                        color: serial_mng.fandeg < 4?"gray":GSystem.leftTextMenuItemPressedColor
                        radius: 2
                        anchors.bottomMargin:1


                    }
                    Rectangle{
                        id:level5_1
                        width: 15
                        height: 5
                        color: serial_mng.fandeg < 5?"gray":GSystem.leftTextMenuItemPressedColor
                        radius: 2
                        anchors.bottomMargin:1
                    }


                }

            }

        }

    }


    Rectangle{
        id:degreeNumber
        width: 80
        height: 80
        x:660
        y:280
        color: "transparent"
        Text{
            id: degreeText
            font.pointSize: 60
            text: ((serial_mng.acdeg < 13) ? (serial_mng.acdeg !== -1) ? (serial_mng.acdeg > 0) ? (serial_mng.acdeg+15) + "°" : "LO" : "OFF" : "HI")
            color:"white"
        }
    }


    Rectangle{
        id:rightmost
        width: 50
        height: 240
        x:800
        y:200
        color: "transparent"

        ColumnLayout{
            width:parent.width
            height:parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10

            Rectangle{
                id:tempUp
                Layout.preferredWidth: 50
                Layout.preferredHeight: 50
                color: "transparent"
                anchors.horizontalCenter: parent.horizontalCenter

                Image{
                    id: tempUpImage
                    source:"qrc:/design/controls/airconditioner/temp-up.svg"
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            if(SM.actype === 1)
                            {
                                serial_mng.sendKey("controls/can_ai_degree_up");
                            }else if(SM.actype === 2)
                            {
                                serial_mng.sendKey("controls/modbus_ai_degree_up");
                            }
                            tempUpDs.visible = true;
                            upTemp();
                        }
                        onReleased : {
                            tempUpDs.visible = false
                        }
                        onClicked: {
                            tempUpDs.visible = false
                        }
                   }

                }
                DropShadow {
                  id: tempUpDs
                  anchors.fill: tempUpImage
                  horizontalOffset: 0
                  verticalOffset: 3
                  radius: 8.0
                  samples: 12
                  source: tempUpImage
                  color: shadowColor
                  visible: false
                }

            }
            Rectangle{
                id:degree
                Layout.preferredWidth: 30
                Layout.preferredHeight: 70
                color: "transparent"
                anchors.horizontalCenter: parent.horizontalCenter

                Image{
                    id: degreeImage
                    source:"qrc:/design/controls/airconditioner/degree.svg"
                }

            }
            Rectangle{
                id:tempDown
                Layout.preferredWidth: 50
                Layout.preferredHeight: 50
                color: "transparent"
                anchors.horizontalCenter: parent.horizontalCenter

                Image{
                    id: tempDownImage
                    source:"qrc:/design/controls/airconditioner/temp-down.svg"
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            if(SM.actype == 1)
                            {
                                serial_mng.sendKey("controls/can_ai_degree_down");
                            }else if(SM.actype == 2)
                            {
                                serial_mng.sendKey("controls/modbus_ai_degree_down");
                            }
                                tempDownDs.visible = true;
                                downTemp();
                        }
                        onClicked : {
                                tempDownDs.visible = false;
                        }
                        onReleased: {
                                tempDownDs.visible = false;
                        }
                   }

                }
                DropShadow {
                  id: tempDownDs
                  anchors.fill: tempDownImage
                  horizontalOffset: 0
                  verticalOffset: 3
                  radius: 8.0
                  samples: 12
                  source: tempDownImage
                  color: shadowColor
                  visible: false
                }

            }

        }

    }

}
    Component.onCompleted: {
    }
}
