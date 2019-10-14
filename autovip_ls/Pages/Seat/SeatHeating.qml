import QtQuick 2.0
import QtQuick.Controls 2.3
import ck.gmachine 1.0
import QtQuick.Layouts 1.3
import "../../Components"


BasePage {
    id:root
    caption: qsTr(GSystem.selectedSeatToText()) + " "+ qsTr("SEAT HEATING") + mytrans.emptyString
    function init(){
        crl.init();
    }
    CSeatHeating{
        id:crl
    }
}
