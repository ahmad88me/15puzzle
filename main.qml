import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2

ApplicationWindow {
    title: qsTr("Hello World")
    width: 640
    height: 580
    visible: true

//    menuBar: MenuBar {
//        Menu {
//            title: qsTr("&File")
//            MenuItem {
//                text: qsTr("&Open")
//                onTriggered: messageDialog.show(qsTr("Open action triggered"));
//            }
//            MenuItem {
//                text: qsTr("E&xit")
//                onTriggered: Qt.quit();
//            }
//        }
//    }

    PuzzleGenerator{
        id: puzzlegenerator
        width: parent.width
        height: parent.height
    }

//    SolutionValidatorPage{
//        width: parent.width
//        height: parent.height
//    }


//    MessageDialog {
//        id: messageDialog
//        title: qsTr("May I have your attention, please?")
//        function show(caption) {
//            messageDialog.text = caption;
//            messageDialog.open();
//        }
//    }
}
