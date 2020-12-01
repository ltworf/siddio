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

Copyright (C) 2018-2020  Salvo "LtWorf" Tomaselli <tiposchi@tiscali.it>
*/
import QtQuick 2.7

Item {
    property string api_key
    property string stop //Name of the stop from the settings
    property string name: '' //human readable name of the stop, from the API
    property string track_filter: ''
    property string stop_id: ''
    property int update_interval: 30
    property double walkTime: 0
    property bool enabled: true

    property string server_time
    property string server_date
    property string server_stop
    property var items: items
    property string _token
    property var _token_expires: 0

    ListModel {
        id: items
    }

    Timer {
        id: update_timer
        triggeredOnStart: true
        interval: 1000 * update_interval
        running: enabled && stop_id.length > 0
        repeat: true
        onTriggered: update_stop()
    }

    onStopChanged: {stop_id = ''; update_stop() }
    onTrack_filterChanged: update_stop()

    function get_token() {
        console.log('[BusStop] Getting new token...')
        var http = new XMLHttpRequest()
        var url = 'https://api.vasttrafik.se:443/token'
        http.open('POST', url)
        http.setRequestHeader('Authorization', 'Basic ' + api_key)
        http.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded')
        http.send('grant_type=client_credentials')

        http.onreadystatechange = function() { // Call a function when the state changes.
            if (http.readyState === XMLHttpRequest.DONE) {
                if (http.status === 200) {
                    var response = JSON.parse(http.responseText)
                    _token = response['access_token']

                    // Adjust interval accordingly to token expiration
                    _token_expires = Date.now() + (response['expires_in'] * 1000)
                    console.log('[BusStop] Get new token in ' + response['expires_in'] + 's')
                    update_stop()
                } else {
                    console.log('[BusStop] obtaining token error: ' + http.status + http.responseText)
                    items.clear()
                }
            }
        }
    }

    function update_stop() {
        console.log('[BusStop] update board')
        if (Date.now() > _token_expires) {
            console.log('[BusStop] Need to fetch token, because:', Date.now(), _token_expires)
            get_token()
            return
        }

        if (stop_id === '' || name === '') {
            find_stop_id()
            return
        }

        if (stop_id.length == 0) {
            items.clear()
            return
        }

        var http = new XMLHttpRequest()
        http.responseType = 'arraybuffer';
        var url = "https://api.vasttrafik.se/bin/rest.exe/v2/departureBoard?format=json&timeSpan=120&maxDeparturesPerLine=4&id=" + stop_id;
        http.open("GET", url);
        http.setRequestHeader('Authorization', 'Bearer ' + _token)

        http.onreadystatechange = function() { // Call a function when the state changes.
            items.clear()
            if (http.readyState === XMLHttpRequest.DONE) {
                if (http.status === 200) {
                    var data = JSON.parse(http.responseText)['DepartureBoard']

                    var _servertime = data['servertime'].split(':')
                    var _serverdate = data['serverdate'].split('-')
                    var serverdate = new Date(_serverdate[0], _serverdate[1], _serverdate[2], _servertime[0], _servertime[1])

                    server_date = data['serverdate']
                    server_time = data['servertime']

                    var buckets = {}
                    for (var i = 0; i < data['Departure'].length; i++) {
                        var item = data['Departure'][i]

                        if (track_filter.length > 0 &&  track_filter.toUpperCase().indexOf(item.track) == -1)
                            continue

                        var date_key
                        var time_key
                        if (typeof(item['rtTime']) == 'undefined') {
                            date_key = 'date'
                            time_key = 'time'
                        } else {
                            date_key = 'rtDate'
                            time_key = 'rtTime'
                        }
                        var _itemtime = item[time_key].split(':')
                        var _itemdate = item[date_key].split('-')
                        var itemdate = new Date(_itemdate[0], _itemdate[1], _itemdate[2], _itemtime[0], _itemtime[1])
                        if (typeof(buckets[item.sname + item.direction]) == 'undefined') {
                            buckets[item.sname + item.direction] = item
                            buckets[item.sname + item.direction].eta = ''
                            buckets[item.sname + item.direction].etalen = 0
                        }
                        var ttl = ((itemdate - serverdate) / 1000 / 60)
                        if (ttl <= 0)
                            continue
                        if (buckets[item.sname + item.direction].etalen++ > 2)
                            continue
                        if (walkTime) {
                            var color
                            if (ttl < Math.floor(walkTime))
                                color = 'red'
                            else if (ttl > Math.ceil(walkTime))
                                color = 'green'
                            else
                                color = 'yellow'
                            buckets[item.sname + item.direction].eta += '<font color="' + color + '">' + ttl + '</font> '
                        } else
                            buckets[item.sname + item.direction].eta += ttl + ' '
                    }

                    for (var k in buckets){
                        items.append(buckets[k])
                    }

                } else {
                    console.log('[BusStop] update board error: ' + http.status)
                    items.clear()
                }
            }
        }
        http.send();
    }

    function find_stop_id() {
        console.log('[BusStop] Fetching stop id for:', stop)
        var http = new XMLHttpRequest()
        http.responseType = 'arraybuffer';
        var url = "https://api.vasttrafik.se/bin/rest.exe/v2/location.name?format=json&input=" + stop
        http.open("GET", url);
        http.setRequestHeader('Authorization', 'Bearer ' + _token)

        http.onreadystatechange = function() { // Call a function when the state changes.
            if (http.readyState === XMLHttpRequest.DONE) {
                if (http.status === 200) {
                    var data = JSON.parse(http.responseText)['LocationList']['StopLocation'][0]
                    stop_id = data.id
                    name = data.name
                    update_stop()
                } else {
                    console.log('[BusStop] location error: ' + http.status)
                }
            }
        }
        http.send();
    }
}
