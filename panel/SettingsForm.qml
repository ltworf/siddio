import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Item {

    property alias city: txtCity.text
    property alias stop: txtStop.text

    property int fontsize: 27
    GridLayout {
        columns: 2
        anchors.fill: parent

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

    }
}
