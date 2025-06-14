pragma ComponentBehavior: Bound

import "root:/widgets"
import "root:/services"
import "root:/config"
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import QtQuick

Row {
    id: root

    required property PersistentProperties visibilities

    padding: Appearance.padding.large

    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top

    spacing: Appearance.spacing.large
   

    SessionButton {
        id: shutdown

        icon: "power_settings_new"
        command: ["systemctl", "poweroff"]

        KeyNavigation.down: reboot
    }



    SessionButton {
        id: reboot

        icon: "cached"
        command: ["systemctl", "reboot"]

        KeyNavigation.up: shutdown
    }

    component SessionButton: StyledRect {
        id: button

        required property string icon
        required property list<string> command

        implicitWidth: SessionConfig.sizes.button
        implicitHeight: SessionConfig.sizes.button

        radius: Appearance.rounding.large
        color: button.activeFocus ? Colours.palette.m3secondaryContainer : Colours.palette.m3surfaceContainer

        Keys.onEnterPressed: proc.startDetached()
        Keys.onReturnPressed: proc.startDetached()
        Keys.onEscapePressed: root.visibilities.session = false

        Process {
            id: proc

            command: button.command
        }

        StateLayer {
            radius: parent.radius

            function onClicked(): void {
                proc.startDetached();
            }
        }

        MaterialIcon {
            anchors.centerIn: parent

            text: button.icon
            color: button.activeFocus ? Colours.palette.m3onSecondaryContainer : Colours.palette.m3onSurface
            font.pointSize: Appearance.font.size.extraLarge
        }
    }

    


  }
