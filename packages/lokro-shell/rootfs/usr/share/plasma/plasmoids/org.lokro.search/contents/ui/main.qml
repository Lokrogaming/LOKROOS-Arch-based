import QtQuick
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasmoid

PlasmoidItem {
    id: root
    toolTipMainText: qsTr("LOKRO Search")
    toolTipSubText: qsTr("Apps, Dateien, Einstellungen und Befehle")
    preferredRepresentation: compactRepresentation

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
