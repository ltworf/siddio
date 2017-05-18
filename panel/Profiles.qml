import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

import siddio.control 1.0

Item {
    property alias port: homecontrol.port
    property alias host: homecontrol.host
    property int fontsize: 27

    HomeControlClient {
        id: homecontrol
    }


    Button {
        anchors.top: parent.top
        anchors.bottom: eveningProfile.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height / 2
        text: '☀'
        onClicked: homecontrol.activate('off')
        id: offProfile
        font.pointSize: fontsize
    }

    Button {
        anchors.top: offProfile.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height / 2
        text: '☾'
        onClicked: homecontrol.activate('evening')
        id: eveningProfile
        font.pointSize: fontsize
    }

}
