import "root:/services"
import "root:/config"
import Quickshell
import QtQuick

 Item {
     id: root

    // обрезаем всё, что выходит за пределы текущей высоты
    clip: true

     required property PersistentProperties visibilities

     // Показываем Item, когда его высота положительна
     visible: height > 0

     // По умолчанию — свернуто
     implicitHeight: 0
     // Ширина берётся из контента, чтобы не сжимать его
     implicitWidth: content.implicitWidth

     states: State {
         name: "visible"
         when: root.visibilities.session

         PropertyChanges {
             // В состоянии "visible" разворачиваем по высоте до высоты контента
             target: root
             implicitHeight: content.implicitHeight
         }
     }

     transitions: [
         // Анимация развёртывания (сверху вниз)
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
         // Анимация сворачивания (сверху вниз)
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

     Content {
         id: content
         visibilities: root.visibilities
     }

 }
