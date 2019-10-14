import QtQuick 2.0
import ck.gmachine 1.0

Item {
    width:512
    state: GSystem.radioMode
    states:
        [
        "DAB",
        "FM",
        "AM"
        ]

    function changeMode(sl)
    {
        if(state === sl)
            return;
        GSystem.prevRadioMode = state
        state=sl;
        GSystem.radioMode = sl
    }

    Item{
        x:0
        y:0
        width:512
        height:40
            Row{
            spacing: 2
            anchors.fill: parent
            FmBtn{
                id:dab
                text:qsTr("DAB") + mytrans.emptyString
                modeName: "DAB"
                onModSelected: function(sl){ changeMode(sl)}
            }
            FmBtn{
                id:fm
                text:qsTr("FM") + mytrans.emptyString
                modeName: "FM"
                onModSelected: function(sl){ changeMode(sl)}
            }
            FmBtn{
                id:am
                onModSelected: function(sl){ changeMode(sl)}
                text:qsTr("AM") + mytrans.emptyString
                modeName: "AM"
            }
            }
    }
    Component.onCompleted: {
        state = GSystem.radioMode;
    }

}
