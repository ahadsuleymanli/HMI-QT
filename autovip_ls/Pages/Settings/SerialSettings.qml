import QtQuick 2.4
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import ck.gmachine 1.0
import "../../Components"

BasePage {
    id:root
    caption: qsTr("SERIAL SETTINGS") + mytrans.emptyString
    pageName: "SerialSettings"
                        function findIndex(val)
                        {
                            switch(val)
                            {
                            case 1200:
                                return 0;
                            case 2400:
                                return 1;
                            case 4800:
                                return 2;
                            case 9600:
                                return 3;
                            case 19200:
                                return 4;
                            case 38400:
                                return 5;
                            case 57600:
                                return 6;
                            case 115200:
                                return 7;
                            }
                        }
    Item{
        x:0
        y:0
        width:parent.width
        height:parent.height
        SettingsMenu{
                id:leftMenu
                x:0
                y:200
            }

        Item{
            anchors.left: leftMenu.right
            anchors.top: leftMenu.top
            anchors.leftMargin: 20

            width:400
            height:200
            ColumnLayout
            {
                width:parent.width
                height:parent.height
                spacing: 6

                Rectangle{
                    color:"transparent"
                    height:50
                    width:parent.width
                    RowLayout{
                        width: parent.width
                        height:50
                        spacing: 6
                        Text{
                            text:qsTr("Port Name :")
                            font.family: "Myriad Pro"
                            font.pixelSize: 18
                            color: "white"
                            width:230
                        }
                       TextField {
                           width: 200
                           text: SM.portname
                           onAccepted: {
                               SM.portname = text;
                           }
                        }
                    }
                }

                Rectangle{
                    color:"transparent"
                    height:50
                    width:parent.width
                    RowLayout{
                        width: parent.width
                        height:50
                        spacing: 6
                        Text{
                            text: qsTr("Baud Rate :")
                            font.family: "Myriad Pro"
                            font.pixelSize: 18
                            color: "white"
                            width:230
                        }
                        Rectangle
                        {
                            width:200
                            height:40
                            color: "transparent"
                                           ComboBox {
                                                currentIndex: findIndex(SM.baudrate)
                                                textRole: "text"
                                                model: ListModel {
                                                            id: cbItems
                                                                ListElement {
                                                                        text: "1200"
                                                                        val: 1200
                                                                }
                                                                ListElement {
                                                                        text: "2400"
                                                                        val: 2400
                                                                }
                                                                ListElement {
                                                                        text: "4800"
                                                                        val: 4800
                                                                }
                                                                ListElement {
                                                                        text: "9600"
                                                                        val: 9600
                                                                }
                                                                ListElement {
                                                                        text: "19200"
                                                                        val: 19200
                                                                }
                                                                ListElement {
                                                                        text: "38400"
                                                                        val: 38400
                                                                }
                                                                ListElement {
                                                                        text: "57600"
                                                                        val: 57600
                                                                }
                                                                ListElement {
                                                                        text: "115200"
                                                                        val: 115200
                                                                }
                                                                }
                                                width: 200
                                                onCurrentIndexChanged: SM.baudrate = cbItems.get(currentIndex).val;
                                                }

                        }
                    }
                }
            }
        }
        }

}
