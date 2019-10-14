import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import ck.gmachine 1.0
import MyLang 1.0
import QtGraphicalEffects 1.0
import "../../Components"
import QtQuick.Extras 1.4
import QtGraphicalEffects 1.0

BasePage{
    id:root
    caption: qsTr("Second Sead Head Calibration") + mytrans.emptyString
    pageName: "SecondSeatHead"
    function init()
    {
        console.log("second sead head calibration");
    }
   GridLayout {
    id: grid
    width:500
    anchors.centerIn: parent
    rowSpacing: 15
    columns:2

    Text { color:"white"; text: qsTr("Head Forward") + mytrans.emptyString; font.bold: true;  }
    CalibreSettingsButton
    {
        text:"Forward"
        width:150
        pressedKey:"calibration/second_head_forward";
    }

    Text { color:"white"; text: qsTr("Head Backward") + mytrans.emptyString; font.bold: true;  }
    CalibreSettingsButton
    {
        text:"Backward"
        pressedKey:"calibration/second_head_backward";
    }

    Text { color:"white"; text: qsTr("Head Set") + mytrans.emptyString; font.bold: true;  }
    CalibreSettingsButton
    {
        text:"Set"
        pressedKey:"calibration/second_head_set";
    }


    Text { color:"white"; text: qsTr("Head MIN") + mytrans.emptyString; font.bold: true;  }
    CalibreSettingsButton
    {
        text:"Set Minimum"
        pressedKey:"calibration/second_head_min";
    }


    Text { color:"white"; text: qsTr("Head MAX") + mytrans.emptyString; font.bold: true;  }
    CalibreSettingsButton
    {
        text:"Set Maximum"
        pressedKey:"calibration/second_head_max";
    }
}

}
