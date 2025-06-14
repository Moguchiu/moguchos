import "root:/widgets"
import "root:/services"
import "root:/utils"
import "root:/config"
import Quickshell
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    required property int index
    required property var occupied
    required property int groupOffset

    readonly property bool isWorkspace: true // Flag for finding workspace children
    // Unanimated prop for others to use as reference
    readonly property real size: childrenRect.height + (hasWindows ? Appearance.padding.normal : 0)

    readonly property int ws: groupOffset + index + 1
    readonly property bool isOccupied: occupied[ws] ?? false
    readonly property bool hasWindows: isOccupied && BarConfig.workspaces.showWindows

    property var icons: {
    1: "∇",
    2: "∂",
    3: "∮",
    4: "∑",
    5: "∝",
    6: "∫",
    7: "⧉",
    8: "∬",
    9: "∪",
    10: "∀"
    }

    Layout.preferredWidth: childrenRect.width
    Layout.preferredHeight: size

    StyledText {
    id: indicator

    text: root.icons[root.ws] || root.ws
    font.pointSize: Appearance.font.size.large
    font.weight: Hyprland.activeWsId === root.ws
        ? Font.Bold
        : root.isOccupied ? Font.Normal : Font.Light

    horizontalAlignment: StyledText.AlignHCenter
    verticalAlignment: StyledText.AlignVCenter

    width: BarConfig.sizes.innerHeight
    height: BarConfig.sizes.innerHeight

    color: Hyprland.activeWsId === root.ws
        ? Colours.palette.m3onSurface
        : root.isOccupied
            ? Colours.palette.m3onSurfaceVariant
            : Colours.palette.m3outlineVariant
    }

    Loader {
        id: windows

        active: BarConfig.workspaces.showWindows
        asynchronous: true

        anchors.horizontalCenter: indicator.horizontalCenter
        anchors.top: indicator.bottom

        sourceComponent: Column {
            spacing: Appearance.spacing.small

            add: Transition {
                Anim {
                    properties: "scale"
                    from: 0
                    to: 1
                    easing.bezierCurve: Appearance.anim.curves.standardDecel
                }
            }

            Repeater {
                model: ScriptModel {
                    values: Hyprland.clients.filter(c => c.workspace?.id === root.ws)
                }

                MaterialIcon {
                    required property Hyprland.Client modelData

                    text: Icons.getAppCategoryIcon(modelData.wmClass, "terminal")
                    color: Colours.palette.m3outlineVariant
                }
            }
        }
    }

    Behavior on Layout.preferredWidth {
        Anim {}
    }

    Behavior on Layout.preferredHeight {
        Anim {}
    }

    component Anim: NumberAnimation {
        duration: Appearance.anim.durations.normal
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Appearance.anim.curves.standard
    }
}
