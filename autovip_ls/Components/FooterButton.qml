import QtQuick 2.0
import QtQuick.Layouts 1.1
import ck.gmachine 1.0
import QtGraphicalEffects 1.0

Item{
    id: root
    signal clicked
    signal pressed
    signal released
    height: GSystem.bottomIconHeight
    width: btnImage.width
    property alias bgSource : btnImage.source

    property alias overlayVisible: extOverlay.visible
    property alias overlayGradient: extOverlay.gradient
    property alias overlayStart: extOverlay.start
    property alias overlayEnd: extOverlay.end

    property string clickKey: ""
    property string pressKey: ""
    property string releaseKey: ""
    property bool info: true
    property string message: ""
    property bool toggled: false
    property bool isUnderClick: false
    property point infoPositionOffset: Qt.point(0,0)


    Item{
        width: btnImage.width
        anchors.horizontalCenter: parent.horizontalCenter
        Image {
            id: btnImage
            fillMode: Image.PreserveAspectFit
            antialiasing: true
            smooth: true
        }

        LinearGradient{
            id: extOverlay
            visible: false
            anchors.fill: btnImage
            source: btnImage
        }
        ColorOverlay {
           id:co
           visible: false
           anchors.fill: btnImage
           source: btnImage
           color: Qt.rgba(191/255, 63/255, 191/255,0.6)
        }
    }


    MouseArea{
        anchors.fill: parent
        onClicked: {
            if(root.info)
            {
                    GSystem.info.src = btnImage.source;
                    GSystem.info.message = root.message;
                    GSystem.info.position = Qt.point(root.x - root.width/2 + infoPositionOffset.x,
                                                     620 + infoPositionOffset.y)
                    GSystem.info.start();
            }
            co.visible = false;
            if(clickKey){ serial_mng.sendKey(clickKey); }
            root.clicked();
        }
        onPressed: { co.visible = true; if(pressKey){ serial_mng.sendKey(pressKey); } isUnderClick = true; root.pressed();}
        onReleased:{ co.visible=false; if(releaseKey){serial_mng.sendKey(releaseKey);} isUnderClick = false; toggled = !toggled; root.released();}
        cursorShape: Qt.PointingHandCursor
    }
    Component.onCompleted: {
    }
}
