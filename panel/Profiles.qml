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

Item {
    property alias port: homecontrol.port
    property alias host: homecontrol.host

    HomeControlClient {
        id: homecontrol
    }
    clip: true

    Rectangle {
        clip: true
        border.color: '#dddddd'
        border.width: 1
        color: "#33000000"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width * 0.8

        Button {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            height: 128
            width: 128
            background: Image {
                source: 'qrc:/icons/profiles/off.png'
                width: height
            }
            onClicked: homecontrol.activate('off')
            id: offProfile
        }

        Button {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            height: 128
            width: 128
            background: Image {
                source: 'qrc:/icons/profiles/soft.png'
                width: height
            }
            onClicked: homecontrol.activate('transfer')
            id: eveningProfile
        }
    }
}
