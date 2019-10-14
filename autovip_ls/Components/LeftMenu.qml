import QtQuick 2.0
import ck.gmachine 1.0
Rectangle{
            id:leftMenu
            color: GSystem.leftMenuColor
            width: GSystem.leftMenuWidth
            height:GSystem.leftMenuHeight
            radius: 10
            x:0
            clip: true
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 32
            property alias delegate: mview.delegate
            property alias model: mview.model
            PathView{
                id:mview
                width: parent.width
                height: parent.height
                y:0
                delegate: menuDelegate
                pathItemCount: 5
                focus:true
                preferredHighlightBegin: 0.5
                preferredHighlightEnd: 0.5
                snapMode:PathView.SnapToItem
                path: Path{
                    startX: parent.width/2
                    startY: 0
                    PathAttribute{ name:"itemScale"; value:0.5 }
                    PathAttribute { name: "itemZ"; value: 0 }
                    PathAttribute { name: "itemAngle"; value: -90.0; }

                    PathLine{ x:mview.width/2; y:mview.height * 0.4; }

                    PathLine{ x:mview.width/2; y:mview.height/2; }

                    PathAttribute{ name:"itemScale"; value:1}
                    PathAttribute { name: "itemZ"; value: mview.model.count; }
                    PathAttribute { name: "itemAngle"; value: 0.0; }

                    PathLine{ x:mview.width/2; y:mview.height * 0.6; }

                    PathLine{ x:parent.width/2; y:mview.height; }

                    PathAttribute{ name:"itemScale"; value:0.5; }
                    PathAttribute { name: "itemZ"; value: 0}
                    PathAttribute { name: "itemAngle"; value: 90; }
                }

            }

        Component {
            id:menuDelegate
            LeftButton{
                   id:wrapper
                   visible: PathView.onPath
                   scale:PathView.itemScale
                   bgsource: bg
                   z:PathView.itemZ
                   text :qsTr(name) + mytrans.emptyString
                   onClicked: {
                                GSystem.state = name;
                                GSystem.changePage(st);
                                myindex = mview.currentIndex;
                        }
                    property variant rotX: PathView.itemAngle
                    transform: Rotation {
                        axis { x: 1; y: 0; z: 0 }
                        angle: wrapper.rotX;
                        origin { x: 100; y: 100; }
                    }

                }
            }
        }
