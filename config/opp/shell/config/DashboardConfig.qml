pragma Singleton

import Quickshell
import QtQuick

Singleton {
    readonly property int mediaUpdateInterval: 500
    readonly property int visualiserBars: 45
    readonly property Sizes sizes: Sizes {}

    component Sizes: QtObject {
        readonly property int resourceProgessThickness: 8
        readonly property int resourceSize: 165
    }
}
