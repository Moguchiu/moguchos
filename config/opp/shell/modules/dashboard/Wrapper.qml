import QtQuick
import Quickshell
import "root:/config"

Item {
    id: root

    required property PersistentProperties visibilities

    // Показываем панель, если высота > 0
    visible: height > 0

    // Начинаем с нуля по высоте, ширина зависит от контента
    implicitWidth: content.implicitWidth
    implicitHeight: 0

    states: State {
        name: "visible"
        when: root.visibilities.dashboard

        PropertyChanges {
            target: root
            implicitHeight: content.implicitHeight
        }
    }

    transitions: [
        // Анимация появления (снизу вверх)
        Transition {
            from: ""
            to: "visible"

            NumberAnimation {
                target: root
                property: "implicitHeight"
                duration: Appearance.anim.durations.expressiveDefaultSpatial
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Appearance.anim.curves.expressiveDefaultSpatial
            }
        },
        // Анимация скрытия (сверху вниз)
        Transition {
            from: "visible"
            to: ""

            NumberAnimation {
                target: root
                property: "implicitHeight"
                duration: Appearance.anim.durations.normal
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Appearance.anim.curves.emphasized
            }
        }
    ]

    // Контент (иконки)
    Content {
        id: content
        visibilities: root.visibilities
    }
}
