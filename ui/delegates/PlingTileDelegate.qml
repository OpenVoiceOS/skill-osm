import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import org.kde.kirigami 2.11 as Kirigami
import Mycroft 1.0 as Mycroft

ItemDelegate {
    id: delegate

    readonly property Flickable listView: {
        var candidate = parent;
        while (candidate) {
            if (candidate instanceof Flickable) {
                return candidate;
            }
            candidate = candidate.parent;
        }
        return null;
    }

    implicitWidth: listView.cellWidth
    height: listView.height

    background: Rectangle {
        color: "transparent"
    }

    contentItem: Rectangle {
        anchors.fill: parent
        anchors.margins: Kirigami.Units.largeSpacing
        color: "#313131"

        Rectangle {
            id: imageType
            anchors.top: parent.top
            width: parent.width
            height: width * 0.5625
            color: "#212121"

            Image {
                source: model.logo
                anchors.centerIn: parent
                width: parent.width
                height: parent.height
            }
        }

        Rectangle {
            id: nameBand
            color: "#121212"
            anchors.top: imageType.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: Kirigami.Units.gridUnit * 2
            border.color: "#717171"
            border.width: 1

            Label {
                anchors.fill: parent
                anchors.margins: Kirigami.Units.smallSpacing
                color: "white"
                maximumLineCount: 1
                elide: Text.ElideRight
                text: model.title
                clip: true
            }
        }

        Label {
            id: labelType
            anchors.top: nameBand.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: Kirigami.Units.smallSpacing
            color: "white"
            wrapMode: Text.WordWrap
            text: model.description
            elide: Text.ElideRight
            verticalAlignment: Text.AlignTop
            horizontalAlignment: Text.AlignHCenter
            clip: true
        }
    }

    onClicked: {
        installerPopBox.skillModel = model
        installerPopBox.open()
    }
}
