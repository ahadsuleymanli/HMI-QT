import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Item {
//    opacity: 0.8
    id:root
    property int currentPreset: -1
    function presetsNotClicked(){
        if (presetsModel.count>0 && currentPreset === -1){
            frequencySlider.setFrequency(parseFloat((presetsModel.get(0).frequency)) )
            currentPreset = 0;
            return true;
        }else
            return false;
    }
    function nextPreset(){
        if (!presetsNotClicked()&& presetsModel.count>currentPreset+1){
            currentPreset++;
            var freq = presetsModel.get(currentPreset).frequency;
            frequencySlider.setFrequency(parseFloat(freq) )
        }
    }
    function previousPreset(){
        if (!presetsNotClicked()&& presetsModel.count>currentPreset-1&&currentPreset>0){
            currentPreset--;
            var freq = presetsModel.get(currentPreset).frequency;
            frequencySlider.setFrequency(parseFloat(freq) )
        }
    }
    Image {
        anchors.fill: parent
        source: "qrc:/design/media/Radio/favoritespane.png"
        opacity: 0.3
    }
    GridView {
        cellWidth: width/2
        cellHeight: 52
        anchors.fill: parent
        anchors.leftMargin: 12 + 10
        anchors.topMargin: 9+4
        anchors.rightMargin: 12 + 5
        anchors.bottomMargin: 10
        topMargin: 12
        clip: true
        model: presetsModel
        delegate: Item {
            id:delegateItem
            height: 50
            width: parent.width/2
            Rectangle {
                anchors.fill: presetRectangle
                anchors.topMargin: 3
                anchors.leftMargin: 3
                anchors.bottomMargin: -3
                anchors.rightMargin: -3
                radius: 10
                color: "#60000000"
            }
            Rectangle{
                id:presetRectangle
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.top:parent.top
                width: parent.width - 2
                border.color: "#ff0c0c0c"
                border.width: 2
                color: mouseArea.pressed?"#ff1c1c1c":"#ff383838"
                radius: 10
                antialiasing: true
                MouseArea{
                    id: mouseArea
                    anchors.fill: presetRectangle
                    onPressed: {}
                    onReleased: {}
                    onClicked: {frequencySlider.setFrequency(parseFloat(frequency));root.currentPreset=index;}
                }
            }

            Text {
                id: frequencyText
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 10
                font.pixelSize: 18
                color: "#ffd3d3d3"
//                text: frequency.toFixed(1)
                text: frequency
            }
            Image {
                id: favoriteButton
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                property bool pressedAndHeld: false
                height: 50
                width: 50
                source: "qrc:/design/media/Radio/unfav.png"
                MouseArea{
                    id: unFavoriteMouserea
                    anchors.fill: favoriteButton
                    onPressed: {}
                    onReleased: {}
                    onClicked: {
                        SM.datafileRemoveRadioStation(frequency);
                        favoritesUpdated();
                    }
                    onPressAndHold: {
                        SM.datafileRemoveRadioStation(frequency);
                        favoritesUpdated();
                    }
                }
                LevelAdjust {
                    id:levelAdjust
                    anchors.fill: favoriteButton
                    source: favoriteButton
                    minimumOutput: "#00444444"
                    maximumOutput: "#ffffffff"
                    visible: (unFavoriteMouserea.pressed)?true:false
                }
//                ColorOverlay {
//                    anchors.fill: favoriteButton
//                    source: favoriteButton
//                    color: "#80ffffff"
//                    visible: unFavoriteMouserea.pressed && favoriteButton.pressedAndHeld?true:false
//                }
            }
        }
        Component.onCompleted: {
        }
    }
    ListModel{
        id:presetsModel
    }
    signal favoritesUpdated
    Connections {
        target: root
        onFavoritesUpdated: updateFavoritesList();
    }
    function updateFavoritesList(){
        var stations = SM.datafileGetRadioStations();
        presetsModel.clear();
        for (var i = 0 ;i<stations.length; i++){
            presetsModel.append({frequency:stations[i]});
        }
    }
    Component.onCompleted: {
        updateFavoritesList();
    }

}
