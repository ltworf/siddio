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

Label {
    property alias fontsize: lblClock.font.pointSize

    id: lblClock
    text: '00:00:00'
    horizontalAlignment: Text.AlignHCenter
    font.pointSize: 38
    clip: true

    Timer {
        repeat: true
        running: true
        interval: 1000
        onTriggered: {
            lblClock.text = new Date().toLocaleTimeString()
        }
    }
}
