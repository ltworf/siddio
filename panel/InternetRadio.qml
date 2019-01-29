/*
This file is part of siddio.

siddio is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

siddio is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with siddio. If not, see <http://www.gnu.org/licenses/>.

Copyright (C) 2018-2019  Salvo "LtWorf" Tomaselli <tiposchi@tiscali.it>
*/

import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

import siddio.control 1.0

Item {
    function stop() {
        player.stop()
        name.text = ''
        title.text = ''
        description.text = ''
    }

    MpvPlayer {
        id: player
        volume: volume.value
        property string url: 'http://livemp3.radioradicale.it/live.mp3'

        onUrlChanged: {
            name.text = ''
            title.text = ''
            description.text = ''
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
            Layout.bottomMargin: height / 15

            TimeSelector {
                onTriggered: player.open(player.url)
            }

            Dial {
                id: volume
                from: 0
                to: 100
                value: 80 //TODO store this
                Layout.preferredHeight: 140
                Layout.preferredWidth: 140
            }

            Button {
                text: "stop"
                Layout.preferredWidth: 140
                antialiasing: false
                onClicked: stop()
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

            GridLayout {
                columns: 2
                Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                Layout.leftMargin: width / 6
                Layout.rightMargin: width / 10
                Layout.bottomMargin: height / 10
                Button {
                    property string url: 'http://www.radioswissjazz.ch/live/aacp.m3u'
                    highlighted: url == player.url
                    Layout.fillWidth: true
                    text: 'Radio Swiss Jazz'
                    onClicked: {
                        player.url = url
                        player.open(url)
                    }
                }
                Button {
                    property string url: 'http://www.radiosvizzeraclassica.ch/live/mp3.m3u'
                    highlighted: url == player.url
                    Layout.fillWidth: true
                    text: 'Svizzera Classica'
                    onClicked: {
                        player.url = url
                        player.open(url)
                    }
                }
                Button {
                    property string url: 'http://livemp3.radioradicale.it/live.mp3'
                    highlighted: url == player.url
                    Layout.fillWidth: true
                    text: 'Radio radicale'
                    onClicked: {
                        player.url = url
                        player.open(url)
                    }
                }
                Button {
                    property string url: 'http://bbcwssc.ic.llnwd.net/stream/bbcwssc_mp1_ws-eieuk'
                    highlighted: url == player.url
                    Layout.fillWidth: true
                    text: 'BBC World Service'
                    onClicked: {
                        player.url = url
                        player.open(url)
                    }
                }
                Button {
                    property string url: 'http://live02.rfi.fr/rfimonde-64.mp3'
                    highlighted: url == player.url
                    Layout.fillWidth: true
                    text: 'RFI'
                    onClicked: {
                        player.url = url
                        player.open(url)
                    }
                }
                Button {
                    property string url: 'http://icestreaming.rai.it/1.mp3'
                    highlighted: url == player.url
                    Layout.fillWidth: true
                    text: 'RAI Radio 1'
                    onClicked: {
                        player.url = url
                        player.open(url)
                    }
                }
                Button {
                    property string url: 'http://icestreaming.rai.it/2.mp3'
                    highlighted: url == player.url
                    Layout.fillWidth: true
                    text: 'RAI Radio 2'
                    onClicked: {
                        player.url = url
                        player.open(url)
                    }
                }
                Button {
                    property string url: 'http://icestreaming.rai.it/3.mp3'
                    highlighted: url == player.url
                    Layout.fillWidth: true
                    text: 'RAI Radio 3'
                    onClicked: {
                        player.url = url
                        player.open(url)
                    }
                }
            }
        }
    }

}
