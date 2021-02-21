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

Item {
    property int fontsize: 27
    property alias city: weather.city

    clip: true
    Weather {
        id: weather
    }

    Image {
        asynchronous: true
        anchors.top: parent.top
        anchors.left: windunit.right
        id: image1
        width: 128
        height: 128
        source: weather.image
    }

    Label {
        anchors.top: image1.top
        anchors.left: image1.left
        text: weather.description
    }

    Label {
        id: percepita
        anchors.top: parent.top
        anchors.right: parent.right
        fontSizeMode: Text.HorizontalFit
        font.pointSize: fontsize
        text: 'Perc.: ' + weather.feels_like + '° ' + weather.temperature_unit
    }

    Label {
        id: wind
        color: "#999999"
        anchors.left: parent.left
        anchors.bottom: temp.top
        fontSizeMode: Text.HorizontalFit
        font.pointSize: fontsize
        text: weather.wind_speed
    }

    Label {
        id: windunit
        color: "#555555"
        anchors.left: wind.right
        anchors.bottom: temp.top
        fontSizeMode: Text.HorizontalFit
        font.pointSize: fontsize * 0.3
        text: weather.speed_unit
    }

    Label {
        id: lowtemp
        color: "#999999"
        anchors.bottom: temp.top
        anchors.right: hightemp.left
        fontSizeMode: Text.HorizontalFit;
        font.pointSize: fontsize;
        text: weather.low + '°'
    }

    Label {
        id: hightemp
        color: "#999999"
        anchors.right: parent.right
        anchors.bottom: temp.top
        fontSizeMode: Text.HorizontalFit;
        font.pointSize: fontsize;
        text: weather.high + '°'
        leftPadding: height / 3
    }

    Label {
        id: temp
        horizontalAlignment: Text.AlignHCenter
        fontSizeMode: Text.HorizontalFit;
        font.pointSize: fontsize * 1.1;
        text: weather.temp + '°' + weather.temperature_unit
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: parent.bottom
    }


}
