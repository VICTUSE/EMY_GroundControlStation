import QtQuick
import QtQuick.Controls

import QGroundControl
import QGroundControl.ScreenTools
import QGroundControl.Palette

Item {
    property bool showBorder:               true
    property real contentMargin:            _margins * 2
    default property alias contentChildren: contentContainer.data

    property real _margins:     ScreenTools.defaultFontPixelHeight / 2

    Rectangle {
        color:              "transparent"
        x:                  _margins
        y:                  _margins
        height:             parent.height - _margins * 2
        width:              parent.width - _margins * 2
        border.color:       QGroundControl.globalPalette.groupBorder
        border.width:       showBorder ? 1 : 0
        radius:             ScreenTools.defaultFontPixelHeight / 2


        Item {
            id: contentContainer
            anchors.fill: parent
            anchors.margins: _margins
        }
    }

}
