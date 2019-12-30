import QtQuick 2.0
import QtQuick.Layouts 1.3
import "../../Components"
import ColorComponents 1.0
import QtGraphicalEffects 1.0
import ck.gmachine 1.0

BasePage {
    id: root
    caption:qsTr("Lights") + mytrans.emptyString
    property color previousColor: "transparent"
    property color ceilColor: serial_mng.ceilingcolor
    property color sideColor: serial_mng.sidecolor
    property color inSideColor: serial_mng.insidecolor
    property ColorComponents targetColorItem: ceilColorComponent
    property int delay: -1
    property int selected: -1
    Connections{
        target:serial_mng
        onCeilingcolorChanged:function(val)
        {
            root.ceilColor = val;
        }
        onSidecolorChanged:function(val)
        {
            root.sideColor = val;
        }
        onInsidecolorChanged:function(val)
        {
            root.inSideColor = val;

        }
    }
    function init()
    {
        serial_mng.sendKey("lights/ceiling_request",true,delay);
        serial_mng.sendKey("lights/inside_request",true,delay);
        serial_mng.sendKey("lights/side_request");
//        GSystem.createLightsModel();
//        leftMenu.model=GSystem.lightsModel;
    }
    function closeAll()
    {
        ceilColorComponent.toggleOff();
        sideColorComponent.toggleOff();
        insideColorComponent.toggleOff();

        if (c3.color != "#000000") {
            c3.color = "#000000";
            serial_mng.sendKey("lights/rightreading_onoff",true,delay);
        }
        if (c4.color != "#000000"){
            c4.color = "#000000";
            serial_mng.sendKey("lights/leftreading_onoff",true,delay);
        }

    }

    function turn_off_lights()
    {
        root.closeAll();
    }
    function turn_on_lights_white()
    {
                sideColorComponent.color = "#FFFFFF";
                insideColorComponent.color = "#FFFFFF";
                ceilColorComponent.color = "#FFFFFF";

    }
    function turn_on_lights_red()
    {
                sideColorComponent.color = "#FF0000";
                insideColorComponent.color = "#FF0000";
                ceilColorComponent.color = "#FF0000";

    }
    function turn_on_lights_green()
    {
                sideColorComponent.color = "#00FF00";
                insideColorComponent.color = "#00FF00";
                ceilColorComponent.color = "#00FF00";

    }
    function turn_on_lights_blue()
    {
                sideColorComponent.color = "#0000FF";
                insideColorComponent.color = "#0000FF";
                ceilColorComponent.color = "#0000FF";

    }

    function cl_white_lights()
    {
        ceilColorComponent.color = "#FFFFFF";
    }

    function cl_red_lights()
    {
        ceilColorComponent.color = "#FF0000";
    }

    function cl_green_lights()
    {
        ceilColorComponent.color = "#00FF00";
    }

    function cl_blue_lights()
    {
        ceilColorComponent.color = "#0000FF";
    }

    function cl_turnoff_lights()
    {
        ceilColorComponent.color = "#000000";
    }

    function il_white_lights()
    {
        insideColorComponent.color = "#FFFFFF";
    }

    function il_red_lights()
    {
        insideColorComponent.color = "#FF0000";
    }

    function il_green_lights()
    {
        insideColorComponent.color = "#00FF00";
    }

    function il_blue_lights()
    {
        insideColorComponent.color = "#0000FF";
    }

    function il_turnoff_lights()
    {
        insideColorComponent.color = "#000000";
    }


    function side_white_lights()
    {
        sideColorComponent.color = "#FFFFFF";
    }

    function side_red_lights()
    {
        sideColorComponent.color = "#FF0000";
    }

    function side_green_lights()
    {
        sideColorComponent.color = "#00FF00";
    }

    function side_blue_lights()
    {
        sideColorComponent.color = "#0000FF";
    }

    function side_turnoff_lights()
    {
        sideColorComponent.color = "#000000";
    }


    function showInfo()
    {
            GSystem.info.src = "qrc:/design/general/saved.svg"
            GSystem.info.message = "";
            GSystem.info.start();
    }
    function hexToRgb(hex) {
            var shorthandRegex = /^#?([a-f\d])([a-f\d])([a-f\d])$/i;
            hex = "" + hex;
            hex = hex.replace(shorthandRegex, function(m, r, g, b) {
            return r + r + g + g + b + b;
            });

            var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
            return result ? {
            r: parseInt(result[1], 16),
            g: parseInt(result[2], 16),
            b: parseInt(result[3], 16)
            } : null;
    }
    function changeAllColor(r,g,b)
    {
        sideColor=Qt.rgba(r/255, g/255, b/255,1);
        ceilColor=Qt.rgba(r/255, g/255, b/255,1);
        inSideColor=Qt.rgba(r/255, g/255, b/255,1);
        sendSideColor(sideColor);
        sendCeilColor(ceilColor);
        sendInsideColor(inSideColor);
        console.log("All color changed to r: " + r + " g: "+ g + " b: " + b);
    }


    function sendCeilColor(p_color)
    {
//        console.log("ceiling color changed : "+p_color);
        var parts = root.hexToRgb(p_color);
        serial_mng.sendKey("lights/ceiling_red",false,root.delay,parts.r);
        serial_mng.sendKey("lights/ceiling_green",false,root.delay,parts.g);
        serial_mng.sendKey("lights/ceiling_blue",false,root.delay,parts.b);
    }
    function sendSideColor(p_color)
    {
//        console.log("side color changed : "+p_color);
        var parts = root.hexToRgb(p_color);
        serial_mng.sendKey("lights/side_red",false,root.delay,parts.r);
        serial_mng.sendKey("lights/side_green",false,root.delay,parts.g);
        serial_mng.sendKey("lights/side_blue",false,root.delay,parts.b);
    }
    function sendInsideColor(p_color)
    {
//        console.log("inside color changed : "+p_color);
        var parts = root.hexToRgb(p_color);
        serial_mng.sendKey("lights/inside_red",false,root.delay,parts.r);
        serial_mng.sendKey("lights/inside_green",false,root.delay,parts.g);
        serial_mng.sendKey("lights/inside_blue",false,root.delay,parts.b);
    }
    onCeilColorChanged: function(){
    }
    onSideColorChanged: function(){
    }
    onInSideColorChanged: function(){
    }
    function pickTarged(id){
        switch(id)
        {
        case 1:
             root.targetColorItem = ceilColorComponent;
            break;
        case 2:
             root.targetColorItem = insideColorComponent
            break;
        case 3:
             root.targetColorItem = sideColorComponent
            break;
        }
    }
    function getColorRegionId(){
        switch(root.targetColorItem)
        {
        case ceilColorComponent:
            return 1;
        case insideColorComponent:
            return 2;
        case sideColorComponent:
            return 3;
        }
    }
    function getColorRegionItem(id){
        switch(id)
        {
        case 1:
            return ceilColorComponent;
        case 2:
            return insideColorComponent;
        case 3:
            return sideColorComponent;
        }
    }
    function changeSelection(id)
    {
        pickTarged(id);
        var msg = {'ind': id-1, 'model': leftMenu.model};
        worker.sendMessage(msg);
    }


    LeftToggleMenu{
        id:leftMenu
        selection: true
        onLightsToggle: function (index){
            var target = getColorRegionItem(index+1);
            var val = target.toggleOnOff();
//            sSlider.color =

        }
        onClicked: function(ind)
        {
            changeSelection(ind+1)
        }
        WorkerScript {
        id: worker
        source: "qrc:/scripts/modelworker.js"
        }

    }
    Rectangle{
        x:0
        y:0
        color: "transparent"
        width: parent.width
        height: parent.height



    ColorComponents {
        id: ceilColorComponent
        saturation: 1.0
        value: 1.0
        color:"white"
        onColorChanged: {
                  var color = ceilColorComponent.toRGBString();
                  root.sendCeilColor(color);
                  if(!Qt.colorEqual(color,serial_mng.ceilingcolor))
                    {
                        serial_mng.ceilingcolor = color;
                    }
        }
    }


    ColorComponents {
        id: sideColorComponent
        saturation: 1.0
        value: 1.0
        color:"white"
        onColorChanged: {
                  var color = sideColorComponent.toRGBString();
                  root.sendSideColor(color);
                  if(!Qt.colorEqual(color,serial_mng.sidecolor))
                    {
                            serial_mng.sidecolor = color;
                    }
        }
    }

    ColorComponents {
        id:insideColorComponent
        saturation: 1.0
        value: 1.0
        color:"white"
        onColorChanged: {
                  var color = insideColorComponent.toRGBString();
                  root.sendInsideColor(color)
                  if(!Qt.colorEqual(color,serial_mng.insidecolor))
                    {
                            serial_mng.insidecolor = color;
                    }
        }
    }


    ColorSlider{
        id: hSlider
        x:274
        y:200
        height:360
        width:60
        color:"black"
        value: 1.0 - targetColorItem.hue
        gradient: Gradient {
            GradientStop { position: 0/6; color: "red" }
            GradientStop { position: 1/6; color: "magenta" }
            GradientStop { position: 2/6; color: "blue" }
            GradientStop { position: 3/6; color: "cyan" }
            GradientStop { position: 4/6; color: "lime" }
            GradientStop { position: 5/6; color: "yellow" }
            GradientStop { position: 6/6; color: "red" }
        }
        onMouseYChanged: { targetColorItem.hue = Math.max(0.0, Math.min(1.0 - mouseY / height, 1.0)); targetColorItem.value = 1; }
    }

    Item{
        id:cmodel
        x:366
        y:200
        width:620
        height:500
        clip: true
        Rectangle{
            id:ceil
            x:175
            y:30
            width: 250
            height: 250
            border.width: 0
            color:ceilColor
        }
        Image{
            id:imagem
            width: 622
            height: 362
            anchors.verticalCenterOffset: -69
            anchors.topMargin: 0
            anchors.verticalCenter: parent.verticalCenter
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.left: parent.left
            smooth: true
            enabled: true
            z: 1
            scale: 1
            transformOrigin: Item.Center
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            source:"qrc:/design/lights/icon-tavan.png"
            antialiasing: false
        }

        Rectangle{
            id:mb
            x:132
            y:271
            width:350
            height:91
            rotation: 0
            color:inSideColor
            }
        Rectangle{
            id:rb
            x:565
            y:187
            width:55
            height:175
            rotation: 0
            color:inSideColor
            }
        Rectangle{
            id:lb
            x:0
            y:187
            width:44
            height:175
            rotation: 0
            color:inSideColor
            }
         Rectangle{
             id:c1
             x:50
             y:259
             width:45
             height:82
             color:sideColor
             rotation: 0
             visible: SM.sidelight()
         }
         Rectangle{
             id:c2
             x:517
             y:266
             width:48
             height:75
             color:sideColor
             visible: SM.sidelight()
         }
         Rectangle{
             id:c3
             x:66
             y:153
             width:96
             height:50
             color:"black"
         }
         Rectangle{
             id:c4
             x:450
             y:160
             width:76
             height:43
             color:"black"
         }
         Glow{
             source:c3
             id:gl1
             anchors.fill: c3
             color:c3.color
             radius: 5
             anchors.rightMargin: 13
             anchors.bottomMargin: 27
             anchors.leftMargin: 17
             anchors.topMargin: 20
             z: 5
         }
         Glow{
             source:c4
             id:gl2
             anchors.fill: c4
             color:c4.color
             radius: 5
             anchors.rightMargin: 0
             anchors.bottomMargin: 27
             anchors.leftMargin: 9
             anchors.topMargin: 13
             z: 5
         }
        }
    }

    ColorSlider{
        id: sSlider
        x:274
        width: 712
        height:30
        color:"black"
        anchors.top: parent.top
        anchors.topMargin: 570
        orientation: Qt.Horizontal
        value: 1.0 - targetColorItem.saturation
        gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.hsla(targetColorItem.hue, 1.0, 0.5, 1.0) }
                GradientStop { position: 1.0; color: "white"}
        }
        onMouseXChanged: targetColorItem.saturation = Math.max(0.0, Math.min(1.0 - mouseX / width, 1.0));
    }
    ColumnLayout{
        spacing: 10
        id:cl1
        anchors.top:sSlider.bottom
        x:274
        anchors.topMargin: 5



        RowLayout{
           spacing: 10
           anchors.top: cl1.top
           anchors.right: parent.right
           id:rl1
           LightButton{
               Layout.preferredHeight: 30
               Layout.preferredWidth: 150
               text:qsTr("Close All") + mytrans.emptyString
               onClicked: {
                   root.closeAll();
//                   GSystem.createLightsModel();
//                   leftMenu.model=GSystem.lightsModel;
               }
               enabled: false
               visible: false
           }
           LightButton{
               Layout.preferredHeight: 30
               Layout.preferredWidth: 150
               text:qsTr("Memory 1") + mytrans.emptyString
               onClicked: {
                   var ceilColor = SM.getLightMemory(1,1);
                   var sideColor = SM.getLightMemory(1,2);
                   var inSideColor = SM.getLightMemory(1,3);
                   ceilColorComponent.color = ceilColor;
                   insideColorComponent.color = sideColor;
                   sideColorComponent.color = sideColor;
                   console.log("size"+ height, + " " + width)
//                   if(!Qt.colorEqual(ceil,ceilColor)) { root.ceilColor = ceilColor; }else{ sendCeilColor(ceilColor);}
//                   if(!Qt.colorEqual(root.inSideColor,inSideColor)) {root.inSideColor = inSideColor;}else{sendInsideColor(inSideColor);}
//                   if(!Qt.colorEqual(root.sideColor,sideColor)){ root.sideColor = sideColor;}else{ sendSideColor(sideColor);}
               }
               onHolded: {
                   SM.saveLightMemory(1,1,root.ceilColor);
                   SM.saveLightMemory(1,2,root.sideColor);
                   SM.saveLightMemory(1,3,root.inSideColor);
                   root.showInfo();
               }
           }
           LightButton{
               Layout.preferredHeight: 30
               Layout.preferredWidth: 150
               text:qsTr("Memory 2") + mytrans.emptyString
               onClicked: {
                   var ceilColor = SM.getLightMemory(2,1);
                   var sideColor = SM.getLightMemory(2,2);
                   var inSideColor = SM.getLightMemory(2,3);
                   ceilColorComponent.color = ceilColor;
                   insideColorComponent.color = sideColor;
                   sideColorComponent.color = sideColor;
//                   if(!Qt.colorEqual(root.ceilColor,ceilColor)) { root.ceilColor = ceilColor; }else{ sendCeilColor(ceilColor);}
//                   if(!Qt.colorEqual(root.inSideColor,inSideColor)) {root.inSideColor = inSideColor;}else{sendInsideColor(inSideColor);}
//                   if(!Qt.colorEqual(root.sideColor,sideColor)){ root.sideColor = sideColor;}else{ sendSideColor(sideColor);}
               }
               onHolded: {
                   SM.saveLightMemory(2,1,root.ceilColor);
                   SM.saveLightMemory(2,2,root.sideColor);
                   SM.saveLightMemory(2,3,root.inSideColor);
                   root.showInfo();
               }
           }
           LightButton{
               Layout.preferredHeight: 30
               Layout.preferredWidth: 150
               text:qsTr("Memory 3") + mytrans.emptyString
               onClicked: {
                    var ceilColor = SM.getLightMemory(3,1);
                    var sideColor = SM.getLightMemory(3,2);
                    var inSideColor = SM.getLightMemory(3,3);
                   ceilColorComponent.color = ceilColor;
                   insideColorComponent.color = sideColor;
                   sideColorComponent.color = sideColor;
               }
               onHolded: {
                   SM.saveLightMemory(3,1,root.ceilColor);
                   SM.saveLightMemory(3,2,root.sideColor);
                   SM.saveLightMemory(3,3,root.inSideColor);
                   root.showInfo();
               }
           }

        }

        RowLayout{
           spacing: 10
           id:bottomButtonsRow
           x:284
           LightButton{
               Layout.preferredHeight: 30
               Layout.preferredWidth: 310
               text:qsTr("Sol Tavan Okuma Lambası") + mytrans.emptyString
               onReleased: {
                   if (c3.color == "#fff6a6")
                   {
                       c3.color = "#000000";
                       serial_mng.sendKey("lights/rightreading_onoff",true,delay);

                   }else
                   {
                       c3.color = "#fff6a6";
                       serial_mng.sendKey("lights/rightreading_onoff",true,delay);
                   }
               }
           }

           LightButton{
               Layout.preferredHeight: 30
               Layout.preferredWidth: 310
               text:qsTr("Sağ Tavan Okuma Lambası") + mytrans.emptyString
               onReleased: {
                       if (c4.color == "#fff6a6")
                       {
                           c4.color = "#000000";
                           serial_mng.sendKey("lights/leftreading_onoff",true,delay);

                       }else
                       {
                           c4.color = "#fff6a6";
                           serial_mng.sendKey("lights/leftreading_onoff",true,delay);
                        }
                    }
               }



        }

    }
