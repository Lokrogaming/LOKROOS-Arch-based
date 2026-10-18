import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Item {
    id: container
    property string title: ""
    property string description: ""
    property bool canGoBack: false
    property bool canGoNext: true
    property string nextText: qsTr("Weiter")
    property string backText: qsTr("Zurück")
    property string skipText: qsTr("Überspringen")

    signal nextRequested()
    signal backRequested()
    signal skipRequested()

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Kirigami.Units.gridUnit * 2
        spacing: Kirigami.Units.largeSpacing

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Kirigami.Units.smallSpacing
            Label {
                text: container.title
                color: "#fafafa"
                font.pixelSize: 28
                font.bold: true
                wrapMode: Text.WordWrap
            }
            Label {
                text: container.description
                color: "#a1a1aa"
                font.pixelSize: 15
                wrapMode: Text.WordWrap
                visible: text.length > 0
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            children: container.data
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Kirigami.Units.mediumSpacing

            Button {
                text: container.skipText
                onClicked: container.skipRequested()
                visible: container.skipText.length > 0
            }

            Item { Layout.fillWidth: true }

            Button {
                text: container.backText
                onClicked: container.backRequested()
                enabled: container.canGoBack
            }
            Button {
                text: container.nextText
                highlighted: true
                onClicked: container.nextRequested()
                enabled: container.canGoNext
            }
        }
    }
}
