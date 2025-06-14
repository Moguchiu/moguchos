import "root:/widgets"
import "root:/services"
import "root:/config"
import Quickshell
import Quickshell.Widgets
import QtQuick

Item {
    id: root

    required property PersistentProperties visibilities

    //anchors.right: parent.right
    //anchors.bottom: parent.bottom
    //anchors.margins: Appearance.padding.large

    implicitWidth: view.implicitWidth + viewWrapper.anchors.margins * 2
    implicitHeight: view.implicitHeight + viewWrapper.anchors.margins * 2

    ClippingRectangle {
        id: viewWrapper

        anchors.fill: parent
        anchors.margins: Appearance.padding.large

        radius: Appearance.rounding.normal
        color: "transparent"

        Performance {
            id: view
        }
    }

    Behavior on implicitWidth {
        NumberAnimation {
            duration: Appearance.anim.durations.large
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Appearance.anim.curves.emphasized
        }
    }

    Behavior on implicitHeight {
        NumberAnimation {
            duration: Appearance.anim.durations.large
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Appearance.anim.curves.emphasized
        }
    }
}

