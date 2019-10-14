import QtQuick 2.0
import ck.gmachine 1.0

Rectangle {
           id:root
           clip:true
           anchors.verticalCenter: parent.verticalCenter
           anchors.right: parent.right
           property alias delegate: mview.delegate
           property alias model: mview.model
           property bool selection: false
           signal clicked(int index)
           signal released(int index)
           color:Qt.rgba(0, 0, 0,0.4)
           border.width: 1
           border.color:Qt.rgba(0/255, 108/255, 128/255,0.6)
           width: GSystem.leftTextMenuWidth
           height:GSystem.leftTextMenuHeight
           ListView{
                id:mview
                interactive: false
                anchors.verticalCenter: root.verticalCenter
                anchors.verticalCenterOffset: 20
                spacing:20
                delegate: txtmenudlg
                width:root.width
                height: mview.model.count * 95
                focus:true
           }

        Component {
            id:txtmenudlg
            LeftTextButton{
                   id:wrapper
                   text :qsTr(name) + mytrans.emptyString

                   area.onPressed: {
                       if(typeof beforecode !== "undefined")
                       {
                         serial_mng.sendKey(beforecode);
                       }
                       if(!root.selection)
                       {
                               bgcolor = GSystem.leftTextMenuItemPressedColor;
                       }

                   }
                   area.onReleased: {
                       if(typeof releasecode !== "undefined")
                       {
                           serial_mng.sendKey(releasecode);
                       }
                       root.released(model.index);
                       if(!root.selection)
                       {
                               bgcolor = GSystem.leftTextMenuItemColor;
                       }
                   }
                   area.onClicked: {
                                GSystem.state = name;
                                if(typeof sericode !== "undefined")
                                {
                                    serial_mng.sendKey(serialcode);
                                }else if(typeof st !== "undefined")
                                {
                                    GSystem.changePage(st);
                                }
                                root.clicked(model.index);
                        }
                }
            }
}
