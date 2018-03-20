import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

import siddio.control 1.0

Item {
    MpvPlayer {
        id: player
        volume: volume.value
        property string url: ''

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

            RowLayout {
                spacing: 15
                Layout.leftMargin: width / 10
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
                    onClicked: {
                        player.stop()
                        name.text = ''
                        title.text = ''
                        description.text = ''
                    }
                    font.pointSize: 15
                }
            }

            ColumnLayout {
                Layout.leftMargin: width / 6
                Layout.rightMargin: width / 10
                Layout.fillWidth: true
                Layout.fillHeight: true
                Button {
                    property string url: 'http://www.radioswissjazz.ch/live/aacp.m3u'
                    Layout.fillWidth: true
                    text: 'Radio Swiss Jazz'
                    onClicked:  player.url = url
                    enabled: player.url != url
                }
                Button {
                    property string url: 'http://www.radiosvizzeraclassica.ch/live/mp3.m3u'
                    Layout.fillWidth: true
                    text: 'Radio Svizzera Classica'
                    onClicked:  player.url = url
                    enabled: player.url != url
                }
                Button {
                    property string url: 'http://livemp3.radioradicale.it/live.mp3'
                    Layout.fillWidth: true
                    text: 'Radio radicale'
                    onClicked:  player.url = url
                    enabled: player.url != url
                }
                Button {
                    property string url: 'http://bbcwssc.ic.llnwd.net/stream/bbcwssc_mp1_ws-eieuk'
                    Layout.fillWidth: true
                    text: 'BBC World Service'
                    onClicked:  player.url = url
                    enabled: player.url != url
                }
            }
        }
    }
}
