import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

import siddio.control 1.0

ColumnLayout {
    property alias port: homecontrol.port
    property alias host: homecontrol.host

    property int seconds: 0
    property string formatted: "00:00"
    property int fontsize: 40

    HomeControlClient {
        id: homecontrol
    }

    onSecondsChanged: {
        var minutes = (Math.floor(seconds / 60)).toString()
        var secs = (seconds % 60).toString()
        if (minutes.length == 1)
            minutes = "0" + minutes
        if (secs.length == 1)
            secs = "0" + secs
        formatted = minutes + ":" + secs
    }

    Timer {
        id: t
        onTriggered: {
            seconds -= 1
            if (seconds <= 0) {
                homecontrol.activate("off")
            }
        }
        interval: 1000
        repeat: true
        running: seconds > 0
    }


    Label {
        Layout.preferredWidth: contentWidth
        horizontalAlignment: Text.AlignHCenter
        text: formatted
        clip: true
        font.pointSize: fontsize
    }

    Button {
        Layout.preferredWidth: contentWidth
        text: "+10"
        font.pointSize: fontsize * 0.8
        onClicked: seconds += 60 * 10
    }
}
