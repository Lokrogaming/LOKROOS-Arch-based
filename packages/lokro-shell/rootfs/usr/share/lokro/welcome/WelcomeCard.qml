import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Rectangle {
    id: card
    required property string title
    required property string iconName
    required property string detail
    required property string primaryText
    required property string secondaryText
    property string footer: ""
    signal primary()
    signal secondary()

    Layout.fillWidth: true
    Layout.minimumWidth: 255
    implicitHeight: 226
    radius: 16
    color: hoverHandler.hovered ? "#202024" : "#151518"
    border.color: hoverHandler.hovered ? "#71717a" : "#323238"
    Behavior on color { ColorAnimation { duration: 120 } }

    HoverHandler { id: hoverHandler }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 10
        RowLayout {
            Kirigami.Icon {
                source: card.iconName
                implicitWidth: 28
                implicitHeight: 28
                color: "#f4f4f5"
            }
            Label {
                text: card.title
                color: "#fafafa"
                font.pixelSize: 18
                font.bold: true
            }
        }
        Label {
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: card.detail
            color: "#d4d4d8"
            wrapMode: Text.WordWrap
        }
        RowLayout {
            Layout.fillWidth: true
            Button {
                Layout.fillWidth: true
                text: card.primaryText
                onClicked: card.primary()
            }
            Button {
                Layout.fillWidth: true
                text: card.secondaryText
                onClicked: card.secondary()
            }
        }
        Label {
            Layout.fillWidth: true
            text: card.footer
            color: "#71717a"
            font.pixelSize: 11
            elide: Text.ElideRight
        }
    }
}
