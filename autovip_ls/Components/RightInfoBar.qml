import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Item {
    width: infoLayout.width
    property alias intercomVisible: btnIntercom.visible
    function showVolumeBar(){
        if(generalsettings.volumeCheckBoxChecked) return;
        if(volumeBarHideAnim.running){
            volumeBarHideAnim.stop()
        }
        else
            volumeBar.opacity = 0
        volumeBar.visible = true
        volumeBarShowAnim.start()
        volumeBarVisibleTimer.restart()
    }
    Timer{
        id: volumeBarVisibleTimer
        interval: 3000; running: false; repeat: false
        onTriggered: volumeBarHideAnim.start()
    }

    ColumnLayout{
        id: infoLayout
        anchors{
            top: parent.top
        }

        width: childrenRect.width
        height: parent.height
        spacing: 15
        Image {
            id:btnIntercom
            Layout.alignment: Qt.AlignHCenter
            visible: false
            source : "qrc:/design/general/Intercom.svg"
        }
        VolumeBar{
            id: volumeBar
            Layout.alignment: Qt.AlignHCenter
            width: 100
            height: 100
            visible: false
        }
        Item{
            Layout.fillHeight: true
        }
    }
    Connections{
        target:generalsettings
        onVolumeVisible: volumeBar.visible = visible
    }

    PropertyAnimation{
        id: volumeBarShowAnim
        target: volumeBar
        property:"opacity"
        from:opacity
        to:1
        duration: 200
    }
    PropertyAnimation{
        id: volumeBarHideAnim
        target: volumeBar
        property:"opacity"
        from:1
        to:0
        duration: 1000
        onStopped: {
            if(!generalsettings.volumeCheckBoxChecked)
                volumeBar.visible = false
            volumeBar.opacity = 1
        }
    }
}
