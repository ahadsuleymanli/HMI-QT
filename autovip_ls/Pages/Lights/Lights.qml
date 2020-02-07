import QtQuick 2.0
import QtQuick.Layouts 1.3
import "../../Components"
import "Interior"
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
    property color ambientColor: serial_mng.ambientcolor
    property color leftReadingLight: "black"
    property color rightReadingLight: "black"
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
        onAmbientcolorChanged:function(val)
        {
            root.ambientColor = val;
        }
    }
    function init()
    {
        serial_mng.sendKey("lights/ceiling_request",true,delay);
        serial_mng.sendKey("lights/inside_request",true,delay);
        serial_mng.sendKey("lights/side_request",true,delay);
        serial_mng.sendKey("lights/ambient_request",true,delay);
    }
    function closeAll()
    {
        ceilColorComponent.toggleOff();
        sideColorComponent.toggleOff();
        insideColorComponent.toggleOff();
        ambientColorComponent.toggleOff();

        if (rightReadingLight != "#000000") {
            rightReadingLight = "#000000";
            serial_mng.sendKey("lights/rightreading_onoff",true,delay);
        }
        if (leftReadingLight != "#000000"){
            leftReadingLight = "#000000";
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
                ambientColorComponent.color = "#FFFFFF";
    }
    function turn_on_lights_red()
    {
                sideColorComponent.color = "#FF0000";
                insideColorComponent.color = "#FF0000";
                ceilColorComponent.color = "#FF0000";
                ambientColorComponent.color = "#FF0000";
    }
    function turn_on_lights_green()
    {
                sideColorComponent.color = "#00FF00";
                insideColorComponent.color = "#00FF00";
                ceilColorComponent.color = "#00FF00";
                ambientColorComponent.color = "#00FF00";
    }
    function turn_on_lights_blue()
    {
                sideColorComponent.color = "#0000FF";
                insideColorComponent.color = "#0000FF";
                ceilColorComponent.color = "#0000FF";
                ambientColorComponent.color = "#0000FF";
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

    function sendCeilColor(p_color)
    {
        var parts = root.hexToRgb(p_color);
        if (SM.starlight() && parts.r === parts.g && parts.r === parts.b){
            serial_mng.sendKey("lights/ceiling_red",false,root.delay,0);
            serial_mng.sendKey("lights/ceiling_green",false,root.delay,0);
            serial_mng.sendKey("lights/ceiling_blue",false,root.delay,0);
            serial_mng.sendKey("lights/starlight_value",false,root.delay,parts.r);
        }
        else{
            if (SM.starlight()){
                serial_mng.sendKey("lights/starlight_value",false,root.delay,0);
            }
            serial_mng.sendKey("lights/starlight_value",false,root.delay,0);
            serial_mng.sendKey("lights/ceiling_red",false,root.delay,parts.r);
            serial_mng.sendKey("lights/ceiling_green",false,root.delay,parts.g);
            serial_mng.sendKey("lights/ceiling_blue",false,root.delay,parts.b);
        }

    }
    function sendSideColor(p_color)
    {
        var parts = root.hexToRgb(p_color);
        serial_mng.sendKey("lights/side_red",false,root.delay,parts.r);
        serial_mng.sendKey("lights/side_green",false,root.delay,parts.g);
        serial_mng.sendKey("lights/side_blue",false,root.delay,parts.b);
    }
    function sendInsideColor(p_color)
    {
        var parts = root.hexToRgb(p_color);
        serial_mng.sendKey("lights/inside_red",false,root.delay,parts.r);
        serial_mng.sendKey("lights/inside_green",false,root.delay,parts.g);
        serial_mng.sendKey("lights/inside_blue",false,root.delay,parts.b);
    }
    function sendAmbientColor(p_color)
    {
        var parts = root.hexToRgb(p_color);
        serial_mng.sendKey("lights/ambient_red",false,root.delay,parts.r);
        serial_mng.sendKey("lights/ambient_green",false,root.delay,parts.g);
        serial_mng.sendKey("lights/ambient_blue",false,root.delay,parts.b);
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
        case 4:
             root.targetColorItem = ambientColorComponent
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
        case ambientColorComponent:
            return 4;
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
        case 4:
            return ambientColorComponent;
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
        function setValue(value){this.value=value;}
        function getValue(){return this.value;}
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
        function setValue(value){this.value=value;}
        function getValue(){return this.value;}
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
        function setValue(value){this.value=value;}
        function getValue(){return this.value;}
        color:"white"
        onColorChanged: {
                  var color = insideColorComponent.toRGBString();
                  root.sendInsideColor(color);
                  if(!Qt.colorEqual(color,serial_mng.insidecolor))
                    {
                            serial_mng.insidecolor = color;
                    }
        }
    }
    ColorComponents {
        id:ambientColorComponent
        saturation: 1.0
        value: 1.0 / 12.75
        function setValue(value){this.value=value/12.75;}
        function getValue(){return this.value*12.75;}
        color:"white"
        onColorChanged: {
            var color = ambientColorComponent.toRGBString();
            root.sendAmbientColor(color);
            serial_mng.ambientcolor = color;
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
        onMouseYChanged: { targetColorItem.hue = Math.max(0.0, Math.min(1.0 - mouseY / height, 1.0)); targetColorItem.saturation = 1; }
    }

    Loader {
      Component.onCompleted: source=SM.carModel()===2?"Interior/Caravelle.qml":"Interior/VClass.qml"
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
        value: targetColorItem.getValue()
        gradient: Gradient {
                GradientStop { position: 1.0; color: Qt.hsla(targetColorItem.hue, targetColorItem.saturation, targetColorItem.saturation===0?1.0:0.5, 1.0) }
                GradientStop { position: 0.0; color: "#ff333333"}
        }
        onMouseXChanged: targetColorItem.setValue (Math.max(0.0, Math.min(mouseX / width, 1.0)));

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
                text:qsTr("White") + mytrans.emptyString
//                toggled: targetColorItem.saturation===1
                onClicked: {
                    if (targetColorItem.saturation===1){
                        targetColorItem.saturation=0;
                    }
                    else{
                        targetColorItem.saturation=1;
                    }
                }
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
//                   ambientColorComponent.color = ambientColor;
                   console.log("size"+ height, + " " + width)
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
               id: leftCeilingReadingLightButton
               Layout.preferredHeight: 30
               Layout.preferredWidth: 310
               visible: false
               text:qsTr("Sol Tavan Okuma Lambası") + mytrans.emptyString
               onReleased: {
                   root.rightReadingLight = root.rightReadingLight== "#fff6a6"?"#000000":"#fff6a6";
                   serial_mng.sendKey("lights/rightreading_onoff",true,delay);
               }
           }

           LightButton{
               id: rightCeilingReadingLightButton
               Layout.preferredHeight: 30
               Layout.preferredWidth: 310
               visible: false
               text:qsTr("Sağ Tavan Okuma Lambası") + mytrans.emptyString
               onReleased: {
                   root.leftReadingLight = root.leftReadingLight== "#fff6a6"?"#000000":"#fff6a6";
                   serial_mng.sendKey("lights/leftreading_onoff",true,delay);
                    }
               }
        }

    }

    ColumnLayout{
        id:readingLigtsRow
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.bottomMargin: contentBottomMargin + 20
        anchors.leftMargin: 12
        spacing: 10
        visible: false
        Item{
            height: 30
            width: 150
            Text {
                text: qsTr("Table Reading Lights")
                font.styleName: StyleItalic
                color: "white"
                height: 20
                font.italic: true
                font.pixelSize: 18
                anchors.bottom: parent.bottom
                anchors.bottomMargin: -10
            }
        }

        LightButton{
            id:leftReadingLightButton
            height: 30
            width: 150
            text:qsTr("Left Table") + mytrans.emptyString
            visible: false
            onReleased: {
                serial_mng.sendKey("lights/seatthree_reading_light");
            }
        }
        LightButton{
            id:rightReadingLightButton
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
        GSystem.createLightsModel(ceilColorComponent,sideColorComponent,insideColorComponent,ambientColorComponent);
        leftMenu.model=GSystem.lightsModel;
        changeSelection(1);
        if (SM.seatReadingLight(3)||SM.seatReadingLight(4)){
            readingLigtsRow.visible=true;
            if (SM.seatReadingLight(3))
                leftReadingLightButton.visible=true;
            if (SM.seatReadingLight(4))
                rightReadingLightButton.visible=true;
        }
        if (SM.ceilingReadingLights()){
            leftCeilingReadingLightButton.visible=true;
            rightCeilingReadingLightButton.visible=true;
        }

    }
}
