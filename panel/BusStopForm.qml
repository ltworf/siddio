import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0


ListView {
    property alias api_key: bus_stop.api_key
    property alias stop: bus_stop.stop
    property int fontsize: 27
    property int fontsize_normal: 20

    BusStop {id: bus_stop}

//                {'JourneyDetailRef': {'ref': 'http://api.vasttrafik.se/bin/rest.exe/v1/journeyDetail?ref=755514%2F257536%2F340822%2F81429%2F80%3Fdate%3D2017-04-29%26station_evaId%3D5531002%26station_type%3Ddep%26authKey%3D6511154616%26format%3Djson%26'},
//                 'bgColor': '#ffffff',
//                 'date': '2017-04-29',
//                 'direction': 'Bergsjön',
//                 'fgColor': '#7d4313',
//                 'journeyid': '9015014500700075',
//                 'name': 'Spårvagn 7',
//                 'rtDate': '2017-04-29',
//                 'rtTime': '14:25',
//                 'sname': '7',
//                 'stop': 'Rymdtorget Spårvagn, Göteborg',
//                 'stopid': '9022014005531002',
//                 'stroke': 'Solid',
//                 'time': '14:25',
//                 'track': 'B',
//                 'type': 'TRAM'}


    anchors.fill: parent
    model: bus_stop.items
    delegate: Rectangle {
        width: rect_name.width * 5
        height: rect_name.height

        Rectangle {
            id: rect_name
            color: fgColor
            height: lbl_name.height > lbl_name.width ? lbl_name.height: lbl_name.width
            width: height
            Label {
                id: lbl_name
                color: bgColor
                text: sname
                fontSizeMode: Text.HorizontalFit
                font.pointSize: fontsize
            }
        }

        Label {
            anchors.left: rect_name.right
            text: direction
            font.pointSize: fontsize_normal
        }

        Label {

        }
    }
}
