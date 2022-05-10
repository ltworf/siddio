import QtQuick 2.0
import QtQuick.Layouts 1.15

RowLayout {
    property alias radio: offtimer.radio

    function visDecider() {
        var items = [kitchen1, kitchen2, kitchen3, kitchen4]
        var available_space = 4;
        var i

        for(i =0 ; i < items.length; i++) {
            if (items[i].compact) {
                items[i].visible = true
                available_space--
            } else
                items[i].visible = false
        }
        while (available_space > 0) {
            for(i =0 ; i < items.length; i++) {
                if (!items[i].visible && available_space > 0) {
                    items[i].visible = true
                    available_space -= 2
                }
            }
        }
    }

    Component.onCompleted: visDecider()

    ColumnLayout {
        Layout.preferredHeight: parent.height
        KitchenTimer {id: kitchen1; onCompactChanged: visDecider()}
        KitchenTimer {id: kitchen2; onCompactChanged: visDecider()}
        KitchenTimer {id: kitchen3; onCompactChanged: visDecider()}
        KitchenTimer {id: kitchen4; onCompactChanged: visDecider()}
    }

    OffTimer{
        host: settings.host
        port: settings.port
        radio: radio
        id: offtimer
    }
}
