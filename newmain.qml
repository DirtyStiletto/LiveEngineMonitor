import QtQuick 2.0
import QtQuick.Window 2.2
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.11




Window {
    width: 1378
    height: 354
    visible: true
    color: "#000000"
    visibility: Window.FullScreen
    title: qsTr("Live Engine Monitor")

    Item {
            id: skala //scale ist bereits intern vergeben
            property double rangeGreenArea: 105 //Abstand in Grad der Skala-Striche grüner Bereich
            property int maxValue: 255 //Range zwischen Min. und Max. Wert
            property double offsetValue: 2.5
            property double offsetSkala: maxValue/2  //damit Anzeige mittig ist, ansonsten ist Wert 0 auf 12-Uhr
            property double redborderL: offsetSkala-(rangeGreenArea/2) //75 da die Skalastriche 105° auseinander sind
            property double redborderR: offsetSkala+(rangeGreenArea/2)//180
            property double greenborderL: redborderL+30 //100 //30° nach redBoarderL
            property double greenborderR: redborderR-30 //154 //30° vor greenborderR
            property int mappingFaktor: greenborderL-redborderL  //Mappingfaktor für Sicherbarkeit greenIndicator und redIndicator

        Connections {
            target: qmlConnection
            onValChangedPotiGraph: {
                rotateArrow.angle = valPotG-skala.offsetSkala;
                if (valPotG < skala.redborderL || valPotG > skala.redborderR) { //Zerigerfarbe Bereich rot / grün
                    greenarrow.visible = 0;
                    redarrow.visible = 1;
                }
                else {
                    redarrow.visible = 0;
                    greenarrow.visible = 1;
                }
                if (valPotG < skala.redborderL || valPotG > skala.redborderR) { //GUI Farbe Zeiger in rotem Bereich
                    greenIndicator.visible = 0;
                    redIndicator.opacity = 1;
                    redIndicator.visible = 1;
                }
                else if (valPotG >= skala.greenborderL && valPotG <= skala.greenborderR) { //GUI Farbe Zeiger im mittleren grünen Bereich
                    redIndicator.visible = 0;
                    greenIndicator.opacity = 1;
                    greenIndicator.visible = 1;
                }
                else if (valPotG >= skala.redborderL && valPotG < skala.greenborderL) { //GUI Farbe Zeiger im linken grünroten Bereich
                    redIndicator.opacity = (skala.greenborderL-valPotG)/skala.mappingFaktor;
                    redIndicator.visible = 1;
                    greenIndicator.opacity = 1-redIndicator.opacity;
                    greenIndicator.visible = 1;
                }
                else if (valPotG > skala.greenborderR && valPotG <= skala.redborderR) { //GUI farbe Zeiger in rechtem grünroten Bereich
                    greenIndicator.opacity = (skala.redborderR-valPotG)/skala.mappingFaktor;
                    greenIndicator.visible = 1;
                    redIndicator.opacity = 1-greenIndicator.opacity;
                    redIndicator.visible = 1;
                }
            } //END onValChangedPotiGraph
            onValChangedSW: {
                sw_lang.checked = cmd_switch;
            }
            onValChangedPotiTrue: mainval.text = valPotT;
            onValChangedUI: rxid.text = rxUi;
            onValChangedUD: rxdata.text = rxUd;
            onLanguageChanged: {
                if (language == "DE") {
                    sw_lang.text = "Deutsch";
                    gauge.text = "Öldruck";
                    unknown.text = "Unbekanntes Frame"
                }
                else {
                    sw_lang.text = "English";
                    gauge.text = "Oil Pressure";
                    unknown.text = "Unknown Frame"
                }
            }
        } //END Connections
    } //END ITEM skala
    Timer {
        interval: 10; running: true; repeat: true
        onTriggered: qmlConnection.changeValue();
    }
    Timer {
        interval: 200; running: true; repeat: true
        onTriggered: qmlConnection.changeLanguage(sw_lang.checked);
    }
    Item {
        id: hintergrund
        anchors.centerIn: parent
        opacity: 1
        visible: true
        Image {
            id: grid70
            anchors.centerIn: parent
            width: 1378
            height: 354
            horizontalAlignment: Image.AlignHCenter
            verticalAlignment: Image.AlignVCenter
            source: "png/grid70.png"
            smooth: true
            fillMode: Image.PreserveAspectFit
        }
        Image {
            id: gridring
            anchors.centerIn: parent
            width: 1378
            height: 354
            horizontalAlignment: Image.AlignHCenter
            verticalAlignment: Image.AlignVCenter
            source: "png/l2eye.png"
            smooth: true
            fillMode: Image.PreserveAspectFit
        }
    }
    Item {
        id: greenIndicator
        opacity: 1
        visible: true
        anchors.centerIn: parent

        Image {
            id: bluering
            width: 1378
            height: 354
            anchors.centerIn: parent
            horizontalAlignment: Image.AlignHCenter
            verticalAlignment: Image.AlignVCenter
            source: "png/bluering.png"
            smooth: true
            fillMode: Image.PreserveAspectFit
            visible: true
        }
    }
    Item {
        id: redIndicator
        opacity: 1
        visible: false
        anchors.centerIn: parent
        Image {
            id: redring
            width: 1378
            height: 354
            anchors.centerIn: parent
            horizontalAlignment: Image.AlignHCenter
            verticalAlignment: Image.AlignVCenter
            source: "png/redring.png"
            smooth: true
            fillMode: Image.PreserveAspectFit
        }
        Image {
            id: redframe
            width: 1378
            height: 354
            anchors.centerIn: parent
            horizontalAlignment: Image.AlignHCenter
            verticalAlignment: Image.AlignVCenter
            source: "png/redframe.png"
            smooth: true
            fillMode: Image.PreserveAspectFit
        }
    }
    Item {
        id: vordergrund
        anchors.centerIn: parent
        opacity: 1
        visible: true
        Image {
            id: lem_frame
            anchors.centerIn: parent
            width: 1378
            height: 354
            horizontalAlignment: Image.AlignHCenter
            verticalAlignment: Image.AlignVCenter
            source: "png/frame.png"
            smooth: true
            fillMode: Image.PreserveAspectFit
        }
        Image {
            id: originalboarder
            width: 1378
            height: 354
            anchors.centerIn: parent
            horizontalAlignment: Image.AlignHCenter
            verticalAlignment: Image.AlignVCenter
            source: "png/wireframe.png"
            smooth: true
            fillMode: Image.PreserveAspectFit
            // transform: Rotation { origin.x: 30; origin.y: 30; axis { x: 0; y: 0; z: 1 } angle: 0 }
        }
        Image {
            id: logoLEM
            anchors.centerIn: parent
            width: 547
            height: 178
            opacity: 1
            visible: true
            source: "png/lem.png"
            anchors.verticalCenterOffset: 7
            anchors.horizontalCenterOffset: 421
            fillMode: Image.PreserveAspectFit
        }
        Text {
            id: mainval
            x: -75
            y: -31
            width: 150
            height: 63
            color: "#ffffff"
            text: qsTr("value")
            font.pixelSize: 40
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            lineHeight: 1.5
            font.bold: true
            minimumPointSize: 20
            minimumPixelSize: 50
        }
        Label {
            id: gauge
            x: -93
            y: 77
            width: 187
            height: 50
            visible: true
            color: "#ffffff"
            text: qsTr("Öldruck")
            font.pixelSize: 28
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.NoWrap
            font.styleName: "Black"
            font.hintingPreference: Font.PreferDefaultHinting
            clip: false
            font.family: "Arial"
            font.bold: true
        }
    }
    Image {
        id: platte_uf
        anchors.centerIn: parent
        width: 221
        height: 60
        source: "png/platte01.png"
        anchors.verticalCenterOffset: 64
        anchors.horizontalCenterOffset: -400
        fillMode: Image.PreserveAspectFit
        Label {
            id: rxid
            x: 58
            y: 33
            width: 42
            height: 24
            text: qsTr("ID")
            font.pixelSize: 15
            font.bold: true
        }
        Label {
            id: rxdata
            x: 158
            y: 32
            width: 63
            height: 25
            text: qsTr("Frame")
            font.pixelSize: 15
            font.bold: true
        }
        Label {
            id: unknown
            x: 29
            y: 8
            width: 177
            height: 24
            text: qsTr("Unbekanntes Frame")
            font.pixelSize: 15
            font.bold: true
        }
        Label {
            id: labelRXid
            x: 29
            y: 33
            width: 23
            height: 24
            text: qsTr("ID:")
            font.pixelSize: 15
            font.bold: true
        }
        Label {
            id: labeldata
            x: 106
            y: 32
            width: 46
            height: 25
            text: qsTr("Data:")
            font.pixelSize: 15
            font.bold: true
        }
    }
    Image {
        id: platte_sw
        anchors.centerIn: parent
        width: 221
        height: 60
        source: "png/platte01.png"
        anchors.verticalCenterOffset: -64
        anchors.horizontalCenterOffset: -400
        fillMode: Image.PreserveAspectFit
        Switch {
            id: sw_lang
            anchors.centerIn: parent
            x: 178
            y: 80
            width: 222
            height: 72
            text: qsTr("Deutsch")
            font.bold: true
            font.pointSize: 12
            wheelEnabled: false
        }
    }
    Item {
        id: arrowCollector
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -100
        anchors.horizontalCenterOffset: 1
        transform: Rotation{
            id: rotateArrow
            angle: 0
            origin.x: 0
            origin.y: 100
        }
        Image {
            visible: true
            anchors.centerIn: parent
            id: greenarrow
            width: 121
            height: 91
            source: "png/pfeilgruen.png"
            opacity: 1;
            fillMode: Image.PreserveAspectFit
        }
        Image {
            id: redarrow
            anchors.centerIn: parent
            visible: true
            width: 121
            height: 91
            opacity: 1;

            source: "png/pfeilrot.png"
            fillMode: Image.PreserveAspectFit
        }
    }
}
/*##^##
Designer {
    D{i:0;formeditorZoom:0.75}
}
##^##*/
