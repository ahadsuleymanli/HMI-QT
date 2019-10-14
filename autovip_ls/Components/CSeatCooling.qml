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
                        source:"qrc:/design/seats/cooling.svg"
                        height:degree.height
                        sourceSize.width: degree.height
                        sourceSize.height: degree.height
                        fillMode: Image.PreserveAspectFit
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
                                color:serial_mng.cool>2?"#4ab8f7":"white"
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
                                color:serial_mng.cool>1?"#4ab8f7":"white"
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
                                color:serial_mng.cool>0?"#4ab8f7":"white"
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
                    var plus =  GSystem.sendSeatCommand("cooling");
                    if(plus)
                    {
                        //feedback'den geleceği için yorum satırı yapıldı
                        //serial_mng.cool = (serial_mng.cool +1) % 4;
                    }
                }
            }
    Component.onCompleted: {

    }
}
