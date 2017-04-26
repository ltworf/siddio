import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Item {
    property int fontsize: 27
    property alias city: weather.city

    Weather {
        id: weather
    }

    RowLayout {
        anchors.fill: parent
        spacing: 10
        ColumnLayout {
            Image {
                    id: image1
                    x: 10
                    y: 10
                    width: 128
                    height: 128
                    source: weather.image
            }
            RowLayout {
                Label {fontSizeMode: Text.HorizontalFit; font.pointSize: fontsize; text: weather.low + '°'}
                Spacer {}
                Label {fontSizeMode: Text.HorizontalFit; font.pointSize: fontsize; text: weather.high + '°'}
            }
        }

        ColumnLayout {
            Label {fontSizeMode: Text.HorizontalFit; font.pointSize: fontsize; text: weather.sunrise}
            Label {fontSizeMode: Text.HorizontalFit; font.pointSize: fontsize; text: weather.sunset}
            Spacer {}
            Label {fontSizeMode: Text.HorizontalFit; font.pointSize: fontsize; text: weather.wind_speed + weather.speed_unit}
        }
    }
}
