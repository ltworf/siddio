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

    property alias city: txtCity.text
    property alias stop: txtStop.text
    property alias track_filter: txtTrackFilter.text
    property alias host: txtHomeControlHost.text
    property alias port: txtHomeControlPort.text
    property alias walkTime: txtWalkTime.text
    property alias brightness: sldBrightness.value

    property int fontsize: 27
    GridLayout {
        columns: 2
        anchors.fill: parent

        Spacer {}

        Label {
            fontSizeMode: Text.HorizontalFit;
            font.pointSize: fontsize;
            text: qsTr('Weather')
        }

        Label {
            fontSizeMode: Text.HorizontalFit;
            font.pointSize: fontsize;
            text: qsTr('City')
        }

        TextField {
            id: txtCity
            placeholderText: qsTr("City")
            text: "Goteborg"
            Layout.fillWidth: true
        }

        Spacer {}

        Label {
            fontSizeMode: Text.HorizontalFit;
            font.pointSize: fontsize;
            text: qsTr('Västtrafik')
        }

        Label {
            fontSizeMode: Text.HorizontalFit;
            font.pointSize: fontsize;
            text: qsTr('Bus stop')
        }

        TextField {
            id: txtStop
            placeholderText: qsTr("Bus stop")
            text: "SKF"
            Layout.fillWidth: true
        }

        Label {
            fontSizeMode: Text.HorizontalFit;
            font.pointSize: fontsize;
            text: qsTr('Track filter')
        }

        TextField {
            id: txtTrackFilter
            placeholderText: qsTr("A")
            text: 'AC'
            Layout.fillWidth: true
        }

        Label {
            fontSizeMode: Text.HorizontalFit
            font.pointSize: fontsize
            text: qsTr('Walk time (min)')
        }

        TextField {
            id: txtWalkTime
            placeholderText: qsTr('Walking distance to the stop')
            text: '5.5'
            inputMethodHints: Qt.ImhDigitsOnly
            validator: DoubleValidator{bottom: 0.1; top: 20}
        }

        Spacer {}

        Label {
            fontSizeMode: Text.HorizontalFit;
            font.pointSize: fontsize;
            text: qsTr('Homecontrol')
        }

        Label {
            fontSizeMode: Text.HorizontalFit;
            font.pointSize: fontsize;
            text: qsTr('Port')
        }

        TextField {
            id: txtHomeControlPort
            placeholderText: qsTr("4040")
            text: '4040'
            Layout.fillWidth: true
        }

        Label {
            fontSizeMode: Text.HorizontalFit;
            font.pointSize: fontsize;
            text: qsTr('Host')
        }

        TextField {
            id: txtHomeControlHost
            placeholderText: qsTr("A")
            text: '10.2'
            Layout.fillWidth: true
        }

        Spacer {}

        Label {
            fontSizeMode: Text.HorizontalFit;
            font.pointSize: fontsize;
            text: qsTr('Screen')
        }

        Label {
            fontSizeMode: Text.HorizontalFit;
            font.pointSize: fontsize;
            text: qsTr('Brightness')
        }

        PiBacklight {
            id: backlight
        }

        Slider {
            id: sldBrightness
            from: 0
            to: backlight.max
            value: backlight.brightness
        }


        Spacer{}
        Spacer{}

    }
}
