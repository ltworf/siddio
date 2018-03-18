import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

import siddio.control 1.0

Item {
    MpvPlayer {
        id: player
        volume: volume.value

        onMetadataChanged: {
            key.indexOf('title')
            if (key.toLowerCase().indexOf('title') != -1) {
                title.text = value
            }

            if (key.toLowerCase().indexOf('description') != -1) {
                description.text = value
            }

            if (key.toLowerCase().indexOf('name') != -1) {
                name.text = value
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent

        Label {
            id: title
            font.pointSize: 30
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            Layout.preferredWidth: parent.width
        }

        Label {
            id: description
            font.pointSize: 15
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            Layout.preferredWidth: parent.width
        }

        Label {
            id: name
            font.pointSize: 15
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            Layout.preferredWidth: parent.width
        }

        RowLayout {
            anchors.horizontalCenter: parent.horizontalCenter

            Dial {
                id: volume
                from: 0
                to: 100
                value: 80 //TODO store this

                Layout.preferredHeight: 240
            }

            Button {
                text: "play"
                onClicked: player.open('http://www.radioswissjazz.ch/live/aacp.m3u')
                font.pointSize: 15
            }

            Button {
                text: "stop"
                onClicked: player.stop()
                font.pointSize: 15
            }

        }
    }
}
