import QtQuick 2.0

Item {
    id:root
    RadBtn{
        id:presets
        x:0
        height:45
        width:214
        icon:"qrc:/design/radio/presets.svg"
        text:qsTr("PRESETS") + mytrans.emptyString
    }
    RadBtn{
        id :manualSearch
        x:214
        height:45
        width:271
        text:qsTr("MANUAL SEARCH") + mytrans.emptyString
        icon:"qrc:/design/radio/search.svg"
    }
}
