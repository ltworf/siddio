import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Item {
    RowLayout {
        Weather {
            id: weather
        }
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 20
        anchors.top: parent.top

        Rectangle {
            width: 128
            height: 128
            color: "#ff0000"
        Image {
                id: image1
                x: 10
                y: 10
                width: 128
                height: 128
                source: weather.image
        }
        }

        TextField {
            id: textField1
            placeholderText: qsTr("Text Field")
            text: weather.low + weather.temperature_unit
        }
    }
}
