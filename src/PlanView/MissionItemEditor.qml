import QtQuick                      2.11
import QtQuick.Controls             2.4
import QtQuick.Controls.Styles      1.4
import QtQuick.Dialogs              1.2
import QtQml                        2.2

import QGroundControl               1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Vehicle       1.0
import QGroundControl.Controls      1.0
import QGroundControl.FactControls  1.0
import QGroundControl.Palette       1.0


/// Mission item edit control
Rectangle {
    id:     _root
    height: editorLoader.visible ? (editorLoader.y + editorLoader.height + (_margin * 2)) : (commandPicker.y + commandPicker.height + _margin / 2)
    color:  _currentItem ? qgcPal.missionItemEditor : qgcPal.windowShade
    radius: _radius
    opacity: _currentItem ? 1.0 : 0.7

    property var    map                 ///< Map control
    property var    masterController
    property var    missionItem         ///< MissionItem associated with this editor
    property bool   readOnly            ///< true: read only view, false: full editing view

    signal clicked
    signal remove
    signal insertWaypoint
    signal insertComplexItem(string complexItemName)
    signal selectNextNotReadyItem

    property var    _masterController:          masterController
    property var    _missionController:         _masterController.missionController
    property bool   _currentItem:               missionItem.isCurrentItem
    property color  _outerTextColor:            _currentItem ? qgcPal.primaryButtonText : qgcPal.text
    property bool   _noMissionItemsAdded:       ListView.view.model.count === 1
    property real   _sectionSpacer:             ScreenTools.defaultFontPixelWidth / 2  // spacing between section headings
    property bool   _singleComplexItem:         _missionController.complexMissionItemNames.length === 1

    readonly property real  _editFieldWidth:    Math.min(width - _margin * 2, ScreenTools.defaultFontPixelWidth * 12)
    readonly property real  _margin:            ScreenTools.defaultFontPixelWidth / 2
    readonly property real  _radius:            ScreenTools.defaultFontPixelWidth / 2
    readonly property real  _hamburgerSize:     commandPicker.height * 0.75
    readonly property real  _trashSize:     commandPicker.height * 0.75
    readonly property bool  _waypointsOnlyMode: QGroundControl.corePlugin.options.missionWaypointsOnly

    QGCPalette {
        id: qgcPal
        colorGroupEnabled: enabled
    }

    FocusScope {
        id:             currentItemScope
        anchors.fill:   parent

        MouseArea {
            anchors.fill:   parent
            onClicked: {
                currentItemScope.focus = true
                _root.clicked()
            }
        }
    }

    Component {
        id: editPositionDialog

        EditPositionDialog {
            coordinate: missionItem.coordinate
            onCoordinateChanged: missionItem.coordinate = coordinate
        }
    }

    Rectangle {
        anchors.verticalCenter: commandPicker.verticalCenter
        anchors.leftMargin:     _margin
        anchors.left:           parent.left
        width:                  readyForSaveLabel.contentHeight
        height:                 width
        border.width:           1
        border.color:           "red"
        color:                  "white"
        radius:                 width / 2
        visible:                missionItem.readyForSaveState !== VisualMissionItem.ReadyForSave

        QGCLabel {
            id:                 readyForSaveLabel
            anchors.centerIn:   parent
            //: Indicator in Plan view to show mission item is not ready for save/send
            text:               qsTr("?")
            color:              "red"
            font.pointSize:     ScreenTools.smallFontPointSize
        }
    }

    QGCColoredImage {
        id:                     trash
        anchors.rightMargin:    ScreenTools.defaultFontPixelWidth
        anchors.right:          parent.right
        anchors.verticalCenter: commandPicker.verticalCenter
        width:                  _trashSize
        height:                 _trashSize
        sourceSize.height:      _trashSize
        source:                 "/res/TrashDelete.svg"
        visible:                missionItem.isCurrentItem && missionItem.sequenceNumber !== 0
        color:                  qgcPal.text
    }
    QGCMouseArea {
        fillItem:   trash
        visible:    trash.visible
        onClicked: {
            currentItemScope.focus = true
            remove()
            //trashMenu.popup()
        }
    }

    QGCButton {
        id:                     commandPicker
        anchors.topMargin:      _margin / 2
        anchors.rightMargin:    ScreenTools.defaultFontPixelWidth

        anchors.leftMargin:     _margin
        anchors.left:           parent.left

        /*
            Trying no sequence numbers in ui
        anchors.leftMargin:     ScreenTools.defaultFontPixelWidth * 2
        anchors.left:           label.right
        */

        anchors.top:            parent.top
        visible:                !commandLabel.visible
        text:                   missionItem.sequenceNumber + " - " + missionItem.commandName

        Component {
            id: commandDialog

            MissionCommandDialog {
                missionItem:    _root.missionItem
                map:            _root.map
            }
        }

        onClicked: mainWindow.showComponentDialog(commandDialog, qsTr("Select Mission Command"), mainWindow.showDialogDefaultWidth, StandardButton.Cancel)
    }

    QGCLabel {
        id:                     commandLabel
        anchors.fill:           commandPicker
        visible:                !missionItem.isCurrentItem || !missionItem.isSimpleItem || _waypointsOnlyMode
        verticalAlignment:      Text.AlignVCenter
        horizontalAlignment:    Text.AlignHCenter
        text:                   missionItem.sequenceNumber + " - " + missionItem.commandName
        color:                  _outerTextColor
    }

    Loader {
        id:                 editorLoader
        anchors.leftMargin: _margin
        anchors.topMargin:  _margin
        anchors.left:       parent.left
        anchors.top:        commandPicker.bottom
        source:             missionItem.editorQml
        visible:            _currentItem

        property var    masterController:   _masterController
        property real   availableWidth:     _root.width - (_margin * 2) ///< How wide the editor should be
        property var    editorRoot:         _root
    }
} // Rectangle
