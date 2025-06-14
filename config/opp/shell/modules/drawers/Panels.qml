import "root:/services"
import "root:/config"
import "root:/modules/osd" as Osd
import "root:/modules/notifications" as Notifications
import "root:/modules/session" as Session
import "root:/modules/dashboard" as Dashboard
import "root:/modules/bar/popouts" as BarPopouts
import Quickshell
import QtQuick

Item {
    id: root

    required property ShellScreen screen
    required property PersistentProperties visibilities
    required property Item bar

    readonly property Osd.Wrapper osd: osd
    readonly property Notifications.Wrapper notifications: notifications
    readonly property Session.Wrapper session: session
    readonly property Dashboard.Wrapper dashboard: dashboard
    readonly property BarPopouts.Wrapper popouts: popouts

    anchors.fill: parent
    anchors.margins: BorderConfig.thickness
    anchors.leftMargin: bar.implicitWidth

    Component.onCompleted: Visibilities.panels[screen] = this

    Osd.Wrapper {
        id: osd

        screen: root.screen
        visibility: root.visibilities.osd

        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        }

    Notifications.Wrapper {
        id: notifications

        anchors.top: parent.top
        anchors.right: parent.right
    }

    Session.Wrapper {
        id: session

        visibilities: root.visibilities

        anchors.horizontalCenter: parent.horizontalCenter
        //anchors.right: parent.right
        //anchors.left: parent.left
        anchors.top: parent.top
        //anchors.leftMargin: Appearance.padding.large
        //anchors.topMargin: Appearance.padding.large
      }

    
    Dashboard.Wrapper {
        id: dashboard

        visibilities: root.visibilities

        //anchors.horizontalCenter: parent.horizontalCenter
        //anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: parent.bottom

      }

    BarPopouts.Wrapper {
        id: popouts

        screen: root.screen

        anchors.left: parent.left
        anchors.verticalCenter: parent.top
        anchors.verticalCenterOffset: {
            const off = root.popouts.currentCenter - BorderConfig.thickness;
            const diff = root.height - Math.floor(off + implicitHeight / 2);
            if (diff < 0)
                return off + diff;
            return off;
        }
    }
}
