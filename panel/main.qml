import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

import siddio.control 1.0

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("siddio")

    Secrets {id: secrets}

    SwipeView {
        id: view
        currentIndex: 0
        anchors.fill: parent

        Item {
            Clock {
                anchors.top: parent.top
                anchors.left: parent.left
                id: clock
                width: parent.width / 4 * 3
                height: 50
            }
            WeatherForm {
                width: parent.width / 4 * 3
                height: 145
                anchors.top: clock.bottom
                anchors.left: parent.left
                id:weather
                city: settings.city
            }

            Profiles { //placeholder
                width: parent.width / 4
                height: weather.height
                anchors.top: parent.top
                anchors.right: parent.right
                host: settings.host
                port: settings.port
            }

            BusStopForm {
                width: parent.width
                anchors.bottom: parent.bottom
                anchors.top: weather.bottom
                anchors.left: parent.left
                stop: settings.stop
                api_key: secrets.vasttrafik_api_key
                track_filter: settings.track_filter
                walkTime: settings.walkTime
            }
        }

        ProfilesList {
            host: settings.host
            port: settings.port
        }

        SettingsForm {
            id: settings
        }
    }

    PageIndicator {
        id: indicator
        count: view.count
        currentIndex: view.currentIndex

        anchors.bottom: view.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }

//    footer: TabBar {
//        id: tabBar
//        currentIndex: swipeView.currentIndex
//        TabButton {
//            text: qsTr("Main")
//        }
//        TabButton {
//            text: qsTr("Settings")
//        }
//    }
}
