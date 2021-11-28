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

ListView {
    property alias api_key: bus_stop.api_key
    property alias stop: bus_stop.stop
    property alias track_filter: bus_stop.track_filter
    property alias walkTime: bus_stop.walkTime
    property alias enabled: bus_stop.enabled
    property int fontsize: 27
    property int fontsize_normal: 20
    property int squaresize: 50


    BusStop {id: bus_stop}
    clip: true

    header: Label {
        text: bus_stop.name
        font.pointSize: fontsize
    }
    model: bus_stop.items
    delegate: Item {
        height: squaresize
        width: parent.width

        Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            id: rect_name
            color: bgColor
            height: squaresize
            width: height * 1.1
            Text {
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors.fill: parent
                id: lbl_name
                color: fgColor
                text: sname
                fontSizeMode: Text.HorizontalFit
                font.pointSize: fontsize
            }
        }

        Label {
            clip: true
            height: parent.height
            anchors.left: rect_name.right
            anchors.right: times.left
            anchors.top: parent.top
            width: parent.width - rect_name.width - eta.width
            text: direction
            verticalAlignment: Text.AlignVCenter
            fontSizeMode: Text.HorizontalFit
            font.pointSize: fontsize_normal * 0.6
            leftPadding: height / 4
            wrapMode: Text.WordWrap
        }

        Label {
            id: times
            clip: true
            height: parent.height
            anchors.right: parent.right
            anchors.top: parent.top
            text: eta
            width: contentWidth
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            font.pointSize: fontsize_normal
            fontSizeMode: Text.HorizontalFit
        }
    }
}
