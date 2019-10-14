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
    caption: qsTr("Drawer 1 Calibration") + mytrans.emptyString
    pageName: "DrawerMotor1"
    function init()
    {
        console.log("drawer 1 motor calibration");
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
        pressedKey:"calibration/first_drawer_up";
        releaseKey:"calibration/first_drawer_stop";
    }

    Text { color:"white"; text: qsTr("Drawer Down") + mytrans.emptyString; font.bold: true;  }
    CalibreSettingsButton
    {
        text:"Down"
        pressedKey:"calibration/first_drawer_down";
        releaseKey:"calibration/first_drawer_stop";
    }

    Text { color:"white"; text: qsTr("Drawer Set Minimum") + mytrans.emptyString; font.bold: true;  }
    CalibreSettingsButton
    {
        text:"Set Min"
        pressedKey:"calibration/first_drawer_min";
    }


    Text { color:"white"; text: qsTr("Drawer Set Maximum") + mytrans.emptyString; font.bold: true;  }
    CalibreSettingsButton
    {
        text:"Set Maximum"
        pressedKey:"calibration/first_drawer_max";
    }


    Text { color:"white"; text: qsTr("Drawer Reset") + mytrans.emptyString; font.bold: true;  }
    CalibreSettingsButton
    {
        text:"Reset"
        pressedKey:"calibration/first_drawer_reset";
    }
}

}
