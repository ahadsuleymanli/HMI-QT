import QtQuick 2.0
import ck.gmachine 1.0


Item {
    id:proot
    width:300
    height:300
    anchors.centerIn: parent
    function init()
    {
        GSystem.seatPagePass(); //feedback request
    }
    Image{
            source: "qrc:/design/general/btnbg.png"
            fillMode: Image.PreserveAspectFit
            width:300
            Row{
                    anchors.centerIn: parent
                    spacing: 20
                    Image{
                        source:"qrc:/design/seats/heating.svg"
                        height:degree.height
                        fillMode: Image.PreserveAspectFit
                        sourceSize.width: degree.height
                        sourceSize.height: degree.height
                        antialiasing: true
                    }
                    Column
                    {
                    id:degree
                    spacing: 5
                                Rectangle{
                                id:level1
                                radius: 5
                                width:75
                                height:25
                                color:serial_mng.heat>2?"#f92814":"white"
                                    MouseArea{
                                       anchors.fill: parent
                                       cursorShape: Qt.IBeamCursor;
                                    }
                                }
                                Rectangle{
                                id:level2
                                radius: 5
                                width:75
                                height:25
                                color:serial_mng.heat>1?"#f92814":"white"
                                    MouseArea{
                                       anchors.fill: parent
                                       cursorShape: Qt.IBeamCursor;
                                    }
                                }
                                Rectangle{
                                id:level3
                                radius: 5
                                width:75
                                height:25
                                color:serial_mng.heat>0?"#f92814":"white"
                                    MouseArea{
                                       anchors.fill: parent
                                       cursorShape: Qt.IBeamCursor;
                                    }
                                }
                    }
            }

    }
    MouseArea{
                anchors.fill: parent
                onPressed: {
                        GSystem.sendSeatCommand("heating");
                        //feedback'den geleceği için yorum satırı yapıldı
                        //serial_mng.heat = (serial_mng.heat+1) % 4;
                }
            }
    Component.onCompleted: {

    }
}
