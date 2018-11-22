import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

import siddio.control 1.0

ApplicationWindow {
    visible: true
    visibility: "FullScreen"
    title: qsTr("siddio")

    Secrets {id: secrets}

    VerticalTabBar {
        id: tabBar
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        view: view
    }

    SwipeView {
        id: view
        orientation: "Vertical"
        currentIndex: 0
        anchors.top: parent.top
        anchors.right: tabBar.left
        anchors.bottom: parent.bottom
        anchors.left: parent.left

        RowLayout {
            BusStopForm {
                id: bus
                Layout.preferredHeight: parent.height
                Layout.preferredWidth: parent.width / 2
                stop: settings.stop
                api_key: secrets.vasttrafik_api_key
                track_filter: settings.track_filter
                walkTime: settings.walkTime
            }

            ColumnLayout {
                Layout.preferredHeight: parent.height
                Layout.preferredWidth: parent.width / 2
                Layout.fillHeight: true
                Layout.fillWidth: true

                Clock {
                    Layout.fillWidth: true
                    id: clock
                    height: 50
                }
                WeatherForm {
                    Layout.fillWidth: true
                    height: 180
                    id:weather
                    city: settings.city
                }
                Item {
                    Layout.fillHeight: true
                }
                Profiles {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 140
                    host: settings.host
                    port: settings.port
                }
            }


        }

        ProfilesList {
            host: settings.host
            port: settings.port
        }

        RowLayout {
            KitchenTimer {}
            KitchenTimer {}
        }

        Stats {}

        Jazz {
            id: radio
        }

        Video {}

        SettingsForm {
            id: settings
        }


        //Power saving
        onCurrentIndexChanged: {
            pwrsavet.restart()
        }

        Timer {
            id: pwrsavet
            repeat: true
            onTriggered: {
                //Go to the last item
                blankpage.last_index = view.currentIndex
                view.currentIndex = view.count - 1
                backlight.powersave()
                backlight.blankscreen()
                pwrsavet.running = false
            }
            interval: 1000 * 60 * 20 //20 minutes
            running: true
        }

        PiBacklight {
            id: backlight
            brightness: 255
        }

        Rectangle { //Go here when in power saving mode
            id: blankpage
            property int last_index
            color: "black"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    backlight.unblankscreen()
                    backlight.resume()
                    view.currentIndex = blankpage.last_index
                }
            }
        }
    }

}
