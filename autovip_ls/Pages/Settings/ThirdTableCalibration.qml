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
    caption: qsTr("Third Table Calibration") + mytrans.emptyString
    pageName: "ThirdTableCalibration"
    function init()
    {
        console.log("third table motor calibration");
    }
   GridLayout {
    id: grid
    width:500
    anchors.centerIn: parent
    rowSpacing: 15
    columns:2

    Text { color:"white"; text: qsTr("Third Table Up") + mytrans.emptyString; font.bold: true;  }
    CalibreSettingsButton
    {
        text:"Up"
        width:150
        pressedKey:"calibration/third_table_up";
        releaseKey:"calibration/third_table_stop";
    }

    Text { color:"white"; text: qsTr("Third Table Down") + mytrans.emptyString; font.bold: true;  }
    CalibreSettingsButton
    {
        text:"Down"
        pressedKey:"calibration/third_table_down";
        releaseKey:"calibration/third_table_stop";
    }

    Text { color:"white"; text: qsTr("Third Table Set Minimum") + mytrans.emptyString; font.bold: true;  }
    CalibreSettingsButton
    {
        text:"Set Min"
        pressedKey:"calibration/third_table_min";
    }


    Text { color:"white"; text: qsTr("Third Table Set Maximum") + mytrans.emptyString; font.bold: true;  }
    CalibreSettingsButton
    {
        text:"Set Maximum"
        pressedKey:"calibration/third_table_max";
    }


    Text { color:"white"; text: qsTr("Third Table Reset") + mytrans.emptyString; font.bold: true;  }
    CalibreSettingsButton
    {
        text:"Reset"
        pressedKey:"calibration/third_table_reset";
    }
}

}
