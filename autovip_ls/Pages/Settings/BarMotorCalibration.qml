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
    caption: qsTr("Bar Motor Calibration") + mytrans.emptyString
    pageName: "BarMotorCalibration"
    function init()
    {
        console.log("bar motor calibration");
    }
   GridLayout {
    id: grid
    width:500
    anchors.centerIn: parent
    rowSpacing: 15
    columns:2

    Text { color:"white"; text: qsTr("Bar Up") + mytrans.emptyString; font.bold: true;  }
    CalibreSettingsButton
    {
        text:"Up"
        width:150
        pressedKey:"calibration/bar_up";
        releaseKey:"calibration/bar_stop";
    }

    Text { color:"white"; text: qsTr("Bar Down") + mytrans.emptyString; font.bold: true;  }
    CalibreSettingsButton
    {
        text:"Down";
        pressedKey:"calibration/bar_down";
        releaseKey:"calibration/bar_stop";
    }

    Text { color:"white"; text: qsTr("Bar Set Minimum") + mytrans.emptyString; font.bold: true;  }
    CalibreSettingsButton
    {
        text:"Set Min"
        pressedKey:"calibration/bar_min";
    }


    Text { color:"white"; text: qsTr("Bar Set Maximum") + mytrans.emptyString; font.bold: true;  }
    CalibreSettingsButton
    {
        text:"Set Maximum"
        pressedKey:"calibration/bar_max";
    }


    Text { color:"white"; text: qsTr("Bar Reset") + mytrans.emptyString; font.bold: true;  }
    CalibreSettingsButton
    {
        text:"Reset";
        pressedKey:"calibration/bar_reset";
    }
}

}
