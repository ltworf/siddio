import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

import siddio.control 1.0

Item {
    property alias port: homecontrol.port
    property alias host: homecontrol.host

    HomeControlClient {
        id: homecontrol
    }
    clip: true

    Rectangle {
        clip: true
        border.color: '#dddddd'
        border.width: 1
        color: "#33000000"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width * 0.8

        Button {
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            height: parent.height / 2
            width: parent.height / 2
            background: Image {
                source: 'qrc:/icons/weather-clear.png'
                width: height
            }
            onClicked: homecontrol.activate('off')
            id: offProfile
        }

        Button {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            height: parent.height / 2
            width: parent.height / 2
            background: Image {
                source: 'qrc:/icons/weather-clear-night.png'
                width: height
            }
            onClicked: homecontrol.activate('evening')
            id: eveningProfile
        }
    }
}
