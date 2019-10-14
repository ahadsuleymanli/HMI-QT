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
    caption: qsTr("Drawer 2 Calibration") + mytrans.emptyString
    pageName: "DrawerMotor2"
    function init()
    {
        console.log("drawer 2 motor calibration");
    }
   GridLayout {
    id: grid
    width:500
    anchors.centerIn: parent
    rowSpacing: 15
    columns:2

    Text { color:"white"; text: qsTr("Drawer Up") + mytrans.emptyString; font.bold: true;  }
    CalibreSettingsButton
    {
        text:"Up"
        width:150
        pressedKey:"calibration/second_drawer_up";
        releaseKey:"calibration/second_drawer_stop";
    }

    Text { color:"white"; text: qsTr("Drawer Down") + mytrans.emptyString; font.bold: true;  }
    CalibreSettingsButton
    {
        text:"Down"
         pressedKey:"calibration/second_drawer_down";
         releaseKey:"calibration/second_drawer_stop";
    }

    Text { color:"white"; text: qsTr("Drawer Set Minimum") + mytrans.emptyString; font.bold: true;  }
    CalibreSettingsButton
    {
        text:"Set Min"
        pressedKey:"calibration/second_drawer_min";
    }


    Text { color:"white"; text: qsTr("Drawer Set Maximum") + mytrans.emptyString; font.bold: true;  }
    CalibreSettingsButton
    {
        text:"Set Maximum"
        pressedKey:"calibration/second_drawer_max";
    }


    Text { color:"white"; text: qsTr("Drawer Reset") + mytrans.emptyString; font.bold: true;  }
    CalibreSettingsButton
    {
        text:"Reset"
        pressedKey:"calibration/second_drawer_reset";
    }
    }
}
