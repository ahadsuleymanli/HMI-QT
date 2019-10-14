import QtQuick 2.0
import ck.gmachine 1.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Extras 1.4
import QtGraphicalEffects 1.0
import closx.clocksetter 1.0
import closx.smanager 1.0

Rectangle{
    id:root
    width:tumbler.width
    height: tumbler.height
    property date cur_date: new Date()
    color:"transparent"
    property bool mode : false
    property variant date : { "day": "0" , "month": "Month", "year": "0000" }   // dummy valuess
    property variant time : { "hour": "-1", "minutes": "-1" }
    function refresh()
    {
        cur_date = new Date();
        console.log(cur_date.toDateString());
        console.log(cur_date.getDate());
        console.log(cur_date.getMonth());
        console.log(cur_date.getFullYear());
        tumbler.setCurrentIndexAt(0,cur_date.getDate()-1) ;
        tumbler.setCurrentIndexAt(1,cur_date.getMonth()-1) ;
        //dayColumn.currentIndex = cur_date.getDay();
        //monthColumn.currentIndex = cur_date.getMonth();
        var year  = cur_date.getFullYear();
        for (var i = 1980,j=0; i < 2100; ++i,++j) {
            if(i == year)
            {
                tumbler.setCurrentIndexAt(2,j) ;
            }
         }
        tumblerTime.setCurrentIndexAt(0,cur_date.getHours());
        tumblerTime.setCurrentIndexAt(1,cur_date.getMinutes());
    }
    RowLayout{
        visible: mode
        spacing: 30
        Rectangle{
        width:150
        height: 30
        color:"transparent"
        Text{
            text:qsTr("Date & Time:") + mytrans.emptyString
            font.family: GSystem.myriadproita.name
            font.pixelSize: 24
            color: "white"
        }
        }

        Tumbler {
        id: tumbler
        // TODO: Use FontMetrics with 5.4\
        implicitHeight: 100
        Label {
            id: characterMetrics
            font.bold: true
            font.pixelSize: textSingleton.font.pixelSize
            font.family:GSystem.myriadproita.name
            visible: false
            text: "M"
        }

        readonly property real delegateTextMargins: characterMetrics.width * 1.5
        readonly property var days: [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

        TumblerColumn {
            id: dayColumn
            model: ListModel{
            Component.onCompleted: {
                for(var i = 1; i < 32; ++i){
                append({value: i < 10 ? "0"+i.toString()  : i.toString()});
                }
            }
            }

        }
        TumblerColumn {
            id: monthColumn
            width: characterMetrics.width * 3 + tumbler.delegateTextMargins
            model: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
            //onCurrentIndexChanged: dayColumn.updateModel()
        }
        TumblerColumn {
            id:yearColumn
            width: characterMetrics.width * 4 + tumbler.delegateTextMargins
            model: ListModel {
            Component.onCompleted: {
                for (var i = 1980; i < 2100; ++i) {
                append({value: i.toString()});
                }
            }
            }
        }
        }


        Tumbler {
        id: tumblerTime
        // TODO: Use FontMetrics with 5.4\
        implicitHeight: 100
        Label {
            id: characterMetricsTime
            font.bold: true
            font.pixelSize: textSingleton.font.pixelSize
            font.family: GSystem.myriadproita.name
            visible: false
            text: "M"
        }
        readonly property real delegateTextMargins: characterMetrics.width * 1.5
        readonly property var days: [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

        TumblerColumn {
            id: hourColumn

            width: characterMetrics.width * 4 + tumbler.delegateTextMargins
            model: ListModel {
            Component.onCompleted: {
                for (var i = 0; i < 24; ++i) {
                append({value: i<10 ? "0"+i.toString() : i.toString()});
                }
            }
            }

        }

        TumblerColumn {
            id: minutesColumn
            width: characterMetrics.width * 4 + tumbler.delegateTextMargins
            model: ListModel {
            Component.onCompleted: {
                for (var i = 0; i < 60; ++i) {
                append({value: i<10 ? "0"+i.toString() : i.toString()});

                }
            }
            }
        }


        }

        SettingsManager{
            id:settingsmng
        }

        ClockSetter{
            id:clcksttr
        }

        Rectangle {
            x:0
            id:timesetrec
//            color: parent.color
//            border.color: "black"
//            border.width: 1
            height:100
            width:100
            color:"#0f0f0f"
            border.width: 1
            border.color:Qt.rgba(0/255, 108/255, 128/255,0.6)
            Text{
                    text: qsTr("SET") + mytrans.emptyString
                    color: "white"
                    anchors.centerIn: parent
                    font.pixelSize:30
                    font.family : GSystem.myriadproita.name
            }

        MouseArea{
            anchors.fill:parent
            onClicked: {
            console.log("Setting date and time");
            date.day = dayColumn.model.get(tumbler.getColumn(0).currentIndex).value
            date.month = monthColumn.model[tumbler.getColumn(1).currentIndex]
            date.year = yearColumn.model.get(tumbler.getColumn(2).currentIndex).value
            time.hour = hourColumn.model.get(tumblerTime.getColumn(0).currentIndex).value
            time.minutes = minutesColumn.model.get(tumblerTime.getColumn(1).currentIndex).value
            var timesum = time.hour + ":" + time.minutes;
            var hourdiff = time.hour - Qt.formatDateTime(new Date(), "h")*1
            var mindiff = time.minutes - Qt.formatDateTime(new Date(), "m")*1
            settingsmng.setTimeDiff(mindiff,hourdiff);
            serial_mng.sendKey("main/setclock",false,root.delay,timesum);
            console.log( "Date: " + date.day + " "+ date.month + " " + date.year );
            console.log( "Time: " + time.hour + " " + time.minutes );
            }
            onPressed: timesetrec.color = Qt.rgba(0/255, 108/255, 128/255,0.6)
            onReleased: timesetrec.color = "#0f0f0f"
        }
        }

    }
    RowLayout
    {
        visible: !mode
        Rectangle{
                width:150
                height: 30
                color:"transparent"
                Text{
                    text:qsTr("Region:") + mytrans.emptyString
                    font.family: GSystem.myriadproita.name
                    font.pixelSize: 24
                    color: "white"
                }
        }
        Tumbler {
        id: tumblerRegion
        implicitHeight: 100

        readonly property real delegateTextMargins: characterMetrics.width * 1.5
        readonly property var days: [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

        TumblerColumn {
            id: region
            width:150
            model: ["Turkey","China"]
            }
        }
        Rectangle {
            x:0
            color: "#1c1c1c"
//            border.color: "black"
//            border.width: 1
            height:100
            width:150
            radius: 4
            Text{
                    text: qsTr("SET") + mytrans.emptyString
                    anchors.centerIn: parent
                    color: "white"
                    font.pixelSize:30
                    font.family : GSystem.myriadproita.name
            }

        MouseArea{
            anchors.fill:parent
            onClicked: {
                        console.log("Setting date and time");
                        date.day = dayColumn.model.get(tumbler.getColumn(0).currentIndex).value
                        date.month = monthColumn.model[tumbler.getColumn(1).currentIndex]
                        date.year = yearColumn.model.get(tumbler.getColumn(2).currentIndex).value
                        time.hour = hourColumn.model.get(tumblerTime.getColumn(0).currentIndex).value
                        time.minutes = minutesColumn.model.get(tumblerTime.getColumn(1).currentIndex).value
                        var timesum = time.hour + ":" + time.minutes;
                        var hourdiff = time.hour - Qt.formatDateTime(new Date(), "h")*1
                        var mindiff = time.minutes - Qt.formatDateTime(new Date(), "m")*1
                        settingsmng.setTimeDiff(mindiff,hourdiff);
                        serial_mng.sendKey("main/setclock",false,root.delay,timesum);
                        console.log( "Date: " + date.day + " "+ date.month + " " + date.year );
                        console.log( "Time: " + time.hour + " " + time.minutes );
            }
            onPressed: timesetrec.color = "#212121"
            onReleased: timesetrec.color = "#1c1c1c"
        }
        }
    }
}
