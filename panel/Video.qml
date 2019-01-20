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

import siddio.control 1.0

ListView {
    property int update_interval_secs: 600
    property string media_list: "http://10.0.0.2/lista"
    property int fontsize: 27
    property int fontsize_normal: 20

    VideoPlayer {
        id: videoplayer
    }

    ListModel {
        id: items
    }

    clip: true

    header: RowLayout {
        spacing: 30
        Label {
            text: 'Playlist'
            font.pointSize: fontsize
        }

        Button {
            text: '↺'
            font.pointSize: fontsize
            onClicked: fetch_again()
        }
    }
    model: items
    delegate: Button {
        width: parent.width
        text: model.url
        onClicked: {
            videoplayer.play(model.url)
        }
    }

    function fetch_again() {
        var url = media_list
        var http = new XMLHttpRequest()
        http.responseType = 'arraybuffer';
        http.open("GET", url);

        http.onreadystatechange = function() { // Call a function when the state changes.
                    if (http.readyState === XMLHttpRequest.DONE) {
                        items.clear();
                        if (http.status == 200) {
                            var rows = http.responseText.split('\n')
                            for (var i = 0; i < rows.length; i++)
                                items.append({url: rows[i]})
                        } else {
                            console.log("error: " + http.status)
                        }
                    }
                }
        http.send();
    }
}
