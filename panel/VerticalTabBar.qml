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

Rectangle {
    property var view
    width: 48
    z: 1

    ColumnLayout{
        spacing: 2
        anchors.fill: parent

        Button {
            background: Image {
                source: 'qrc:/icons/sections/main.svgz'
                width: height
            }
            onClicked: view.currentIndex = 0
        }

        Button {
            background: Image {
                source: 'qrc:/icons/sections/profiles.svgz'
                width: height
            }
            onClicked: view.currentIndex = 1
        }

        Button {
            background: Image {
                source: 'qrc:/icons/sections/timer.svgz'
                width: height
            }
            onClicked: view.currentIndex = 2
        }

        Button {
            background: Image {
                source: 'qrc:/icons/sections/stats.svgz'
                width: height
            }
            onClicked: view.currentIndex = 3
        }

        Button {
            background: Image {
                source: 'qrc:/icons/sections/music.svgz'
                width: height
            }
            onClicked: view.currentIndex = 4
        }

        Button {
            background: Image {
                source: 'qrc:/icons/sections/video.svgz'
                width: height
            }
            onClicked: view.currentIndex = 5
        }

        Button {
            background: Image {
                source: 'qrc:/icons/sections/settings.svgz'
                width: height
            }
            onClicked: view.currentIndex = 6
        }

    }
}
