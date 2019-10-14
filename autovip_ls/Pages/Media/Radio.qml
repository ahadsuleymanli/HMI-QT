import QtQuick 2.0
import QtQuick.Layouts 1.1
import "../../Components"

BasePage {
    id:root
    caption:qsTr("RADIO FM") + mytrans.emptyString
    ListModel{
        id:radioModel
        ListElement{
            frq:"97.2"
            name:"METRO FM"
        }
        ListElement{
            frq:"100.4"
            name:"RD FENOMEN"
        }
        ListElement{
            frq:"100.8"
            name:"JOY FM"
        }
        ListElement{
            frq:"106.0"
            name:"PAL STATION"
        }
        ListElement{
            frq:"100.0"
            name:"POWER FM"
        }
    }

    Component{
        id:radioStation
        RadioStationItem{
            visible: PathView.onPath
            scale: PathView.itemScale
            z:PathView.itemScale
            fmtext: name
            fmval: frq + " MHz"
            isCurrent: PathView.isCurrentItem
        }
    }

    PathView{
        x:0
        y:226
        width:1280
        height:333
        delegate: radioStation
        model:radioModel
        focus:true
        path: Path{
            startX: 0
            startY: parent.height / 2
            PathAttribute{
                name:"itemScale"
                value:0.5
            }
            PathLine{
                x:parent.width * 0.45
                y:parent.height / 2
            }
            PathAttribute{
                name:"itemScale"
                value:0.8
            }
              PathPercent { value: 0.48; }
            PathLine{
                x:parent.width/2
                y:parent.height / 2
            }
            PathAttribute{
                name:"itemScale"
                value:0.9
            }
            PathLine{
                x:parent.width *  0.55
                y:parent.height / 2
            }
            PathAttribute{
                name:"itemScale"
                value:0.8
            }

            PathPercent { value: 0.52; }
            PathLine{
                x:parent.width
                y:parent.height / 2
            }
            PathAttribute{
                name:"itemScale"
                value:0.5
            }
        }
        pathItemCount: 6
        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5

    }
    RadioModMenu{
        y:563
        x:0
        width:parent.width/2
    }
    RadBtnMenu
    {
       x:parent.width/2
       y:563
       width:parent.width/2
    }
}
