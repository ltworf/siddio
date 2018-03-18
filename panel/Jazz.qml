import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

import siddio.control 1.0

Item {
    MpvPlayer {
        id: player
        volume: volume.value

        onMetadataChanged: {
            if (key.toLowerCase().endsWith('title')) {
                title.text = value
            }

            if (key.toLowerCase().endsWith('description')) {
                description.text = value
            }

            if (key.toLowerCase().endsWith('name')) {
                name.text = value
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent

        Label {
            id: title
            font.pointSize: 30
            horizontalAlignment: Text.AlignHCenter
            Layout.preferredWidth: parent.width
        }

        Label {
            id: description
            font.pointSize: 15
            horizontalAlignment: Text.AlignHCenter
            Layout.preferredWidth: parent.width
        }

        Label {
            id: name
            font.pointSize: 15
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
