import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import ".." as Wizard

Wizard.StepContainer {
    id: page
    title: qsTr("Aussehen")
    description: qsTr("Wähle das bevorzugte Farbschema")
    nextText: qsTr("Weiter")
    skipText: qsTr("Überspringen")
    canGoBack: true

    ColumnLayout {
        anchors.fill: parent
        spacing: Kirigami.Units.largeSpacing

        Label {
            Layout.fillWidth: true
            text: qsTr("LOKRO Dark ist voreingestellt. Du kannst das Erscheinungsbild später jederzeit in den Systemeinstellungen ändern.")
            wrapMode: Text.WordWrap
            color: "#e4e4e7"
        }

        RowLayout {
            spacing: Kirigami.Units.mediumSpacing
            Button {
                text: qsTr("Dunkel")
                onClicked: Qt.openUrlExternally("lokro-action:theme-dark")
            }
            Button {
                text: qsTr("Hell")
                onClicked: Qt.openUrlExternally("lokro-action:theme-light")
            }
        }

        Item { Layout.fillHeight: true }
    }

    onNextRequested: wizard.goNext()
    onBackRequested: wizard.goBack()
    onSkipRequested: wizard.skip()
}
