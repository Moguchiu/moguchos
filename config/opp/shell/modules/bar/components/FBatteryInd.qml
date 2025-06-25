import "root:/config"
import "root:/utils"
import "root:/widgets"
import "root:/services"
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower

Item {
    id: root
    // Только необходимые свойства
    readonly property real percentage: Battery.percentage
    
    // Гарантированная минимальная ширина
    implicitWidth: Math.max(40, percentageText.implicitWidth + 8)
    implicitHeight: 32
    
    // Центрированный текст
    StyledText {
        id: percentageText
        anchors.centerIn: parent
        text: `${Math.round(percentage * 100)}%`
        color: Colours.palette.m3primary_paletteKeyColor
        
        // Изменение цвета при низком заряде
        Behavior on color {
            ColorAnimation { duration: 200 }
        }
    }
    
    // Автоматическое скрытие при отсутствии батареи
    visible: Battery.available && percentage >= 0
}
