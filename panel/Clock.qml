import QtQuick 2.7
import QtQuick.Controls 2.0

Label {
    property alias fontsize: lblClock.font.pointSize

    id: lblClock
    text: '00:00:00'
    fontSizeMode: Text.HorizontalFit
    font.pointSize: 100
    clip: true

    Timer {
        repeat: true
        running: true
        interval: 1000
        onTriggered: {
            lblClock.text = new Date().toLocaleTimeString()
        }
    }
}
