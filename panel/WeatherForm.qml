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
        anchors.top: parent.top
        anchors.left: parent.left
        id: image1
        width: 128
        height: 128
        source: weather.image
    }

    Label {
        id: sunrise
        anchors.top: parent.top
        anchors.right: parent.right
        fontSizeMode: Text.HorizontalFit
        font.pointSize: fontsize
        text: weather.sunrise
    }

    Label {
        id: sunset
        anchors.right: parent.right
        anchors.top: sunrise.bottom
        fontSizeMode: Text.HorizontalFit
        font.pointSize: fontsize
        text: weather.sunset
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
