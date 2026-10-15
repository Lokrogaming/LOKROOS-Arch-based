import QtQuick
import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid

PlasmoidItem {
    id: root
    toolTipMainText: qsTr("LOKRO Search")
    toolTipSubText: qsTr("Apps, Dateien, Einstellungen und Befehle")
    preferredRepresentation: compactRepresentation

    Plasmoid.contextualActions: [
        PlasmaCore.Action {
            text: qsTr("Einstellungen")
            icon.name: "preferences-system"
            onTriggered: Qt.openUrlExternally("lokro-action:settings")
        },
        PlasmaCore.Action {
            text: qsTr("Taskmanager")
            icon.name: "utilities-system-monitor"
            onTriggered: Qt.openUrlExternally("lokro-action:taskmanager")
        },
        PlasmaCore.Action {
            text: qsTr("Updates")
            icon.name: "system-software-update"
            onTriggered: Qt.openUrlExternally("lokro-action:updates")
        },
        PlasmaCore.Action {
            text: qsTr("Herunterfahren")
            icon.name: "system-shutdown"
            onTriggered: Qt.openUrlExternally("lokro-action:shutdown")
        }
    ]

    compactRepresentation: Kirigami.Icon {
        source: "system-search"
        active: searchMouse.containsMouse
        MouseArea {
            id: searchMouse
            anchors.fill: parent
            hoverEnabled: true
            onClicked: Qt.openUrlExternally("lokro-action:search")
        }
    }
}
