import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("siddio")

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex

        Item{
            WeatherForm {city: settings.city}
        }

        Page {
            SettingsForm {
                anchors.fill: parent
                id: settings
            }
        }
    }

    footer: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex
        TabButton {
            text: qsTr("Main")
        }
        TabButton {
            text: qsTr("Settings")
        }
    }
}
