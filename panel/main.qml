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
    HomeControlClient {
        id: homecontrol
        port: 4040
        host: settings.host
    }

    SwipeView {
        id: view
        currentIndex: 0
        anchors.fill: parent

        Item {
            id: secondPage
            WeatherForm {
                width: parent.width / 2
                height: 175
                anchors.top: parent.top
                anchors.left: parent.left
                id:weather
                city: settings.city
            }

            Rectangle { //placeholder
                width: parent.width / 2
                height: weather.height
                anchors.top: parent.top
                anchors.right: parent.right
                color: 'red'
                Button {
                    anchors.fill: parent
                    text: 'GO'
                    onClicked: homecontrol.activate('evening')
                }
            }

            BusStopForm {
                width: parent.width
                anchors.bottom: parent.bottom
                anchors.top: weather.bottom
                anchors.left: parent.left
                stop: settings.stop
                api_key: secrets.vasttrafik_api_key
                track_filter: settings.track_filter
            }
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
