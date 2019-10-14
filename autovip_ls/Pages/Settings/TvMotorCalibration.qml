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
    caption: qsTr("TV Motor Calibration") + mytrans.emptyString
    pageName: "TvMotorCalibration"
    function init()
    {
        console.log("tv motor calibration");
    }
   GridLayout {
    id: grid
    width:500
    anchors.centerIn: parent
    rowSpacing: 15
    columns:2

    Text { color:"white"; text: qsTr("Tv Up") + mytrans.emptyString; font.bold: true;  }
    CalibreSettingsButton
    {
        text:"Up"
        width:150
        pressedKey:"calibration/tv_up";
        releaseKey:"calibration/tv_stop";
    }

    Text { color:"white"; text: qsTr("Tv Down") + mytrans.emptyString; font.bold: true;  }
    CalibreSettingsButton
    {
        text:"Down"
        pressedKey:"calibration/tv_down";
        releaseKey:"calibration/tv_stop";
    }

    Text { color:"white"; text: qsTr("TV Set Minimum") + mytrans.emptyString; font.bold: true;  }
    CalibreSettingsButton
    {
        text:"Set Min"
        pressedKey:"calibration/tv_min";
    }


    Text { color:"white"; text: qsTr("TV Set Maximum") + mytrans.emptyString; font.bold: true;  }
    CalibreSettingsButton
    {
        text:"Set Maximum"
        pressedKey:"calibration/tv_max";
    }


    Text { color:"white"; text: qsTr("TV Reset") + mytrans.emptyString; font.bold: true;  }
    CalibreSettingsButton
    {
        text:"Reset"
        pressedKey:"calibration/tv_reset";
    }
}

}
