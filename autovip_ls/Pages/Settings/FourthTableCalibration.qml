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
    caption: qsTr("Fourth Table Calibration") + mytrans.emptyString
    pageName: "FourthTableCalibration"
    function init()
    {
        console.log("fourth table motor calibration");
    }
   GridLayout {
    id: grid
    width:500
    anchors.centerIn: parent
    rowSpacing: 15
    columns:2

    Text { color:"white"; text: qsTr("Fourth Table Up") + mytrans.emptyString; font.bold: true;  }
    CalibreSettingsButton
    {
        text:"Up"
        width:150
        pressedKey:"calibration/fourth_table_up";
        releaseKey:"calibration/fourth_table_stop";
    }

    Text { color:"white"; text: qsTr("Fourth Table Down") + mytrans.emptyString; font.bold: true;  }
    CalibreSettingsButton
    {
        text:"Down"
        pressedKey:"calibration/fourth_table_down";
        releaseKey:"calibration/fourth_table_stop";
    }

    Text { color:"white"; text: qsTr("Fourth Table Set Minimum") + mytrans.emptyString; font.bold: true;  }
    CalibreSettingsButton
    {
        text:"Set Min"
        pressedKey:"calibration/fourth_table_min";
    }


    Text { color:"white"; text: qsTr("Fourth Table Set Maximum") + mytrans.emptyString; font.bold: true;  }
    CalibreSettingsButton
    {
        text:"Set Maximum"
        pressedKey:"calibration/fourth_table_max";
    }


    Text { color:"white"; text: qsTr("Fourth Table Reset") + mytrans.emptyString; font.bold: true;  }
    CalibreSettingsButton
    {
        text:"Reset"
        pressedKey:"calibration/fourth_table_reset";
    }
}

}
