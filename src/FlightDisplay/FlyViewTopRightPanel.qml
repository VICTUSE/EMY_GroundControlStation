/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick
import QtQuick.Layouts

import QGroundControl
import QGroundControl.Controls
import QGroundControl.FlightDisplay
import QGroundControl.FlightMap
import QGroundControl.Palette
import QGroundControl.ScreenTools


Item {

    property bool  panelVisible: togglePanelBtn.checked
    property alias toggleBtn:    togglePanelBtn

    Rectangle {
        id:                     topRightPanel
        anchors.fill:           parent
        color:                  qgcPal.toolbarBackground
        visible:                !QGroundControl.videoManager.fullScreen && togglePanelBtn.checked
        clip:                   true

        QGCPalette { id: qgcPal }

        MultiVehicleList {
            id:                    multiVehicleList
            anchors.top:           parent.top
            anchors.bottom:        parent.verticalCenter
            anchors.right:         parent.right
            anchors.left:          parent.left
            anchors.margins:       ScreenTools.defaultFontPixelHeight / 2

            Rectangle {
                anchors.fill: parent

                gradient: Gradient {
                    orientation: Gradient.Vertical

                    GradientStop { position: 0.95; color: "transparent" }
                    GradientStop { position: 1.0; color: topRightPanel.color }
                }

                Rectangle {
                    anchors.left:       parent.left
                    anchors.right:      parent.right
                    anchors.bottom:     parent.bottom
                    height:             1
                    color:              QGroundControl.globalPalette.groupBorder
                }
            }

        }

        QGCSwipeView {
            id:                    swipePages
            anchors.top:           parent.verticalCenter
            anchors.bottom:        parent.bottom
            anchors.right:         parent.right
            anchors.left:          parent.left

            MvPanelPage {
                id: buttonsPage

                ColumnLayout {
                    anchors.right:          parent.right
                    anchors.left:           parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.bottomMargin:   ScreenTools.defaultFontPixelHeight * 3
                    spacing:                ScreenTools.defaultFontPixelHeight / 2

                    QGCLabel {
                        text:               qsTr("Multi Vehicle Selection")
                        Layout.alignment:   Qt.AlignHCenter
                    }

                    RowLayout {
                        id:                 selectionRowLayout
                        Layout.alignment:   Qt.AlignHCenter

                        QGCButton {
                            text:                  qsTr("Select All")
                            enabled:               multiVehicleList.selectedVehicles && multiVehicleList.selectedVehicles.count !== QGroundControl.multiVehicleManager.vehicles.count
                            onClicked:             multiVehicleList.selectAll()
                            Layout.preferredWidth: ScreenTools.defaultFontPixelHeight * 5
                        }

                        QGCButton {
                            text:                  qsTr("Deselect All")
                            enabled:               multiVehicleList.selectedVehicles && multiVehicleList.selectedVehicles.count > 0
                            onClicked:             multiVehicleList.deselectAll()
                            Layout.preferredWidth: ScreenTools.defaultFontPixelHeight * 5

                        }
                    }


                    QGCLabel {
                        text:              qsTr("Multi Vehicle Actions")
                        Layout.alignment:  Qt.AlignHCenter
                    }

                    RowLayout {
                        id:                actionRowLayout
                        Layout.alignment:  Qt.AlignHCenter

                        QGCButton {
                            text:                  qsTr("Arm")
                            enabled:               multiVehicleList.armAvailable()
                            onClicked:             _guidedController.confirmAction(_guidedController.actionMVArm)
                            Layout.preferredWidth: ScreenTools.defaultFontPixelHeight * 2.75
                            leftPadding:           0
                            rightPadding:          0
                        }

                        QGCButton {
                            text:                  qsTr("Disarm")
                            enabled:               multiVehicleList.disarmAvailable()
                            onClicked:             _guidedController.confirmAction(_guidedController.actionMVDisarm)
                            Layout.preferredWidth: ScreenTools.defaultFontPixelHeight * 2.75
                            leftPadding:           0
                            rightPadding:          0
                        }

                        QGCButton {
                            text:                  qsTr("Start")
                            enabled:               multiVehicleList.startAvailable()
                            onClicked:             _guidedController.confirmAction(_guidedController.actionMVStartMission)
                            Layout.preferredWidth: ScreenTools.defaultFontPixelHeight * 2.75
                            leftPadding:           0
                            rightPadding:          0
                        }

                        QGCButton {
                            text:                  qsTr("Pause")
                            enabled:               multiVehicleList.pauseAvailable()
                            onClicked:             _guidedController.confirmAction(_guidedController.actionMVPause)
                            Layout.preferredWidth: ScreenTools.defaultFontPixelHeight * 2.75
                            leftPadding:           0
                            rightPadding:          0
                        }
                    }
                }
            } // Page 1

            MvPanelPage {

                // We use a Loader to load the photoVideoControlComponent only when the active vehicle is not null
                // This make it easier to implement PhotoVideoControl without having to check for the mavlink camera
                // to be null all over the place

                Loader {
                    id:                         photoVideoControlLoader
                    anchors.horizontalCenter:   parent.horizontalCenter
                    anchors.bottomMargin:       ScreenTools.defaultFontPixel
                    sourceComponent:            globals.activeVehicle && togglePanelBtn.checked ? photoVideoControlComponent : undefined

                    property real rightEdgeCenterInset: visible ? parent.width - x : 0

                    Component {
                        id: photoVideoControlComponent

                        PhotoVideoControl {
                        }
                    }
                }
            } // Page 2
        }

        QGCPageIndicator {
            id:                       pageIndicator
            count:                    swipePages.count
            currentIndex:             swipePages.currentIndex
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom:           parent.bottom
            anchors.bottomMargin:     togglePanelBtn.height

            delegate: Rectangle {
                height:    ScreenTools.defaultFontPixelHeight  / 2
                width:     height
                radius:    width / 2
                color:     model.index === pageIndicator.currentIndex ? qgcPal.text : qgcPal.button
                opacity:   model.index === pageIndicator.currentIndex ? 0.9 : 0.3
            }
        }
    }

    QGCButton {
        id:                           togglePanelBtn
        anchors.top:                  parent.top
        anchors.horizontalCenter:     parent.horizontalCenter
        anchors.topMargin:            topRightPanel.visible ? parent.height : 0
        width:                        _rightPanelWidth / 5
        height:                       _rightPanelWidth / 18
        checkable:                    true

        background: Rectangle {
            radius:                   parent.height / 2
            color:                    qgcPal.toolbarBackground
            border.color:             parent.checked ? QGroundControl.globalPalette.groupBorder : qgcPal.text
            border.width:             1
        }
    }
}
