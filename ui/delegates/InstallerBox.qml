import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import org.kde.kirigami 2.11 as Kirigami
import Mycroft 1.0 as Mycroft

Popup {
    id: installBoxRoot
    property var skillModel
    property var installerStatus: sessionData.installer_status ? sessionData.installer_status : 0
    dim: true

    onOpened: {
        installBoxRoot.installerStatus = 0
    }

    onClosed: {
        installBoxRoot.installerStatus = 0
    }

    onInstallerStatusChanged: {
        switch(installerStatus){
            case 0: break;
            case 1: break;
            case 2: installBoxRoot.close(); break;
            case 3: installBoxRoot.close(); break;
        }
    }

    contentItem: Item {
        anchors.fill: parent
        anchors.margins: Kirigami.Units.largeSpacing

        Rectangle {
            id: nameBand
            color: "#121212"
            anchors.top: imageType.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: Kirigami.Units.gridUnit * 3
            border.color: "#717171"
            border.width: 1

            Label {
                anchors.fill: parent
                anchors.margins: Kirigami.Units.smallSpacing
                color: "white"
                maximumLineCount: 1
                elide: Text.ElideRight
                font.pixelSize: parent.height * 0.75
                minimumPixelSize: parent.height * 0.15
                fontSizeMode: Text.Fit
                text: skillModel.title
                clip: true
            }
        }

        Label {
            id: labelType
            anchors.top: nameBand.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: barInstallerLower.top
            anchors.margins: Kirigami.Units.smallSpacing
            color: "white"
            wrapMode: Text.WordWrap
            text: skillModel.description
            elide: Text.ElideRight
            font.pixelSize: parent.height * 0.50
            minimumPixelSize: 5
            fontSizeMode: Text.Fit
            verticalAlignment: Text.AlignTop
            horizontalAlignment: Text.AlignHCenter
        }

        ProgressBar {
            id: barInstallerLower
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: buttonLower.top
            height: Mycroft.Units.gridUnit * 1.5
            indeterminate: installBoxRoot.installerStatus == 1 && installBoxRoot.visible ? 1 : 0
        }

        Button {
            id: buttonLower
            height: parent.height * 0.20
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            enabled: !skillModel.installed
            text: "Install"

            onClicked: {
                triggerGuiEvent("OSMInstaller.openvoiceos.install", {"url": skillModel.url})
            }
        }
    }
}
