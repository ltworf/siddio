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
    property alias port: homecontrol.port
    property alias host: homecontrol.host

    property InternetRadio radio

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
                radio.stop()
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
        text: "+10"
        font.pointSize: fontsize * 0.8
        onClicked: seconds += 60 * 10
    }
}
