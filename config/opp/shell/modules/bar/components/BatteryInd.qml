import "root:/config"
import "root:/utils"
import "root:/services"
import "root:/widgets"
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower

Item {
    id: root
    readonly property real percentage: Battery.percentage
    readonly property bool isCharging: Battery.isCharging
    readonly property bool isCritical: percentage <= BatteryConfig.critical / 100
    readonly property bool isLow: percentage <= BatteryConfig.low / 100
    
    // Размеры и отступы
    implicitWidth: 40
    implicitHeight: 30
    property int segmentWidth: 35
    property int segmentHeight: 10
    property int segmentSpacing: 4
    // Оптимизация: храним последнее значение
    property int lastPercentage: -1

    visible: Battery.available && percentage >= 0

    Column {
        id: batteryIndicators
        spacing: segmentSpacing
        anchors.centerIn: parent

        // Бирюзовый индикатор (высокий заряд)
        Rectangle {
            id: highIndicator
            width: segmentWidth
            height: segmentHeight
            color: Colours.palette.m3primary_paletteKeyColor // Бирюзовый
            radius: 2
            opacity: percentage > 0.60 ? 1 : 0
            
            Behavior on opacity {
                NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
            }
        }

        
        // Жёлтый индикатор (средний заряд)
        Rectangle {
            id: mediumIndicator
            width: segmentWidth
            height: segmentHeight
            color: Colours.palette.m3tertiary_paletteKeyColor // Жёлтый
            radius: 2
            opacity: percentage > 0.30 ? 1 : 0
            
            Behavior on opacity {
                NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
            }
        }


        // Красный индикатор (низкий заряд)
        Rectangle {
            id: lowIndicator
            width: segmentWidth
            height: segmentHeight
            color: Colours.palette.red // Красный
            radius: 2
            
            // Мигание при критическом уровне
            SequentialAnimation on opacity {
                running: isCritical && !isCharging
                loops: Animation.Infinite
                NumberAnimation { to: 0.3; duration: 500; easing.type: Easing.InOutQuad }
                NumberAnimation { to: 1.0; duration: 500; easing.type: Easing.InOutQuad }
            }
        }


    }
    
    // Индикатор зарядки (анимированная полоса)
    Rectangle {
        visible: isCharging
        anchors {
            top: batteryIndicators.bottom
            horizontalCenter: batteryIndicators.horizontalCenter
        }
        width: batteryIndicators.width
        height: 2
        color: Colours.palette.m3secondary_paletteKeyColor // Зелёный
        
        SequentialAnimation on opacity {
            running: isCharging
            loops: Animation.Infinite
            NumberAnimation { to: 0.5; duration: 800 }
            NumberAnimation { to: 1.0; duration: 800 }
        }
    }

    // Подписываемся на изменения батареи
    Connections {
        target: Battery
        function onPercentageChanged() {
            const newValue = Math.round(root.percentage * 100)
            if (newValue !== root.lastPercentage) {
                // Если вы хотите показывать текст с процентом, нужно создать этот элемент
                // percentageText.text = `${newValue}%`
                root.lastPercentage = newValue
            }
        }
    }

    // Инициализация при создании
    Component.onCompleted: {
        const initialValue = Math.round(root.percentage * 100)
        // Если вы хотите показывать текст с процентом, нужно создать этот элемент
        // percentageText.text = `${initialValue}%`
        root.lastPercentage = initialValue
    }
}
