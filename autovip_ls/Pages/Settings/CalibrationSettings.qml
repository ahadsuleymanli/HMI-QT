import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import ck.gmachine 1.0
import MyLang 1.0
import QtQuick.Controls.Material 2.2
import "../../Components"

BasePage{
    id:root
    caption: qsTr("CALIBRATION") + mytrans.emptyString
    pageName: ""
    function init()
    {
        console.log("Calibration Page");
    }
   GridLayout {
    id: grid
    width:950
    rowSpacing: 15
    anchors.centerIn: parent
    columns:4
    CalibreButton{ text:qsTr("BAR ") + mytrans.emptyString; width:200; page:"BarMotorCalibration";}
    CalibreButton{ text:qsTr("TV ") + mytrans.emptyString; width:200; page:"TvMotorCalibration"; }
    CalibreButton{ text:qsTr("ESPRESSO 1 ") + mytrans.emptyString; width:200; page:"EspressoMotor1"; }
    CalibreButton{ text:qsTr("ESPRESSO 2 ") + mytrans.emptyString; width:200; page:"EspressoMotor2"; }

    CalibreButton{ text:qsTr("DRAWER 1 ") + mytrans.emptyString; width:200; page:"DrawerMotor1";}
    CalibreButton{ text:qsTr("DRAWER 2 ") + mytrans.emptyString; width:200; page:"DrawerMotor2";}
    CalibreButton{ text:qsTr("DRAWER 3 ") + mytrans.emptyString; width:200; page:"DrawerMotor3";}
    CalibreButton{ text:qsTr("DRAWER 4 ") + mytrans.emptyString; width:200; page:"DrawerMotor4";}


    CalibreButton{ text:qsTr("THIRD FOOTREST M1 ") + mytrans.emptyString; width:200; page:"ThirdFootrestM1";}
    CalibreButton{ text:qsTr("THIRD FOOTREST M2 ") + mytrans.emptyString; width:200; page:"ThirdFootrestM2";}
    CalibreButton{ text:qsTr("FOURTH FOOTREST M1 ") + mytrans.emptyString; width:200; page:"FourthFootrest1";}
    CalibreButton{ text:qsTr("FOURTH FOOTREST M2 ") + mytrans.emptyString; width:200; page:"FourthFootrest2";}


    CalibreButton{ text:qsTr("FIRST SEAT HEAD ") + mytrans.emptyString; width:200; page:"FirstSeatHead";}
    CalibreButton{ text:qsTr("SECOND SEAT HEAD ") + mytrans.emptyString; width:200; page:"SecondSeatHead";}
    CalibreButton{ text:qsTr("THIRD TABLE ") + mytrans.emptyString; width:200; page:"ThirdTableCalibration";}
    CalibreButton{ text:qsTr("FOURTH TABLE ") + mytrans.emptyString; width:200; page:"FourthTableCalibration";}

    CalibreButton{ text:qsTr("RESTORE OLDER VERSION ") + mytrans.emptyString; width:200; page:"RestoreOlderVersion";}
}
}
