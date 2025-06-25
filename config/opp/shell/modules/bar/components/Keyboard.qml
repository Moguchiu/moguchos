import "root:/widgets"
import "root:/services"
import "root:/config"
import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root
    readonly property string layout: Hyprland.activeKeyboardLayout
    implicitWidth: 40
    implicitHeight: 32
    
    StyledText {
        anchors.centerIn: parent
        text: root.getLayoutShortName()
        color: "white"
    }
    
    function getLayoutShortName() {
        if (!Hyprland.active || !layout) return "??";
        
        // Для случаев, когда возвращается полное имя
        if (layout.includes("Russian")) return "RU";
        if (layout.includes("English")) return "EN";
        if (layout.includes("Ukrainian")) return "UA";
        
        // Возвращаем первые 2 символа в верхнем регистре
        return layout.substring(0, 2).toUpperCase();
    }
}
