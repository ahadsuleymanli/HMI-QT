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
    caption: qsTr("Third Footrest M1 Calibration") + mytrans.emptyString
    pageName: "ThirdFootrestM1"
    function init()
    {
        console.log("Third Footrest Motor 1");
    }
   GridLayout {
    id: grid
    width:500
    anchors.centerIn: parent
    rowSpacing: 15
    columns:2

    Text { color:"white"; text: qsTr("Footrest Up") + mytrans.emptyString; font.bold: true;  }
    CalibreSettingsButton
    {
        text:"Up"
        width:150
        pressedKey:"calibration/third_footrest1_up";
        releaseKey:"calibration/third_footrest1_stop";
    }

    Text { color:"white"; text: qsTr("Footrest Down") + mytrans.emptyString; font.bold: true;  }
    CalibreSettingsButton
    {
        text:"Down"
        pressedKey:"calibration/third_footrest1_down";
        releaseKey:"calibration/third_footrest1_stop";
    }

    Text { color:"white"; text: qsTr("Footrest Set Minimum") + mytrans.emptyString; font.bold: true;  }
    CalibreSettingsButton
    {
        text:"Set Min"
        pressedKey:"calibration/third_footrest1_min";
    }


    Text { color:"white"; text: qsTr("Footrest Set Maximum") + mytrans.emptyString; font.bold: true;  }
    CalibreSettingsButton
    {
        text:"Set Maximum"
        pressedKey:"calibration/third_footrest1_max";
    }


    Text { color:"white"; text: qsTr("Footrest Reset") + mytrans.emptyString; font.bold: true;  }
    CalibreSettingsButton
    {
        text:"Reset"
        pressedKey:"calibration/third_footrest1_reset";
    }
}

}
