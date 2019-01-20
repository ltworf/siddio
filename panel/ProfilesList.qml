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

import siddio.control 1.0

//ListView {
GridView {
    property alias port: homecontrol.port
    property alias host: homecontrol.host
    property int fontsize: 27

    model: ListModel {
        id: list_model
    }

    HomeControlClient {
        id: homecontrol
        onHostChanged: timer.restart()
        onPortChanged: timer.restart()
    }

    Timer {
        id: timer
        interval: 1000 * 60 * 10 //10 minutes
        repeat: true
        triggeredOnStart: true
        running: true
        onTriggered: {
            var profiles = homecontrol.profiles()
            console.debug('Reloading profiles')
            list_model.clear()

            for (var i = 0; i < profiles.length; i++) {
                list_model.append({'name': profiles[i]})
            }
        }
    }

    header: Label {
        text: 'Profiles'
        font.pointSize: fontsize
    }

    cellWidth: 138
    cellHeight: 138
    delegate: Button {
        text: name
        font.pointSize: fontsize * 0.4
        background: Item {
//            color: 'yellow'
//            border.color: 'red'
            Image {
                source: 'qrc:/icons/profiles/' + name + '.png'
            }
        }
        width: 128
        height: 128
        onClicked: {
            homecontrol.activate(name)
        }
    }
}
