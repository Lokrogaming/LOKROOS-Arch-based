import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import ".." as Wizard

Wizard.StepContainer {
    id: page
    title: qsTr("Willkommen beim LOKRO OS Einrichtungsassistenten")
    description: qsTr("Dieser Assistent führt dich durch die ersten Schritte. Jeder Schritt ist überspringbar. Es werden keine Zwangs-Downloads durchgeführt.")
    nextText: qsTr("Los geht's")
    skipText: qsTr("Später überspringen")
    canGoBack: false

    ColumnLayout {
        anchors.fill: parent
        spacing: Kirigami.Units.largeSpacing

        Label {
            Layout.fillWidth: true
            text: qsTr("LOKRO OS ist ein experimentelles Arch-basiertes Desktop-System. Diese Einrichtung richtet grundlegende Präferenzen ein, ohne das Basissystem automatisch zu verändern.")
            wrapMode: Text.WordWrap
            color: "#e4e4e7"
        }

        Label {
            Layout.fillWidth: true
            text: qsTr("Hinweis: Im Live-Image läuft bereits der Live-Installer. Dieser Assistent ist für das installierte Zielsystem gedacht.")
            wrapMode: Text.WordWrap
            color: "#71717a"
        }

        Item { Layout.fillHeight: true }
    }

    onNextRequested: wizard.goNext()
    onSkipRequested: wizard.skip()
}
