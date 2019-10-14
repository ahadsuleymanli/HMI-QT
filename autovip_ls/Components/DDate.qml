import QtQuick 2.0
import QtQuick.Layouts 1.1
import ck.gmachine 1.0

Rectangle {
    id : ddate
    property date date

    antialiasing: true

    width: spinnerLayout.width
    height: spinnerLayout.height

    color : "transparent"

    function refresh()
    {
        date = new Date();
        var ndate = date.toLocaleDateString(Qt.locale(),"dd MMM yyyy")
        mDate.text = ndate;
    }


    RowLayout {
        id : spinnerLayout
        spacing: 2

        //Spinner { max: 24; value: date.getHours(); }
        Text {
            id:mDate
            color:"#CFD1D2"
            font.family: GSystem.centurygothic.name
            font.pixelSize: 26
            text:""
        }
        //Rectangle { color : "white"; width: 2; height: 50 }
        //Spinner { max: 60; value: date.getMinutes(); }
        //Rectangle { color : "white"; width: 2; height: 50 }
        //Spinner { max: 60; value: date.getSeconds(); }
    }
}
