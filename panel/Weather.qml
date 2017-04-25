import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Item {
    property string city: "goteborg"
    property string low
    property string high
    property string image: 'qrc:/icons/weather-none-available.png'
    property string title
    property string sunrise
    property string sunset
    property int update_interval : 10
    property string temperature_unit
//    property  name: value


    Timer {
        triggeredOnStart: true
        interval: 1000 * 60 * update_interval; //10 minutes
        running: true;
        repeat: true
        onTriggered: fetch_again()
    }

    function set_image(text) {
        var night = false //TODO
        if (text === 'Sunny')
            image = 'qrc:/icons/weather-clear.png'
        else if (text === 'Rain')
            image = 'qrc:/icons/weather-showers.png';
        else if (text === 'Mostly Cloudy')
            image = 'qrc:/icons/weather-overcast.png';
        else if (text === 'Mostly Sunny')
            image = 'qrc:/icons/weather-few-clouds.png';
        else if (text === 'Partly Cloudy')
            image = 'qrc:/icons/weather-clouds.png';
        else if (text === 'Scattered Showers')
            image = 'qrc:/icons/weather-showers-scattered-day.png';
        else {
            image = 'qrc:/icons/weather-none-available.png'
            console.log(text)
        }
    }

    function fetch_again() {
        var url = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22" + city + "%22)%20and%20u%3D'c'&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"
        var http = new XMLHttpRequest()
        http.responseType = 'arraybuffer';
        http.open("GET", url);

        http.setRequestHeader("Connection", "close");

        http.onreadystatechange = function() { // Call a function when the state changes.
                    if (http.readyState === XMLHttpRequest.DONE) {
                        if (http.status == 200) {
                            var data = JSON.parse(http.responseText)['query']['results']['channel']
                            low = data['item']['forecast'][0]['low']
                            high = data['item']['forecast'][0]['high']
                            set_image(data['item']['forecast'][0]['text'])
                            title = data['title']
                            sunrise = data['astronomy']['sunrise']
                            sunset = data['astronomy']['sunset']
                            temperature_unit = data['units']['temperature']
                        } else {
                            console.log("error: " + http.status)
                        }
                    }
                }
        http.send();
    }
}
