import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Item {

    property alias city: txtCity.text
    property alias stop: txtStop.text
    property alias track_filter: txtTrackFilter.text
    property alias host: txtHomeControlHost.text
    property alias port: txtHomeControlPort.text
    property alias walkTime: txtWalkTime.text

    property int fontsize: 27
    GridLayout {
        columns: 2
        anchors.fill: parent

        Spacer {}

        Label {
            fontSizeMode: Text.HorizontalFit;
            font.pointSize: fontsize;
            text: qsTr('Weather')
        }

        Label {
            fontSizeMode: Text.HorizontalFit;
            font.pointSize: fontsize;
            text: qsTr('City')
        }

        TextField {
            id: txtCity
            placeholderText: qsTr("City")
            text: "Goteborg"
            Layout.fillWidth: true
        }

        Spacer {}

        Label {
            fontSizeMode: Text.HorizontalFit;
            font.pointSize: fontsize;
            text: qsTr('Västtrafik')
        }

        Label {
            fontSizeMode: Text.HorizontalFit;
            font.pointSize: fontsize;
            text: qsTr('Bus stop')
        }

        TextField {
            id: txtStop
            placeholderText: qsTr("Bus stop")
            text: "SKF"
            Layout.fillWidth: true
        }

        Label {
            fontSizeMode: Text.HorizontalFit;
            font.pointSize: fontsize;
            text: qsTr('Track filter')
        }

        TextField {
            id: txtTrackFilter
            placeholderText: qsTr("A")
            text: 'AC'
            Layout.fillWidth: true
        }

        Label {
            fontSizeMode: Text.HorizontalFit
            font.pointSize: fontsize
            text: qsTr('Walk time (min)')
        }

        TextField {
            id: txtWalkTime
            placeholderText: qsTr('Walking distance to the stop')
            text: '5.5'
            inputMethodHints: Qt.ImhDigitsOnly
            validator: DoubleValidator{bottom: 0.1; top: 20}
        }

        Spacer {}

        Label {
            fontSizeMode: Text.HorizontalFit;
            font.pointSize: fontsize;
            text: qsTr('Homecontrol')
        }

        Label {
            fontSizeMode: Text.HorizontalFit;
            font.pointSize: fontsize;
            text: qsTr('Port')
        }

        TextField {
            id: txtHomeControlPort
            placeholderText: qsTr("4040")
            text: '4040'
            Layout.fillWidth: true
        }

        Label {
            fontSizeMode: Text.HorizontalFit;
            font.pointSize: fontsize;
            text: qsTr('Host')
        }

        TextField {
            id: txtHomeControlHost
            placeholderText: qsTr("A")
            text: '10.9'
            Layout.fillWidth: true
        }

        Spacer{}
        Spacer{}

    }
}
