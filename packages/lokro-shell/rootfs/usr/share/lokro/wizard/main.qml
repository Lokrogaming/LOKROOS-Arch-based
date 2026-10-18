import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import "pages" as Pages

ApplicationWindow {
    id: wizard
    width: 900
    height: 640
    minimumWidth: 780
    minimumHeight: 560
    visible: true
    title: qsTr("LOKRO OS Einrichtungsassistent")
    color: "#070708"

    property int currentIndex: 0
    readonly property var pages: [welcome, theme, finish]

    function goNext() {
        if (currentIndex < pages.length - 1) {
            currentIndex++
            pageStack.currentIndex = currentIndex
        } else {
            finish()
        }
    }

    function goBack() {
        if (currentIndex > 0) {
            currentIndex--
            pageStack.currentIndex = currentIndex
        }
    }

    function skip() {
        goNext()
    }

    function finish() {
        // Erstellt Flag für First-Run (konzeptionell)
        wizard.close()
    }

    SwipeView {
        id: pageStack
        anchors.fill: parent
        currentIndex: wizard.currentIndex
        interactive: false

        Pages.WelcomePage { id: welcome }
        Pages.ThemePage { id: theme }
        Pages.FinishPage { id: finish }
    }

    PageIndicator {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: Kirigami.Units.gridUnit
        count: pageStack.count
        currentIndex: pageStack.currentIndex
    }
}
