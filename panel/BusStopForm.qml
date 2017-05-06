import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

ListView {
    property alias api_key: bus_stop.api_key
    property alias stop: bus_stop.stop
    property alias track_filter: bus_stop.track_filter
    property int fontsize: 27
    property int fontsize_normal: 20
    property int squaresize: 70

    BusStop {id: bus_stop}
    clip: true

    header: Text {
        text: bus_stop.name
        font.pointSize: fontsize
    }
    model: bus_stop.items
    delegate: RowLayout {
        Rectangle {
            id: rect_name
            color: fgColor
            height: squaresize
            width: height * 1.1
            Text {
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors.fill: parent
                id: lbl_name
                color: bgColor
                text: sname
                fontSizeMode: Text.HorizontalFit
                font.pointSize: fontsize
            }
        }

        Text {
            text: direction
            verticalAlignment: Text.AlignVCenter
            fontSizeMode: Text.HorizontalFit
            font.pointSize: fontsize_normal
        }

        Text {
            text: eta
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            font.pointSize: fontsize_normal
            fontSizeMode: Text.HorizontalFit
        }
    }
}
