
import QtQuick 2.4
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import ck.gmachine 1.0
import "../../Components"

BasePage {
    id:root
    caption: qsTr("SCREEN DIVIDER") + mytrans.emptyString
    pageName: "ScreenDivider"
    property int delay: 300
    property variant items: [];
    property int selected: 1
    function init()
    {
        root.select(0);
    }
    function select(ind)
    {
       root.selected = ind;
       switch(ind)
       {
       case 0:
        serial_mng.sendKey("media/ready_divide",true,root.delay);
        serial_mng.sendKey("media/screen_divider",true,root.delay);
                        main.source="qrc:/design/media/ekran-bolme.png";
           break;
       case 1:
        serial_mng.sendKey("media/ready_divide",true,root.delay);
        serial_mng.sendKey("media/front_camera",true,root.delay);
                        main.source="qrc:/design/media/camera-front.png";
           break;
       case 2:
        serial_mng.sendKey("media/ready_divide",true,root.delay);
        serial_mng.sendKey("media/rear_camera",true,root.delay);
                        main.source="qrc:/design/media/camera-back.png";
           break;
       }
    }
    function ready()
    {
        serial_mng.sendKey("media/ready_divide",true,root.delay);
        serial_mng.sendKey("media/screen_divider",true,root.delay);
    }
    Item{
        x:0
        y:0
        width:parent.width
        height:parent.height
    Image{
        id:main
        source:"qrc:/design/media/ekran-bolme.png"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        sourceSize.height : 300
        fillMode: Image.PreserveAspectFit
    }
    Row{
       spacing: 10
       anchors.top:main.bottom
       anchors.horizontalCenter: parent.horizontalCenter
        Rectangle{
            id:screendivide
            width:180
            height:50
            color: (root.selected === 0)?GSystem.leftTextMenuItemPressedColor:GSystem.leftTextMenuItemColor
            border.width: 1
            border.color:Qt.rgba(0/255, 108/255, 128/255,0.6)
            Text{
                anchors.centerIn: parent
                text:qsTr("Divide Screen") + mytrans.emptyString
                color:"white"
                font.pixelSize: 22
                horizontalAlignment: Text.AlignHCenter
                font.family: GSystem.centurygothic.name
            }
            MouseArea{
                anchors.fill: parent
                onPressed: {
                    root.select(0);
                }
                onReleased: {

                }
            }
        }
        Rectangle{
            id:frontcamera
            width:180
            height:50
            color: (root.selected === 1)?GSystem.leftTextMenuItemPressedColor:GSystem.leftTextMenuItemColor
            border.width: 1
            border.color:Qt.rgba(0/255, 108/255, 128/255,0.6)
            Text{
                anchors.centerIn: parent
                text:qsTr("Front Camera") + mytrans.emptyString
                color:"white"
                font.pixelSize: 22
                horizontalAlignment: Text.AlignHCenter
                font.family: GSystem.centurygothic.name
            }
            MouseArea{
                anchors.fill: parent
                onPressed: {
                    root.select(1);
                }
                onReleased: {

                }
            }
        }
        Rectangle{
            id:rearcamera
            width:180
            height:50
            color: (root.selected === 2)?GSystem.leftTextMenuItemPressedColor:GSystem.leftTextMenuItemColor
            border.width: 1
            border.color:Qt.rgba(0/255, 108/255, 128/255,0.6)
            Text{
                anchors.centerIn: parent
                text:qsTr("Rear Camera") + mytrans.emptyString
                color:"white"
                font.pixelSize: 22
                horizontalAlignment: Text.AlignHCenter
                font.family: GSystem.centurygothic.name
            }
            MouseArea{
                anchors.fill: parent
                onPressed: {
                    root.select(2);
                }
                onReleased: {

                }
            }
        }
    }
    }
    Component.onCompleted: {
            root.delay = serial_mng.getDivideDelay();
            items.push(screendivide);
            items.push(frontcamera);
            items.push(rearcamera);
    }

}
