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
//                width: parent.width
//                anchors.bottom: parent.bottom
//                anchors.top: weather.bottom
//                anchors.left: parent.left
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
                    height: 160
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

        KitchenTimer {
            id: kitchentimer
        }

        Stats {}

//        Music {}

//        Video {}

        SettingsForm {
            id: settings
        }
    }

}
