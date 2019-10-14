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
    caption: qsTr("Espresso 1 Calibration") + mytrans.emptyString
    pageName: "EspresoMotor1"
    function init()
    {
        console.log("espreso 1 motor calibration");
    }
   GridLayout {
    id: grid
    width:500
    anchors.centerIn: parent
    rowSpacing: 15
    columns:2

    Text { color:"white"; text: qsTr("Espresso Up") + mytrans.emptyString; font.bold: true;  }
    CalibreSettingsButton
    {
        text:"Up"
        width:150
       pressedKey:"calibration/es1_up";
       releaseKey:"calibration/es1_stop";
    }

    Text { color:"white"; text: qsTr("Espresso Down") + mytrans.emptyString; font.bold: true;  }
    CalibreSettingsButton
    {
        text:"Down"
        pressedKey:"calibration/es1_down";
        releaseKey:"calibration/es1_stop";
    }

    Text { color:"white"; text: qsTr("Espresso Set Minimum") + mytrans.emptyString; font.bold: true;  }
    CalibreSettingsButton
    {
        text:"Set Min"
        pressedKey:"calibration/es1_min";
    }


    Text { color:"white"; text: qsTr("Espresso Set Maximum") + mytrans.emptyString; font.bold: true;  }
    CalibreSettingsButton
    {
        text:"Set Maximum"
        pressedKey:"calibration/es1_max";
    }


    Text { color:"white"; text: qsTr("Espresso Reset") + mytrans.emptyString; font.bold: true;  }
    CalibreSettingsButton
    {
        text:"Reset"
        pressedKey:"calibration/es1_reset";
    }
}

}
