import QtQuick 2.0
import QtQuick.Controls 1.4
import ck.gmachine 1.0

Item {
        width:parent.width
        height:66
        property real prog: 0
        property real thour: 0
        property real tseconds: 0
        property real tminutes: 0
        property real chour: 0
        property real cseconds: 0
        property real cminutes: 0
        function changeProgress(val)
        {
            var x = val * 100 / bg.width;
            point.x = x;
        }
        Slider{
            id:bg
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.left: parent.left
            width:parent.width
            height:11
            value:mp_mng.percentage / 100
            onValueChanged: function()
            {
                if( (mp_mng.percentage / 100) != value )
                {
                    mp_mng.fseek(value * 100);
                }
            }
        }
    Text{
        anchors.top: bg.bottom
        anchors.left: bg.left
        anchors.topMargin: 10
        font.family:GSystem.centurygothic.name
        font.pixelSize: 18
        text:mp_mng.chours + ":" +mp_mng.cminutes + ":" + mp_mng.cseconds
        color: "white"
    }
    Text{
        anchors.top: bg.bottom
        anchors.right: bg.right
        anchors.topMargin: 10
        font.family:GSystem.centurygothic.name
        font.pixelSize: 18
        text:mp_mng.thours+":"+mp_mng.tminutes+":"+mp_mng.tseconds
        color: "white"
    }

}
