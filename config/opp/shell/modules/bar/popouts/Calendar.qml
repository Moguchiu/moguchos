import "root:/widgets"
import "root:/services"
import "root:/config"
import QtQuick 
import QtQuick.Controls 
import QtQuick.Layouts 
import QtQuick.Window 

Item {
    id: root

    property var currentDate: new Date()

    implicitWidth: 260
    implicitHeight: layout.implicitHeight + 10

    Rectangle {
        anchors.fill: parent
        color: Colours.palette.m3surface // Gruvbox dark background
        radius: 8
    }

    ColumnLayout {
        id: layout
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        // Header with month/year and nav
        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            ToolButton {
                text: "<"
                font.bold: true
                background: Rectangle { color: "transparent" }
                onClicked: {
                    let d = new Date(root.currentDate)
                    d.setMonth(d.getMonth() - 1)
                    root.currentDate = d
                }
                contentItem: Label {
                    text: "<"
                    color: Colours.palette.m3tertiary_paletteKeyColor
                    font.pointSize: 16
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Label {
                text: Qt.formatDate(root.currentDate, "MMMM yyyy")
                color: Colours.palette.m3secondary_paletteKeyColor
                font.pointSize: 14
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                Layout.fillWidth: true
            }

            ToolButton {
                text: ">"
                font.bold: true
                background: Rectangle { color: "transparent" }
                onClicked: {
                    let d = new Date(root.currentDate)
                    d.setMonth(d.getMonth() + 1)
                    root.currentDate = d
                }
                contentItem: Label {
                    text: ">"
                    color: Colours.palette.m3tertiary_paletteKeyColor
                    font.pointSize: 16
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        // Day headers
        GridLayout {
            columns: 7
            Layout.fillWidth: true
            //rowSpacing: 2
            columnSpacing: 11  // ← контролируешь промежутки между днями
            //Layout.alignment: Qt.AlignHCenter
            Repeater {
                model: ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
                Label {
                    text: modelData
                    color: Colours.palette.m3primary_paletteKeyColor
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }

        // Day numbers
        GridLayout {
            id: grid
            columns: 7
            Layout.fillWidth: true

            property int year: root.currentDate.getFullYear()
            property int month: root.currentDate.getMonth()
            property int firstDayOffset: {
                let d = new Date(year, month, 1)
                let day = d.getDay()
                return day === 0 ? 6 : day - 1
            }
            property int numDays: new Date(year, month + 1, 0).getDate()

            Repeater {
                model: grid.firstDayOffset + grid.numDays
                delegate: Rectangle {
                    width: 28
                    height: 28
                    color: {
                        let day = index - grid.firstDayOffset + 1
                        if (index < grid.firstDayOffset) return "transparent"
                        let now = new Date()
                        if (
                            day === now.getDate() &&
                            grid.month === now.getMonth() &&
                            grid.year === now.getFullYear()
                        ) {
                            return Colours.palette.m3secondary_paletteKeyColor // Accent
                        }
                        return "transparent"
                    }
                    radius: 14
                    border.color: Colours.palette.m3surfaceBright

                    Label {
                        anchors.centerIn: parent
                        text: index < grid.firstDayOffset ? "" : (index - grid.firstDayOffset + 1)
                        color: {
                            let day = index - grid.firstDayOffset + 1
                            let now = new Date()
                            if (
                                day === now.getDate() &&
                                grid.month === now.getMonth() &&
                                grid.year === now.getFullYear()
                            ) {
                                return Colours.palette.m3surface 
                            }
                            return Colours.palette.m3inverseSurface
                        }
                        font.pointSize: 11
                    }
                }
            }
        }
    }
}
