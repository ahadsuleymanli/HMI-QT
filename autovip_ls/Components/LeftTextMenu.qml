import QtQuick 2.0
import ck.gmachine 1.0

Rectangle {
           id:root
           x:0
           clip:true
           anchors.verticalCenter: parent.verticalCenter
           property alias delegate: mview.delegate
           property alias model: mview.model
           property bool selection: false
           signal clicked(int index)
           signal released(int index)
           color: GSystem.leftTextMenuColor
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
                   text :qsTr(name)// + mytrans.emptyString
                   bgcolor:(model.selected)?GSystem.leftTextMenuItemPressedColor:GSystem.leftTextMenuItemColor
                   area.onPressed: {
                       if(typeof beforecode !== "undefined")
                       {
                         if(typeof delay !== "undefined" && delay > 0)
                         {
                            serial_mng.sendKey(beforecode,true,delay);
                         }else{
                            serial_mng.sendKey(beforecode);
                         }
                       }
                       if(!root.selection)
                       {
                               bgcolor = GSystem.leftTextMenuItemPressedColor;
                       }

                   }
                   area.onReleased: {
                       if(typeof releasecode !== "undefined")
                       {
                           if(typeof delay !== "undefined" && delay >0)
                           {
                                serial_mng.sendKey(releasecode,true,delay);
                           }else{
                                serial_mng.sendKey(releasecode);
                           }
                       }
                       root.released(model.index);
                       if(!root.selection)
                       {
                               bgcolor = GSystem.leftTextMenuItemColor;
                       }
                   }
                   area.onClicked: function(){
                                GSystem.state = name;

                                if(typeof sericode !== "undefined")
                                {
                                    serial_mng.sendKey(sericode);
                                }else if(typeof st !== "undefined")
                                {
                                    GSystem.changePage(st);
                                }
                                root.clicked(model.index);
                        }
                }
            }
}
