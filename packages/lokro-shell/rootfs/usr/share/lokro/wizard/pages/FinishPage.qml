import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import ".." as Wizard

Wizard.StepContainer {
    id: page
    title: qsTr("Fertig")
    description: qsTr("Die Einrichtung ist abgeschlossen")
    nextText: qsTr("Assistent schließen")
    skipText: qsTr("")
    canGoBack: true

    ColumnLayout {
        anchors.fill: parent
        spacing: Kirigami.Units.largeSpacing

        Label {
            Layout.fillWidth: true
            text: qsTr("Du kannst weitere Anpassungen jederzeit über das Welcome-Dashboard oder die Systemeinstellungen vornehmen.")
            wrapMode: Text.WordWrap
            color: "#e4e4e7"
        }

        Label {
            Layout.fillWidth: true
            text: qsTr("Vielen Dank für das Ausprobieren von LOKRO OS.")
            wrapMode: Text.WordWrap
            color: "#a1a1aa"
        }

        Item { Layout.fillHeight: true }
    }

    onNextRequested: wizard.finish()
    onBackRequested: wizard.goBack()
}
