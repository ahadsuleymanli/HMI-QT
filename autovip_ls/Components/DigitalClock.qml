import QtQuick 2.0
import QtQuick.Layouts 1.1
import ck.gmachine 1.0

Rectangle {
    id : clock
    property alias running: timer.running
    property date date

    antialiasing: true
    signal newDay()

    width: spinnerLayout.width
    height: spinnerLayout.height

    color : "transparent"

    Timer {
        id : timer
        interval: 500; running: true; repeat: true
        onTriggered: function() {
            date = new Date;
            clock.newDay();
        }
    }

    RowLayout {
        id : spinnerLayout
        spacing: 2

        //Spinner { max: 24; value: date.getHours(); }
        Text {
            color:"#CFD1D2"
            font.family: GSystem.centurygothic.name
            font.pixelSize: 44
            text:date.toLocaleTimeString(Qt.locale(),"hh:mm")
        }
        //Rectangle { color : "white"; width: 2; height: 50 }
        //Spinner { max: 60; value: date.getMinutes(); }
        //Rectangle { color : "white"; width: 2; height: 50 }
        //Spinner { max: 60; value: date.getSeconds(); }
    }
}