//    Rectangle{
//        anchors.fill: readingLigtsRow
//        anchors.leftMargin: -4
//        anchors.rightMargin: -20
//        anchors.topMargin: -2
//        anchors.bottomMargin: -4
//        color: "#44aa6c39"
//    }
    ColumnLayout{
        id:readingLigtsRow
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.bottomMargin: contentBottomMargin + 20
        anchors.leftMargin: 12
        spacing: 10
        visible: false
        Text {
            text: qsTr("Table Reading Lights")
            font.styleName: StyleItalic
            height: 30
            color: "white"
            font.pixelSize: 18
        }
        LightButton{
            id:leftReadingLight
            height: 30
            width: 150
            text:qsTr("Left Table") + mytrans.emptyString
            visible: false
            onReleased: {
                serial_mng.sendKey("lights/seatthree_reading_light");
            }
        }
        LightButton{
            id:rightReadingLight
            height: 30
            width: 150
            text:qsTr("Right Table") + mytrans.emptyString
            visible: false
            onReleased: {
                serial_mng.sendKey("lights/seatfour_reading_light");
            }
        }
    }

    Component.onCompleted: {
        root.delay = serial_mng.getLightsDelay();
        GSystem.createLightsModel(ceilColorComponent,sideColorComponent,insideColorComponent);
        leftMenu.model=GSystem.lightsModel;
        changeSelection(1);
        if (SM.seatReadingLight(3)||SM.seatReadingLight(4)){
            readingLigtsRow.visible=true;
            if (SM.seatReadingLight(3))
                leftReadingLight.visible=true;
            if (SM.seatReadingLight(4))
                rightReadingLight.visible=true;
        }
    }
}
