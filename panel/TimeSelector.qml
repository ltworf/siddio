import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

GridLayout {
    property int hours: 7
    property int minutes: 0
    property bool enabled: false
    signal triggered

    columns: 2

    onHoursChanged: {
        // Ensure range
        if (hours < 0 || hours > 23)
            hours = 0
        // 2 digit display
        if (hours > 9)
            lblhours.text = hours
        else
            lblhours.text = '0' + String(hours)
    }

    onMinutesChanged: {
        // Ensure range
        if (minutes < 0 || minutes > 59)
            minutes = 0
        // 2 digit display
        if (minutes > 9)
            lblminutes.text = minutes
        else
            lblminutes.text = '0' + String(minutes)
    }

    Timer {
        interval: 40 * 1000
        repeat: true
        running: parent.enabled
        onTriggered: {
            var d = new Date()
            if (d.getHours() === hours && d.getMinutes() === minutes)
                parent.triggered();
        }
    }

    Button {
        text: '+'
        onClicked: hours++
        enabled: parent.enabled
    }

    Button {
        text: '+'
        onClicked: minutes += 10
        enabled: parent.enabled
    }

    Label {
        id: lblhours
        font.pointSize: 15
        text: '07'
    }

    Label {
        id: lblminutes
        text: '00'
        font.pointSize: 15
    }

    Button {
        text: '-'
        onClicked: hours--
        enabled: parent.enabled
    }

    Button {
        text: '-'
        onClicked: minutes -= 10
        enabled: parent.enabled
    }

    Button {
        checkable: true
        text: 'Alarm'
        Layout.columnSpan: 2
        Layout.fillWidth: true
        onClicked: parent.enabled = checked
    }
}
