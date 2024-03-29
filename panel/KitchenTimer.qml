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

ColumnLayout {
    property int seconds: 0
    property string formatted: "00:00"
    property int fontsize: 50
    property bool compact: t.running
    id: ktimer

    onSecondsChanged: {
        var minutes = (Math.floor(seconds / 60)).toString()
        var secs = (seconds % 60).toString()
        if (minutes.length === 1)
            minutes = "0" + minutes
        if (secs.length === 1)
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

    RowLayout {
        Layout.preferredWidth: parent.width

        Label {
            id: iconlbl
            text: ""
            Layout.preferredWidth: height
            font.pointSize: ktimer.fontsize
        }

        Label {
            horizontalAlignment: Text.AlignHCenter
            text: ktimer.formatted
            clip: true
            font.pointSize: ktimer.fontsize
        }

        Button {
            text: "✋"
            font.pointSize: ktimer.fontsize * 0.5
            enabled: ktimer.seconds > 0
            onClicked: {
                t.stop()
                ktimer.seconds = 0
                iconlbl.text = ""
            }
        }
    }

    RowLayout {
        Layout.preferredWidth: parent.width

        visible: ! t.running

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
        visible: ! t.running
        spacing: 6

        Button {
            text: "Start"
            font.pointSize: ktimer.fontsize * 0.5
            onClicked: {t.start(); iconlbl.text = ""}
            enabled: ktimer.seconds > 0 && ! t.running
        }

        Button {
            text: "🥖"
            font.pointSize: ktimer.fontsize * 0.5
            onClicked: start_food(780, text)
            enabled: ktimer.seconds == 0
        }

        Button {
            text: "🍝"
            font.pointSize: ktimer.fontsize * 0.5
            onClicked: start_food(600, text)
            enabled: ktimer.seconds == 0
        }

        Button {
            text: "🥚"
            font.pointSize: ktimer.fontsize * 0.5
            onClicked: start_food(180, text)
            enabled: ktimer.seconds == 0
        }
    }

    function start_food(duration, text) {
        ktimer.seconds = duration
        t.start()
        iconlbl.text = text
    }
}
