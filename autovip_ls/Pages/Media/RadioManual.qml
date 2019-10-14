import QtQuick 2.4
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import ck.gmachine 1.0
import "../../Components"

BasePage {
    id:root
    caption: qsTr("MANUAL RADIO") + mytrans.emptyString
    Image{
        x:0
        y:0
        width:parent.width
        height:parent.height
        Rectangle{
            id:leftMenu
            color:"#99000000"
            width: 246
            height:280
            x:0
            y:273

            ColumnLayout
            {
                width:parent.width
                height:parent.height
                LeftButton{
                   text: "PS4"

                }

                LeftButton{
                   text: "Apple TV"
                }

                LeftButton{
                   text: "DVD"
                }

                LeftButton{
                   text: "Radyo"
                   onClicked: {
                                GSystem.state = "Radio";
                                GSystem.changePage("Radio");
                        }
                }

            }
        }

        }
}
