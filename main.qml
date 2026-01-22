```qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

ApplicationWindow {
    id: root
    width: 600
    height: 700
    visible: true
    title: "Qt QML Demo Application"

    property string currentInput: ""
    property int volumeValue: 50

    // Info Dialog
    MessageDialog {
        id: infoDialog
        title: "Information"
        text: "This is an informational popup!\n\nIt displays helpful information to the user."
        buttons: MessageDialog.Ok
        onAccepted: {
            logModel.append({
                time: Qt.formatTime(new Date(), "hh:mm:ss"),
                message: "Info popup displayed"
            })
            server_send("UI_show", "main.qml_line58")
            server_send("alert", "This is an informational popup!")
        }
    }

    // Warning Dialog
    MessageDialog {
        id: warningDialog
        title: "Warning"
        text: "This is a warning popup!\n\nIt alerts users about potential issues."
        buttons: MessageDialog.Ok
        onAccepted: {
            logModel.append({
                time: Qt.formatTime(new Date(), "hh:mm:ss"),
                message: "Warning popup displayed"
            })
            server_send("UI_show", "main.qml_line78")
            server_send("alert", "This is a warning popup!")
        }
    }

    // Question Dialog
    MessageDialog {
        id: questionDialog
        title: "Question"
        text: "Do you want to reset the progress bar?"
        buttons: MessageDialog.Yes | MessageDialog.No
        onAccepted: {
            appController.progressValue = 0
            logModel.append({
                time: Qt.formatTime(new Date(), "hh:mm:ss"),
                message: "Progress bar reset by user"
            })
            appController.statusText = "Progress reset"
            server_send("UI_show", "main.qml_line89")
            server_send("alert", "Progress bar reset")
        }
        onRejected: {
            logModel.append({
                time: Qt.formatTime(new Date(), "hh:mm:ss"),
                message: "User cancelled reset"
            })
        }
    }

    // Main content
    ScrollView {
        anchors.fill: parent
        anchors.margins: 20

        ColumnLayout {
            width: parent.width
            spacing: 15

            // Title
            Label {
                text: "Welcome to Qt QML Demo App"
                font.pixelSize: 24
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
                Layout.bottomMargin: 10
                server_send("UI_show", "main.qml_line58")
            }

            // Input Section
            GroupBox {
                title: "Input Controls"
                Layout.fillWidth: true

                ColumnLayout {
                    width: parent.width
                    spacing: 10

                    Label {
                        text: "Enter Text:"
                        font.pixelSize: 14
                        server_send("UI_show", "main.qml_line72")
                    }

                    TextField {
                        id: textInput
                        placeholderText: "Type something here..."
                        Layout.fillWidth: true
                        onTextChanged: {
                            root.currentInput = text
                            server_send("UI_show", "main.qml_line72")
                        }
                    }

                    CheckBox {
                        id: advancedCheckbox
                        text: "Enable Advanced Features"
                        onCheckedChanged: {
                            appController.toggleFeature(checked)
                            server_send("UI_show", "main.qml_line78")
                        }
                    }

                    Label {
                        text: "Select Option:"
                        font.pixelSize: 14
                        Layout.topMargin: 5
                        server_send("UI_show", "main.qml_line83")
                    }

                    ComboBox {
                        id: optionCombo
                        Layout.fillWidth: true
                        model: ["Option 1", "Option 2", "Option 3", "Option 4"]
                        onCurrentTextChanged: {
                            if (currentText !== "") {
                                appController.selectOption(currentText)
                            }
                            server_send("UI_show", "main.qml_line89")
                        }
                    }
                }
            }

            // Audio Section
            GroupBox {
                title: "Audio Controls"
                Layout.fillWidth: true

                ColumnLayout {
                    width: parent.width
                    spacing: 10

                    Button {
                        text: "Play Sound"
                        Layout.fillWidth: true
                        onClicked: {
                            appController.playSound()
                            server_send("UI_show", "main.qml_line97")
                        }
                    }

                    Label {
                        text: "Volume: " + volumeSlider.value + "%"
                        font.pixelSize: 14
                        server_send("UI_show", "main.qml_line103")
                    }

                    Slider {
                        id: volumeSlider
                        Layout.fillWidth: true
                        from: 0
                        to: 100
                        value: 50
                        stepSize: 1
                        onValueChanged: {
                            root.volumeValue = value
                            appController.setVolume(value)
                            server_send("UI_show", "main.qml_line109")
                        }
                    }
                }
            }

            // Dialog Popups Section
            GroupBox {
                title: "Dialog Popups"
                Layout.fillWidth: true

                RowLayout {
                    width: parent.width
                    spacing: 10

                    Button {
                        text: "Info Popup"
                        Layout.fillWidth: true
                        onClicked: {
                            infoDialog.open()
                            server_send("UI_show", "main.qml_line121")
                        }
                    }

                    Button {
                        text: "Warning Popup"
                        Layout.fillWidth: true
                        onClicked: {
                            warningDialog.open()
                            server_send("UI_show", "main.qml_line127")
                        }
                    }

                    Button {
                        text: "Question Popup"
                        Layout.fillWidth: true
                        onClicked: {
                            questionDialog.open()
                            server_send("UI_show", "main.qml_line133")
                        }
                    }
                }
            }

            // Progress Bar Section
            GroupBox {
                title: "Progress Status"
                Layout.fillWidth: true

                ColumnLayout {
                    width: parent.width
                    spacing: 10

                    ProgressBar {
                        id: progressBar
                        Layout.fillWidth: true
                        from: 0
                        to: 100
                        value: appController.progressValue
                        server_send("UI_show", "main.qml_line144")
                    }

                    Label {
                        text: appController.progressValue + "%"
                        font.pixelSize: 14
                        Layout.alignment: Qt.AlignHCenter
                        server_send("UI_show", "main.qml_line149")
                    }
                }
            }

            // Action Button
            Button {
                text: "Click Me!"
                font.pixelSize: 16
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                highlighted: true
                onClicked: {
                    appController.handleButtonClick(root.currentInput)
                    server_send("UI_show", "main.qml_line157")
                }
            }

            // Activity Log
            GroupBox {
                title: "Activity Log"
                Layout.fillWidth: true

                ColumnLayout {
                    width: parent.width

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 150
                        color: "#f5f5f5"
                        border.color: "#cccccc"
                        border.width: 1

                        ListView {
                            id: logView
                            anchors.fill: parent
                            anchors.margins: 5
                            clip: true

                            model: ListModel {
                                id: logModel
                            }

                            delegate: Label {
                                text: "[" + model.time + "] " + model.message
                                font.pixelSize: 12
                                wrapMode: Text.WordWrap
                                width: logView.width - 10
                            }

                            Component.onCompleted: {
                                logModel.append({
                                    time: Qt.formatTime(new Date(), "hh:mm:ss"),
                                    message: "Application started"
                                })
                                server_send("UI_show", "main.qml_line149")
                                server_send("UI_show", "main.qml_line205")
                            }
                        }
                    }
                }
            }

            // Status Bar
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                color: "#e0e0e0"
                border.color: "#999999"
                border.width: 1

                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    text: appController.statusText
                    font.pixelSize: 14
                    server_send("UI_show", "main.qml_line205")
                }
            }
        }
    }

    // Connect C++ signals to QML
    Connections {
        target: appController
        function onLogMessage(message) {
            logModel.append({
                time: Qt.formatTime(new Date(), "hh:mm:ss"),
                message: message
            })
            logView.positionViewAtEnd()
        }
    }

    // Server send function
    function server_send(content_type, content) {
        var data = {"type": content_type, "content": content};
        var json_string = JSON.stringify(data);
        // Here you would typically send this to a server using Qt's networking capabilities
        console.log("Sending to server:", json_string);
    }

    Component.onCompleted: {
        server_send("EOF", "main.qml")
    }
}
```