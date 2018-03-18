import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Rectangle {
    property var view
    width: 48
    z: 1

    ColumnLayout{
        anchors.fill: parent

        Button {
            background: Image {
                source: 'qrc:/icons/sections/main.svgz'
                width: height
            }
            onClicked: view.currentIndex = 0
        }

        Button {
            background: Image {
                source: 'qrc:/icons/sections/profiles.svgz'
                width: height
            }
            onClicked: view.currentIndex = 1
        }

        Button {
            background: Image {
                source: 'qrc:/icons/sections/timer.svgz'
                width: height
            }
            onClicked: view.currentIndex = 2
        }

        Button {
            background: Image {
                source: 'qrc:/icons/sections/stats.svgz'
                width: height
            }
            onClicked: view.currentIndex = 3
        }

        Button {
            background: Image {
                source: 'qrc:/icons/sections/music.svgz'
                width: height
            }
            onClicked: view.currentIndex = 4
        }

        Button {
            background: Image {
                source: 'qrc:/icons/sections/video.svgz'
                width: height
            }
            onClicked: view.currentIndex = 5
        }

        Button {
            background: Image {
                source: 'qrc:/icons/sections/settings.svgz'
                width: height
            }
            onClicked: view.currentIndex = 6
        }

    }
}
