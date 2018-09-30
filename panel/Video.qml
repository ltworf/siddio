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

    header: Label {
        text: 'Playlist'
        font.pointSize: fontsize
    }
    model: items
    delegate: Button {
        width: parent.width
        text: model.url
        onClicked: {
            videoplayer.play(model.url)
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
