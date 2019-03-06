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
    property string city
    property string low
    property string high
    property string temp
    property string image: 'qrc:/icons/weather-none-available.png'
    property string title
    property string feels_like
    property int update_interval : 10
    property string temperature_unit
    property string speed_unit
    property string wind_speed

    onCityChanged: fetch_again()

    Timer {
        triggeredOnStart: true
        interval: 1000 * 60 * update_interval; //10 minutes
        running: true;
        repeat: true
        onTriggered: fetch_again()
    }

    function set_image(code) {
        var dictionary = {}

        dictionary["0"] = "17"
        dictionary["1"] = "17"
        dictionary["2"] = "17"
        dictionary["3"] = "17"
        dictionary["4"] = "17"
        dictionary["17"] = "17"
        dictionary["35"] = "17"

        dictionary["37"] = "15"
        dictionary["38"] = "15"

        dictionary["47"] = "16"

        dictionary["32"] =  "01"
        dictionary["31"] =  "33"

        dictionary["27"] =  "34"
        dictionary["29"] =  "35"
        dictionary["33"] =  "36"

        dictionary["20"] = "11"
//        21 - Haze
//        22 - Smoke

        dictionary["26"] = "07"
        dictionary["28"] = "03"
        dictionary["30"] = "04"
        dictionary["34"] = "06"

        dictionary["36"] = "30"
        dictionary["39"] = "14"
        dictionary["41"] = "20"
//        dictionary["44"] - N/A
        dictionary["45"] = "39"
//        dictionary["46"] = "
        dictionary["5"] = "29"
        dictionary["6"] = "25"
        dictionary["7"] = "25"
        dictionary["10"] = "25"
        dictionary["8"] = "31"
        dictionary["9"] = "31"
        dictionary["11"] = "14"
        dictionary["12"] = "12"
        dictionary["13"] = "21"
        dictionary["14"] = "19"
        dictionary["16"] = "22"
        dictionary["42"] = "23"
        dictionary["43"] = "25"
        dictionary["15"] = "26"
        dictionary["18"] = "13"
        dictionary["40"] = "13"
//        19 - Dust
        dictionary["23"] = "32"
        dictionary["24"] = "32"
        dictionary["25"] = "24"

        image = 'qrc:/icons/' + dictionary[code] + '.png'

    }

    function set_blank() {
        set_image('')
        low = ''
        high = ''
        title = 'no data'
        sunrise = ''
        sunset = ''
        wind_speed = ''
        speed_unit = ''
        temperature_unit = ''
    }

    function fetch_again() {
        if (city === '')
            return
        var url = "http://weather.service.msn.com/data.aspx?weasearchstr=goteborg&culture=en-en&weadegreetype=C&src=msn"
        var http = new XMLHttpRequest()
        http.responseType = 'arraybuffer';
        http.open("GET", url);

        http.setRequestHeader("Connection", "close");

        http.onreadystatechange = function() { // Call a function when the state changes.
                    if (http.readyState === XMLHttpRequest.DONE) {
                        if (http.status == 200) {
                            try {
                                // Do some poor man parsing, since parsing XML is so hard
                                var data = http.responseText
                                var begin = data.indexOf('<current ')
                                var end = data.indexOf('>', begin)
                                var items = data.substr(begin + 9, end - begin - 9 - 2).split('" ')
                                var dictionary = {}
                                for (var i = 0; i < items.length; i++) {
                                    var q = items[i].split('=')
                                    var key = q[0]
                                    var value = q[1]
                                    value = value.substr(1, value.length) // Remove the leftover quote sign
                                    dictionary[key] = value
                                }

                                begin = data.indexOf('<forecast ')
                                end = data.indexOf('>', begin)
                                items = data.substr(begin + 10, end - begin - 10 - 2).split('" ')
                                for (i = 0; i < items.length; i++) {
                                    q = items[i].split('=')
                                    key = q[0]
                                    value = q[1]
                                    value = value.substr(1, value.length) // Remove the leftover quote sign
                                    dictionary[key] = value
                                }


                                temp = dictionary.temperature
                                low = dictionary.low
                                high = dictionary.high
                                set_image(dictionary.skycode)
                                title = dictionary.observationpoint
                                var w = dictionary.windspeed.split(' ')
                                wind_speed = w[0]
                                speed_unit = w[1]
                                temperature_unit = 'C'
                                feels_like = dictionary.feelslike

                            } catch (err) {
                                set_blank()
                            }
                        } else {
                            set_blank()
                            console.log("error: " + http.status)
                        }
                    }
                }
        http.send();
    }
}
