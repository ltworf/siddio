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
import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

ListView {
    property int update_interval_secs: 20
    property string lapdog_status_url: "http://10.0.0.2:2600/"
    property int fontsize: 27
    property int fontsize_normal: 20

    ListModel {
        id: items
    }

    clip: true

    header: Label {
        text: 'Lapdog status'
        font.pointSize: fontsize
    }
    model: items
    delegate: Rectangle {

        height: fontsize_normal * 2
        width: parent.width

        id: dev_rect
        color: model.present ? (model.misses ? 'yellow': 'green') : (model.arp ? 'orange' : 'black')
        Label {
            text: model.name
            font.pointSize: fontsize_normal
            anchors.centerIn: dev_rect
        }
    }

    Timer {
        triggeredOnStart: true
        interval: 1000 * update_interval_secs;
        running: true;
        repeat: true
        onTriggered: fetch_again()
    }

    function fetch_again() {
        var url = lapdog_status_url
        var http = new XMLHttpRequest()
        http.responseType = 'arraybuffer';
        http.open("GET", url);

        http.setRequestHeader("Connection", "close");

        http.onreadystatechange = function() { // Call a function when the state changes.
                    if (http.readyState === XMLHttpRequest.DONE) {
                        items.clear();
                        if (http.status == 200) {
                            try {
                                var data = JSON.parse(http.responseText)
                                for (var i = 0; i < data.length; i++) {
                                    items.append(data[i])
                                }

                            } catch (err) {
                                console.log(err)
                            }
                        } else {
                            console.log("error: " + http.status)
                        }
                    }
                }
        http.send();
    }
}
