import QtQuick 2.4
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.3
import ck.gmachine 1.0
import MyLang 1.0
import QtGraphicalEffects 1.0
import "../../Components"
import QtQuick.Extras 1.4
import QtGraphicalEffects 1.0
import closx.updater 1.0

BasePage {
    id:root
    caption: qsTr("GENERAL SETTINGS") + mytrans.emptyString
    pageName: "GeneralSettings"
    property date cur_date: new Date()
    property alias volumeCheckBoxChecked:  volumeCheckBox.checked
    signal volumeVisible(bool visible)
    function init()
    {
        timesetter.refresh();
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




    Item{
        anchors.fill: parent
        anchors.leftMargin: 200
        anchors.topMargin: 100
        anchors.bottomMargin: 100
        ColumnLayout
        {
            anchors.fill: parent
            spacing: 20
            RowLayout{
                Layout.topMargin:60
                Layout.fillWidth: true
                height: childrenRect.height
                spacing:10

                Text{
                    text:qsTr("Language:") + mytrans.emptyString
                    font.family:GSystem.myriadproita.name
                    font.pixelSize: 24
                    color: "white"
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
                            opacity: SM.lang==125 ? 1 : 0.2
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
                            opacity: SM.lang==31 ? 1 : 0.2
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
                            opacity: SM.lang==25 ? 1 : 0.2
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
            RowLayout{
                Layout.fillWidth: true
                height: childrenRect.height
                spacing: 40
                Text{
                    text:qsTr("Auto Time:") + mytrans.emptyString
                    font.family:GSystem.myriadproita.name
                    font.pixelSize: 24
                    color: "white"
                }
                Switch{
                    id:autotime
                    Layout.leftMargin: 20
                    text:qsTr("Auto") + mytrans.emptyString
                    Material.accent: Material.Blue

                }
            }

            TimeSetter{
                id:timesetter
                mode:!autotime.checked
            }
            RowLayout{
                Layout.fillWidth: true
                height: childrenRect.height
                spacing:25
                Text{
                    text:qsTr("Volume Level:") + mytrans.emptyString
                    font.family:GSystem.myriadproita.name
                    font.pixelSize: 24
                    color: "white"
                }
                CheckBox{
                    id: volumeCheckBox
                    Material.accent: Material.Blue
                    enabled: SM.amp
                    onCheckedChanged: {
                        root.volumeVisible(checked)
                    }
                    Component.onCompleted: if(SM.amp) checked = true
                }
            }



            Updater{
                id:myUpdater
                onUpdateStateChanged: {
                    if(updateState === 2){
                        updateInfo.text = qsTr("Download failed please check internet connection.")+ mytrans.emptyString;
                        updateInfo.visible = true;
                    }
                    else if(updateState === 3){
//                        if(update_manager.checkUnzipped()){
                            updatespinner.visible=false;
                            spinneranimation.running=false;
                            updatetimer1.running=false;
                            updater.visible=true;
                            updaterbtn.visible=true;
                            updatertext.changeLogText = myUpdater.changeLog();
                            updateInfo.visible = true;
//                        }
                    }
                    else if(updateState === 4){
                        updatespinner.visible=false;
                        spinneranimation.running=false;
                        updatetimer1.running=false;
                        updateInfo.text =qsTr("Current Version: ")+ mytrans.emptyString +myUpdater.currentVersion;
                        updateInfo.visible = true;
                    }
                }
                Component.onCompleted: {
                    if(SM.autoUpdate){
                        updatespinner.visible=true;
                        spinneranimation.running=true;
                        updatetimer1.running=true;
//                        updatetimer2.running=true;
                        updateInfo.visible=false;
                        myUpdater.checkUpdate();
                    }
                }
            }
            Connections{
                target: updateMouseArea
                onClicked: myUpdater.makeUpdate()
            }

            RowLayout{
                Layout.fillWidth: true
                height: childrenRect.height
                spacing:20

                Text{
                    text:qsTr("Update:") + mytrans.emptyString
                    font.family:GSystem.myriadproita.name
                    font.pixelSize: 24
                    color: "white"
                }
                Rectangle{
                    id: updatebg
                    anchors.left: parent.left
                    anchors.leftMargin: 180
                    width: 164
                    height: 50
                    color:"#0f0f0f"
                    border.width: 1
                    border.color:Qt.rgba(0/255, 108/255, 128/255,0.6)
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
//                            updatetimer2.running=true;
                            myUpdater.checkUpdate();
                            updateInfo.visible=false;
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
                    id:updateInfo
                    visible: true
                    text: qsTr("Current Version: ") + " " +myUpdater.currentVersion
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
                        updateInfo.text=qsTr("No Update Found! ") + qsTr("Current Version: ") +myUpdater.currentVersion +mytrans.emptyString;
                        updateInfo.visible = true;
                    }
                }
                Timer{
                    id:updatetimer2
                    interval:500
                    running: false
                    repeat: true
                    onTriggered: {
//                        if(update_manager.checkUnzipped()){
//                            updatespinner.visible=false;
//                            spinneranimation.running=false;
//                            updatetimer2.running=false;
//                            updatetimer1.running=false;
//                            updater.visible=true;
//                            updaterbtn.visible=true;
//                        }
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
