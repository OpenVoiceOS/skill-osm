import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import org.kde.kirigami 2.11 as Kirigami
import Mycroft 1.0 as Mycroft

Mycroft.Delegate {
    skillBackgroundColorOverlay: "#20bcfc"
    leftPadding: 0
    rightPadding: 0
    topPadding: 0
    bottomPadding: 0
    property bool lviewFirstItem: lview.view.currentIndex != 0 ? 1 : 0

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
                //color: "grey"

                RowLayout {
                    width: parent.width
                    height: parent.height
                    spacing: Kirigami.Units.largeSpacing

                    Button {
                        id: ovosStore
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.alignment: Qt.AlignVCenter

                        background: Rectangle {
                            color: "transparent"
                        }

                        contentItem: Kirigami.Heading {
                            level: 3
                            color: "white"
                            font.bold: true
                            font.pixelSize: height * 0.9
                            verticalAlignment: Text.verticalCenter
                            horizontalAlignment: Text.horizontalCenter
                            text: "OVOS"

                            Kirigami.Separator {
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: -Kirigami.Units.smallSpacing
                                color: Kirigami.Theme.negativeTextColor
                                width: parent.contentWidth + Kirigami.Units.largeSpacing + 2
                                height: Kirigami.Units.smallSpacing * 0.5
                            }
                        }
                    }

                    Button {
                        id: plingStore
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.alignment: Qt.AlignVCenter

                        background: Rectangle {
                            color: "transparent"
                        }

                        contentItem: Kirigami.Heading {
                            level: 3
                            color: "white"
                            font.bold: true
                            font.pixelSize: height * 0.9
                            verticalAlignment: Text.verticalCenter
                            horizontalAlignment: Text.horizontalCenter
                            text: "Pling"

                            Kirigami.Separator {
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: -Kirigami.Units.smallSpacing
                                color: "#313131" //Kirigami.Theme.negativeTextColor
                                width: parent.contentWidth + Kirigami.Units.largeSpacing + 2
                                height: Kirigami.Units.smallSpacing * 0.5
                            }
                        }
                    }

                    Button {
                        id: andloStore
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.alignment: Qt.AlignVCenter

                        background: Rectangle {
                            color: "transparent"
                        }

                        contentItem: Kirigami.Heading {
                            level: 3
                            color: "white"
                            font.bold: true
                            font.pixelSize: height * 0.9
                            verticalAlignment: Text.verticalCenter
                            horizontalAlignment: Text.horizontalCenter
                            text: "Andlo's"

                            Kirigami.Separator {
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: -Kirigami.Units.smallSpacing
                                color: "#313131" //Kirigami.Theme.negativeTextColor
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
                        Layout.fillWidth: true
                        Layout.fillHeight: true
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
                    text: "OpenVoiceOS Skills Appstore"
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
            
            TileView {
                id: lview
                focus: true
                cellWidth: parent.width / 3.5
                anchors.top: subTopBar.bottom
                anchors.left: leftarrow.right
                anchors.right: rightarrow.left
                anchors.bottom: parent.bottom
                model: sessionData.appstore_model
                clip: true
                delegate: Rectangle {
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
                    color: "transparent"
                    
                    Rectangle {
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
                        }
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
    }
}
 
