import QtQuick 2.0


Item {
    Secrets {id: secrets}

    BusStopForm {
        anchors.fill: parent
        stop: 'SKF'
        api_key: secrets.vasttrafik_api_key
        track_filter: '' 
        squaresize: 60
        fontsize: 21
        fontsize_normal: 12
    }
}
