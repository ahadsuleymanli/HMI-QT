import QtQuick 2.4
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import ck.gmachine 1.0
import "../../Components"

BasePage {
    id:root
    caption: qsTr("MEDIA") + mytrans.emptyString
    pageName: "KodiMediaPlayer"
    function init(){
       panel.init();
    }
    function end(){
        panel.end();
    }

    Image{
        x:0
        y:0
        width:parent.width
        height:parent.height
        MediaDirection{
            x:130
            y:257
        }
        MediaPanel{
            id:panel
            x:535
            y:176
        }


        }
    Connections {
        target: mp_mng
        onPlayeridChanged: function(id)
        {
            if(id !== -1)
            {
                mp_mng.getItem(id);
            }
        }
    }
    Component.onCompleted: function(){
       mp_mng.getActivePlayers();
    }
}
