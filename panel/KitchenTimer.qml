import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

import siddio.control 1.0

ColumnLayout {
    property int seconds: 0
    property string formatted: "00:00"
    property int fontsize: 90
    id: ktimer

    onSecondsChanged: {
        var minutes = (Math.floor(seconds / 60)).toString()
        var secs = (seconds % 60).toString()
        if (minutes.length == 1)
            minutes = "0" + minutes
        if (secs.length == 1)
            secs = "0" + secs
        formatted = minutes + ":" + secs
    }

    MpvPlayer {
        id: player
    }

    Timer {
        id: t
        onTriggered: {

            ktimer.seconds -= 1
            if (ktimer.seconds <= 0) {
                t.stop()
                player.open('/usr/share/sounds/freedesktop/stereo/phone-incoming-call.oga')
            }
        }
        interval: 1000
        repeat: true
    }


    Label {
        Layout.preferredWidth: parent.width
        horizontalAlignment: Text.AlignHCenter
        text: ktimer.formatted
        clip: true
        font.pointSize: ktimer.fontsize
    }

    RowLayout {
        Layout.preferredWidth: parent.width

        Button {
            text: "+1"
            font.pointSize: ktimer.fontsize * 0.8
            onClicked: ktimer.seconds += 60
        }

        Button {
            text: "+5"
            font.pointSize: ktimer.fontsize * 0.8
            onClicked: ktimer.seconds += 60 * 5
        }

        Button {
            text: "+10"
            font.pointSize: ktimer.fontsize * 0.8
            onClicked: ktimer.seconds += 60 * 10
        }
    }

    RowLayout {
        Layout.preferredWidth: parent.width
        spacing: 6

        Button {
            text: "Start"
            font.pointSize: ktimer.fontsize * 0.5
            onClicked: t.start()
            enabled: ktimer.seconds > 0 && ! t.running
        }

        Button {
            text: "Pause"
            font.pointSize: ktimer.fontsize * 0.5
            onClicked: t.stop()
            enabled: ktimer.seconds > 0 && t.running
        }

        Button {
            text: "Reset"
            font.pointSize: ktimer.fontsize * 0.5
            enabled: ktimer.seconds > 0
            onClicked: {
                t.stop()
                ktimer.seconds = 0
            }
        }
    }
}
