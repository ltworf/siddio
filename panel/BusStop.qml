import QtQuick 2.7

Item {
    property string api_key
    property string stop
    property string track_filter: ''
    property int update_interval: 60

    property string server_time
    property string server_date
    property string server_stop
    property var items: items

    ListModel {
        id: items
    }

    Timer {
        triggeredOnStart: true
        interval: 1000 * update_interval
        running: true;
        repeat: true
        onTriggered: fetch_again()
    }

    function update_stop(id) {
        var http = new XMLHttpRequest()
        http.responseType = 'arraybuffer';
        var url = "http://api.vasttrafik.se/bin/rest.exe/v1/departureBoard?format=json&authKey=" + api_key + "&timeSpan=120&maxDeparturesPerLine=4&id=" + id;
        http.open("GET", url);


        // Send the proper header information along with the request
        http.setRequestHeader("Connection", "close");

        http.onreadystatechange = function() { // Call a function when the state changes.
            items.clear()
            if (http.readyState == XMLHttpRequest.DONE) {
                if (http.status == 200) {
//                  console.log(http.responseText)
                    var data = JSON.parse(http.responseText)['DepartureBoard']

                    var _servertime = data['servertime'].split(':')
                    var _serverdate = data['serverdate'].split('-')
                    var serverdate = new Date(_serverdate[0], _serverdate[1], _serverdate[2], _servertime[0], _servertime[1])

                    server_date = data['serverdate']
                    server_time = data['servertime']


                    var buckets = {}
                    for (var i = 0; i < data['Departure'].length; i++) {
                        var item = data['Departure'][i]
                        console.log(item)

                        var _itemtime = item['rtTime'].split(':')
                        var _itemdate = item['rtDate'].split('-')
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

    function fetch_again() {
//      http://api.vasttrafik.se/bin/rest.exe/v1/location.name?format=json&authKey="+ api_key +"&input=rymdtorget
        update_stop('9021014005531000')
        return
//            var http = new XMLHttpRequest()
//            http.responseType = 'arraybuffer';
//            var url = "http://api.vasttrafik.se/bin/rest.exe/v1/departureBoard?format=json&authKey=" + api_key + "&timeSpan=120&maxDeparturesPerLine=4&id=9021014005531000";
//            http.open("GET", url);


//            // Send the proper header information along with the request
//            http.setRequestHeader("Connection", "close");

//            http.onreadystatechange = function() { // Call a function when the state changes.
//                        if (http.readyState == XMLHttpRequest.DONE) {
//                            if (http.status == 200) {
//                                console.log("salvook")
//                                var turi = JSON.parse(http.responseText)
//                                console.log(turi)
//                            } else {
//                                console.log("error: " + http.status)
//                            }
//                        }
//                    }
//            http.send();
        }
}
