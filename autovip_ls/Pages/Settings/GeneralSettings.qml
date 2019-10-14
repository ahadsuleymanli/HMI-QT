import QtQuick 2.4
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import ck.gmachine 1.0
import MyLang 1.0
import QtGraphicalEffects 1.0
import "../../Components"
import closx.smanager 1.0
import QtQuick.Extras 1.4
import QtGraphicalEffects 1.0
import closx.updater 1.0
import closx.smanager 1.0


BasePage {
    id:root
    caption: qsTr("GENERAL SETTINGS") + mytrans.emptyString
    pageName: "GeneralSettings"
    property date cur_date: new Date()
    function init()
    {
        timesetter.refresh();
        autotime.checked = csetter.isAutoTimeSync();
    }
    SettingsManager{
        id:smanager
    }


    Text{
        id:textSingleton
        font.family: GSystem.myriadproita.name
        font.pixelSize: 10
    }
    Rectangle{
        y:200
        width:250
        height:250
        color:"#00000000"
        //color:"white"
        MouseArea{
                anchors.fill: parent
                onPressAndHold: {
                        GSystem.changePage("Calibration");
                    }
        }
    }




    Rectangle{
        width:612
        height:500
        color:"transparent"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        ColumnLayout
        {
            width:300
            height:300
            spacing: 40
            Rectangle{
                color:"transparent"
                height:100

                RowLayout{
                    x: 0
                    y: 47
                    width: 640
                    height: 100
                    spacing:20
                    Rectangle{
                        width:100
                        height: 30
                        color:"transparent"
                        Text{
                            text:qsTr("Language:") + mytrans.emptyString
                            font.family:GSystem.myriadproita.name
                            font.pixelSize: 24
                            color: "white"
                        }
                    }
                    RowLayout{
                        x: 180
                        width: 400
                        height: 80
                        Layout.leftMargin: 60
                        spacing:20
                        anchors.verticalCenter: parent.verticalCenter
                        Rectangle
                        {
                            id:languageRectangle
                            width:120
                            height:80
                            color: "transparent"
                            border.width: 2
                            border.color:Qt.rgba(0/255, 108/255, 128/255,0.6)
                            anchors.verticalCenter: parent.verticalCenter
                            Image{
                                id:turkish
                                source:"qrc:/design/settings/turkish.png"
                                sourceSize.height: 80
                                sourceSize.width: 120
                                width: 120
                                height: 80
                                fillMode: Image.Stretch
                                antialiasing: true
                                smooth: true
                                opacity: smanager.lang==125 ? 1 : 0.2
                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: {
                                        SM.lang = MyLang.TR
                                        chinese.opacity = 0.2
                                        english.opacity = 0.2
                                        turkish.opacity = 1
                                        GSystem.rstarter.come();
                                    }
                                }
                            }
                        }

                        Rectangle{
                            id: rectangle
                            width:120
                            height:80
                            color: "transparent"
                            border.width: 2
                            border.color:Qt.rgba(0/255, 108/255, 128/255,0.6)
                            anchors.verticalCenter: parent.verticalCenter
                            Image{
                                id:english
                                x: 0
                                y: 0
                                source:"qrc:/design/settings/english.png"
                                sourceSize.height: 80
                                sourceSize.width: 120
                                width: 120
                                height:80
                                opacity: smanager.lang==31 ? 1 : 0.2
                                fillMode: Image.Stretch
                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: {
                                        SM.lang = MyLang.ENG
                                        chinese.opacity = 0.2
                                        turkish.opacity = 0.2
                                        english.opacity = 1
                                        GSystem.rstarter.come();
                                        }
                                    }
                                }
                            }

                        Rectangle{
                            id:chRectangle
                            width:120
                            height:80
                            color: "transparent"
                            border.width: 2
                            border.color:Qt.rgba(0/255, 108/255, 128/255,0.6)
                            anchors.verticalCenter: parent.verticalCenter
                            Image{
                                id:chinese
                                source:"qrc:/design/settings/chinese.png"
                                sourceSize.height: 80
                                sourceSize.width: 120
                                width: 120
                                height:80
                                fillMode: Image.Stretch
                                antialiasing: true
                                smooth: true
                                opacity: smanager.lang==25 ? 1 : 0.2
                                    MouseArea{
                                    anchors.fill: parent
                                    onClicked: {
                                        SM.lang = MyLang.CH
                                        chinese.opacity = 1
                                        turkish.opacity = 0.2
                                        english.opacity = 0.2
                                        GSystem.rstarter.come();
                                    }
                                }
                            }
                        }
                    }
                }
            }
            Rectangle{
                height:100
                color:"transparent"

                RowLayout{
                    x: 0
                    y: 21
                    width: 400
                    height: 100
                    spacing:20
                    Rectangle{
                        width:100
                        height: 30
                        color:"transparent"
                        Text{
                            text:qsTr("Auto Time:") + mytrans.emptyString
                            font.family:GSystem.myriadproita.name
                            font.pixelSize: 24
                            color: "white"
                        }
                    }
                    Switch{
                        id:autotime
                        x: 50
                        text:qsTr("Auto") + mytrans.emptyString

                    }
                }
            }

            TimeSetter{
                id:timesetter
                y: 310
                mode:!autotime.checked
            }

            Updater{
                id:myUpdater
            }

            Rectangle{
                height:100
                color:"transparent"

                RowLayout{
                    width: 400
                    height: 100
                    spacing:20
                    Rectangle{
                        width:100
                        height: 30
                        color:"transparent"
                        Text{
                            text:qsTr("Update:") + mytrans.emptyString
                            font.family:GSystem.myriadproita.name
                            font.pixelSize: 24
                            color: "white"
                        }
                    }
                    Rectangle{
                        id: updatebg
//                        x: 180
                        anchors.left: parent.left
                        anchors.leftMargin: 180
                        width: 164
                        height: 50
                        color:"#0f0f0f"
                        border.width: 1
                        border.color:Qt.rgba(0/255, 108/255, 128/255,0.6)
//                                  anchors.verticalCenter: parent.verticalCenter
//                                  anchors.left: parent.left
//                                  anchors.leftMargin: 30
                        Text{
                            anchors.centerIn: parent
                            text:qsTr("Check for Updates") + mytrans.emptyString
                            font.family:GSystem.myriadproita.name
                            font.pixelSize: 18
                            color: "white"
                        }
                        MouseArea{
                            x: 0
                            anchors.rightMargin: 0
                            anchors.bottomMargin: 0
                            anchors.leftMargin: 0
                            anchors.topMargin: 0
                            anchors.fill: parent
                            onClicked: {
                                updatespinner.visible=true;
                                spinneranimation.running=true;
                                updatetimer1.running=true;
                                updatetimer2.running=true;
                                myUpdater.checkUpdate();
                                updatewarning.visible=false;
                            }
                            onPressed: {
                                updatebg.color =  Qt.rgba(0/255, 108/255, 128/255,0.6)
                            }
                            onReleased: {
                                updatebg.color =  "#0f0f0f"
                            }
                        }
                    }
                    Image {
                        id: updatespinner
                        source: "qrc:/design/general/spinner.png"
                        visible: false
                        width: 45
                        height: 45
                        sourceSize.height: 45
                        sourceSize.width: 45
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: updatebg.right
                        anchors.leftMargin: 20
                    }
                    Text{
                        id:updatewarning
                        visible: false
                        text:qsTr("Error: No Update Found! Check your internet connection.") + mytrans.emptyString
                        font.family:GSystem.myriadproita.name
                        font.pixelSize: 15
                        color: "white"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: updatebg.right
                        anchors.leftMargin: 20
                    }

                    NumberAnimation {
                        id:spinneranimation
                        target: updatespinner
                        property: "rotation"
                        duration: 800
                        from:0
                        to:360
                        running: false
                        loops: Animation.Infinite
                    }
                    Timer{
                        id:updatetimer1
                        interval:180000
                        running: false
                        repeat: false
                        onTriggered: {
                            updatespinner.visible=false;
                            spinneranimation.running=false;
                            updatetimer2.running=false;
                            updatewarning.visible=true;
                        }
                    }
                    Timer{
                        id:updatetimer2
                        interval:500
                        running: false
                        repeat: true
                        onTriggered: {
                            if(update_manager.checkUnzipped()){
                                updatespinner.visible=false;
                                spinneranimation.running=false;
                                updatetimer2.running=false;
                                updatetimer1.running=false;
                                updater.visible=true;
                                updaterbtn.visible=true;
                            }
                        }
                    }

                }
            }
        }

        }

}













/*##^## Designer {
    D{i:33;anchors_y:0}
}
 ##^##*/
