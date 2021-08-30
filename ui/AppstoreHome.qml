import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import org.kde.kirigami 2.11 as Kirigami
import Mycroft 1.0 as Mycroft
import "delegates" as Delegate

Mycroft.Delegate {
    id: delRoot
    skillBackgroundColorOverlay: "#20bcfc"
    leftPadding: 0
    rightPadding: 0
    topPadding: 0
    bottomPadding: 0
    property bool lviewFirstItem: lview.view.currentIndex != 0 ? 1 : 0
    property var ovos_skills_model: sessionData.appstore_ovos_model
    property var pling_skills_model: sessionData.appstore_pling_model
    property Component ovos_delegate: Delegate.OVOSTileDelegate{}
    property Component pling_delegate: Delegate.PlingTileDelegate{}

    Component.onCompleted: {
        console.log("Checking Checked Tab")
        console.log(storeAppsGroup.checkedButton.objectName)
    }

    ButtonGroup {
        id: storeAppsGroup
        buttons: topButtonLayout.children
    }

    Rectangle {
        anchors.fill: parent
        
        gradient: Gradient {
            GradientStop {
                color: Qt.rgba(0, 0, 0, 0.85)
                position: 0.0
            }
            GradientStop {
                color: "#20bcfc"
                position: 0.0
            }
            GradientStop {
                color: Qt.rgba(0, 0, 0, 0.25)
                position: 0.50
            }
            GradientStop {
                color: Qt.rgba(0, 0, 0, 0.85)
                position: 0.95
            }
        }

        Item {
            anchors.fill: parent
            anchors.margins: 16

            Item {
                id: topBar
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: Kirigami.Units.gridUnit * 2

                RowLayout {
                    id: topButtonLayout
                    width: parent.width
                    height: parent.height
                    spacing: Kirigami.Units.largeSpacing

                    Button {
                        id: ovosStore
                        Layout.preferredWidth: contentItem.contentWidth + (Mycroft.Units.gridUnit * 2)
                        Layout.fillHeight: true
                        Layout.alignment: Qt.AlignVCenter
                        checkable : true
                        checked: true
                        objectName: "ovos-button"

                        background: Rectangle {
                            color: "transparent"
                        }

                        contentItem: Kirigami.Heading {
                            level: 3
                            color: "white"
                            font.bold: true
                            font.pixelSize: height * 0.9
                            font.capitalization: Font.SmallCaps
                            verticalAlignment: Text.verticalCenter
                            horizontalAlignment: Text.horizontalCenter
                            text: "Ovos"

                            Kirigami.Separator {
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: -Kirigami.Units.smallSpacing
                                color: storeAppsGroup.checkedButton.objectName == "ovos-button" ? Kirigami.Theme.negativeTextColor : "#313131"
                                width: parent.contentWidth + Kirigami.Units.largeSpacing + 2
                                height: Kirigami.Units.smallSpacing * 0.5
                            }
                        }
                    }

                    Button {
                        id: plingStore
                        Layout.preferredWidth: contentItem.contentWidth + (Mycroft.Units.gridUnit * 2)
                        Layout.fillHeight: true
                        Layout.alignment: Qt.AlignVCenter
                        checkable : true
                        checked: false
                        objectName: "pling-button"

                        background: Rectangle {
                            color: "transparent"
                        }

                        contentItem: Kirigami.Heading {
                            level: 3
                            color: "white"
                            font.bold: true
                            font.pixelSize: height * 0.9
                            font.capitalization: Font.SmallCaps
                            verticalAlignment: Text.verticalCenter
                            horizontalAlignment: Text.horizontalCenter
                            text: "Pling"

                            Kirigami.Separator {
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: -Kirigami.Units.smallSpacing
                                color: storeAppsGroup.checkedButton.objectName == "pling-button" ? Kirigami.Theme.negativeTextColor : "#313131"
                                width: parent.contentWidth + Kirigami.Units.largeSpacing + 2
                                height: Kirigami.Units.smallSpacing * 0.5
                            }
                        }
                    }
                    
                    Item {
                        Layout.fillWidth: true
                    }
                    
                    Button {
                        id: searchStore
                        Layout.fillHeight: true
                        Layout.preferredWidth: height
                        Layout.alignment: Qt.AlignVCenter | Qt.AlignRight

                        background: Rectangle {
                            color: "transparent"
                        }
                        
                        contentItem: Kirigami.Icon {
                            source: Qt.resolvedUrl("images/search.png")
                        }
                    }
                }
            }

            Rectangle {
                id: subTopBar
                anchors.top: topBar.bottom
                anchors.topMargin: Kirigami.Units.largeSpacing
                anchors.left: parent.left
                anchors.leftMargin: -16
                anchors.right: parent.right
                anchors.rightMargin: -16
                height: Kirigami.Units.gridUnit * 1.5
                color: "#313131"

                Label {
                    id: selectedStoreLabel
                    anchors.fill: parent
                    anchors.leftMargin: Kirigami.Units.largeSpacing
                    anchors.topMargin: Kirigami.Units.smallSpacing
                    anchors.bottomMargin: Kirigami.Units.smallSpacing
                    color: "white"
                    text: storeAppsGroup.checkedButton.objectName == "ovos-button" ? "OpenVoiceOS Skills Appstore" : "Pling Skills Appstore"
                }
                
                Button {
                    id: sortStore
                    width: Kirigami.Units.iconSizes.small
                    height: width
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: Kirigami.Units.largeSpacing
                    
                    background: Rectangle {
                        color: "transparent"
                    }
                    
                    contentItem: Kirigami.Icon {
                        source: Qt.resolvedUrl("images/settings.png")
                    }
                }
            }
            
            Item {
                id: leftarrow
                anchors.top: subTopBar.bottom
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                width: Kirigami.Units.iconSizes.large

                Kirigami.Icon {
                    source: Qt.resolvedUrl("images/left.png")
                    width: Kirigami.Units.iconSizes.medium
                    height: Kirigami.Units.iconSizes.medium
                    anchors.centerIn: parent
                    enabled: lviewFirstItem
                    opacity: lviewFirstItem ? 1 : 0.4
                }
            }
            
            Item {
                id: centeringItem
                anchors.top: subTopBar.bottom
                anchors.left: leftarrow.right
                anchors.right: rightarrow.left
                anchors.bottom: parent.bottom

                TileView {
                    id: lview
                    focus: true
                    width: parent.width
                    height: parent.height
                    cellWidth: parent.width / 3.25
                    clip: true
                    anchors.centerIn: parent
                    model: switch(storeAppsGroup.checkedButton.objectName){
                        case "ovos-button": return delRoot.ovos_skills_model; break
                        case "pling-button": return delRoot.pling_skills_model; break
                    }
                    delegate: switch(storeAppsGroup.checkedButton.objectName){
                        case "ovos-button": return delRoot.ovos_delegate; break
                        case "pling-button": return delRoot.pling_delegate; break
                    }
                }
            }
            
            Item {
                id: rightarrow
                anchors.top: subTopBar.bottom
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                width: Kirigami.Units.iconSizes.large

                Kirigami.Icon {
                    source: Qt.resolvedUrl("images/right.png")
                    width: Kirigami.Units.iconSizes.medium
                    height: Kirigami.Units.iconSizes.medium
                    anchors.centerIn: parent
                    enabled: lview.currentIndex != (lview.view.count - 1) ? 1 : 0
                    opacity: lview.currentIndex != (lview.view.count - 1) ? 1 : 0.4
                }
            }
        }

        Delegate.InstallerBox {
            id: installerPopBox
            width: parent.width * 0.75
            height: parent.height * 0.75
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2
        }
    }
}
