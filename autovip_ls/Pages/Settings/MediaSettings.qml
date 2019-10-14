import QtQuick 2.4
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import ck.gmachine 1.0
import QtGraphicalEffects 1.0
import QtQml.Models 2.1
import "../../Components"

BasePage {
    id:root
    caption: qsTr("MEDIA SETTINGS") + mytrans.emptyString
    pageName: "MediaSettings"
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
                            text:qsTr("MediaPlayer Type:")
                            font.family: "Myriad Pro"
                            font.pixelSize: 18
                            color: "white"
                            width:230
                        }
                        Rectangle
                        {
                            width:248
                            height:40
                            color: "transparent"
                                           ComboBox {
                                                currentIndex: 1
                                                textRole: "text"
                                                model: ListModel {
                                                            id: cbItems
                                                                ListElement {
                                                                        text: "Kodi Tv"
                                                                        color: "Yellow"
                                                                }
                                                                ListElement {
                                                                        text: "Apple TV"
                                                                        color: "Yellow"
                                                                }
                                                                }
                                                width: 200
                                                onCurrentIndexChanged: console.debug(cbItems.get(currentIndex).text + ", " + cbItems.get(currentIndex).color)
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
                            text:qsTr("MediaPlayer IP:")
                            font.family: "Myriad Pro"
                            font.pixelSize: 18
                            color: "white"
                            width:230
                        }
                       TextField {
                           width: 200
                           text: SM.mediaPlayerURL
                        }
                    }
                }
            }
        }
        }

}
