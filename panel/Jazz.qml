import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

import siddio.control 1.0

Item {
    MpvPlayer {
        id: player
        volume: volume.value
        property string url: 'http://livemp3.radioradicale.it/live.mp3'

        onUrlChanged: {
            name.text = ''
            title.text = ''
            description.text = ''
            player.open(url)
        }

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

    RowLayout {
        anchors.fill: parent

        // Left section: timer, volume and stop button
        ColumnLayout {
            spacing: 15
            Layout.leftMargin: width / 10

            TimeSelector {
                onTriggered: player.open(player.url)
            }

            Dial {
                id: volume
                from: 0
                to: 100
                value: 80 //TODO store this
                Layout.preferredHeight: 240
            }

            Button {
                text: "stop"
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                antialiasing: false
                onClicked: {
                    player.stop()
                    name.text = ''
                    title.text = ''
                    description.text = ''
                }
                font.pointSize: 15
            }

        }

        // Right sectiong
        ColumnLayout {
            ColumnLayout {
                Label {
                    id: title
                    font.pointSize: 30
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }

                Label {
                    id: description
                    font.pointSize: 15
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }

                Label {
                    id: name
                    font.pointSize: 15
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }
            }

            Item {
                Layout.fillHeight: true
            }

            ColumnLayout {
                Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                Layout.leftMargin: width / 6
                Layout.rightMargin: width / 10
                Button {
                    property string url: 'http://www.radioswissjazz.ch/live/aacp.m3u'
                    Layout.fillWidth: true
                    text: 'Radio Swiss Jazz'
                    onClicked: player.url = url
                }
                Button {
                    property string url: 'http://www.radiosvizzeraclassica.ch/live/mp3.m3u'
                    Layout.fillWidth: true
                    text: 'Radio Svizzera Classica'
                    onClicked: player.url = url
                }
                Button {
                    property string url: 'http://livemp3.radioradicale.it/live.mp3'
                    Layout.fillWidth: true
                    text: 'Radio radicale'
                    onClicked: player.url = url
                }
                Button {
                    property string url: 'http://bbcwssc.ic.llnwd.net/stream/bbcwssc_mp1_ws-eieuk'
                    Layout.fillWidth: true
                    text: 'BBC World Service'
                    onClicked: player.url = url
                }
            }
        }
    }

}
