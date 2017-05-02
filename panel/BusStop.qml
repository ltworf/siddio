import QtQuick 2.7

Item {
    property string api_key
    property string stop
    property string name //proper name of the stop, from the API
    property string track_filter: ''
    property string stop_id: ''
    property int update_interval: 30

    property string server_time
    property string server_date
    property string server_stop
    property var items: items

    ListModel {
        id: items
    }

    Timer {
        triggeredOnStart: false
        interval: 1000 * update_interval
        running: stop_id.length > 0;
        repeat: true
        onTriggered: update_stop()
    }

    function update_stop() {
        console.log('update board')
        if (stop_id.length == 0) {
            items.clear()
            return
        }

        var http = new XMLHttpRequest()
        http.responseType = 'arraybuffer';
        var url = "http://api.vasttrafik.se/bin/rest.exe/v1/departureBoard?format=json&authKey=" + api_key + "&timeSpan=120&maxDeparturesPerLine=4&id=" + stop_id;
        http.open("GET", url);


        // Send the proper header information along with the request
        http.setRequestHeader("Connection", "close");

        http.onreadystatechange = function() { // Call a function when the state changes.
            items.clear()
            if (http.readyState == XMLHttpRequest.DONE) {
                if (http.status == 200) {
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
                        }
                        buckets[item.sname + item.direction].eta += ((itemdate - serverdate) / 1000 / 60) + ' '
                    }

                    for (var k in buckets){
                        items.append(buckets[k])
                    }

                } else {
                    console.log("error: " + http.status)
                }
            }
        }
        http.send();
    }

    onStopChanged: fetch_again()
    onApi_keyChanged: fetch_again()
    onTrack_filterChanged: update_stop()
    onStop_idChanged: update_stop()

    function fetch_again() {
        if (api_key.length == 0 || stop.length == 0)
            return
        var http = new XMLHttpRequest()
        http.responseType = 'arraybuffer';
        var url = "http://api.vasttrafik.se/bin/rest.exe/v1/location.name?format=json&authKey="+ api_key +"&input=" + stop
        console.log(url)
        http.open("GET", url);


        // Send the proper header information along with the request
        http.setRequestHeader("Connection", "close");

        http.onreadystatechange = function() { // Call a function when the state changes.
            if (http.readyState == XMLHttpRequest.DONE) {
                if (http.status == 200) {
                    var data = JSON.parse(http.responseText)['LocationList']['StopLocation'][0]
                    stop_id = data.id
                    name = data.name
                } else {
                    console.log("error: " + http.status)
                }
            }
        }
        http.send();
    }
}
