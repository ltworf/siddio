import QtQuick 2.7
import QtQuick.Controls 2.0

import siddio.control 1.0

//ListView {
GridView {
    property alias port: homecontrol.port
    property alias host: homecontrol.host
    property int fontsize: 27

    model: ListModel {
        id: list_model
    }

    HomeControlClient {
        id: homecontrol
        onHostChanged: timer.restart()
        onPortChanged: timer.restart()
    }

    Timer {
        id: timer
        interval: 1000 * 60 * 10 //10 minutes
        repeat: true
        triggeredOnStart: true
        running: true
        onTriggered: {
            var profiles = homecontrol.profiles()
            console.debug('Reloading profiles')
            list_model.clear()

            for (var i = 0; i < profiles.length; i++) {
                list_model.append({'name': profiles[i]})
            }
        }
    }

    header: Label {
        text: 'Profiles'
        font.pointSize: fontsize
    }

    cellWidth: 138
    cellHeight: 138
    delegate: Button {
        text: name
        font.pointSize: fontsize * 0.4
        background: Item {
//            color: 'yellow'
//            border.color: 'red'
            Image {
                source: 'qrc:/icons/profiles/' + name + '.png'
            }
        }
        width: 128
        height: 128
        onClicked: {
            homecontrol.activate(name)
        }
    }
}
