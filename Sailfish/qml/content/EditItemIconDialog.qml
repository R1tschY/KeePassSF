/***************************************************************************
**
** Copyright (C) 2016 Marko Koschak (marko.koschak@tisno.de)
** All rights reserved.
**
** This file is part of KeePassSF.
**
** KeePassSF is free software: you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation, either version 2 of the License, or
** (at your option) any later version.
**
** KeePassSF is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with KeePassSF. If not, see <http://www.gnu.org/licenses/>.
**
***************************************************************************/

import QtQuick 2.2
import Sailfish.Silica 1.0
import "../scripts/Global.js" as Global
import "../common"
import harbour.keepasssf 1.0

Dialog {
    id: editItemIconDialog

    property string newIconUuid: ""

    property int itemType: DatabaseItemType.ENTRY

    readonly property int _width:
        Screen.sizeCategory >= Screen.Large ?
            // size on tablet
            mainPage.orientation & Orientation.LandscapeMask ? Screen.height / 12 : Screen.width / 9 :
            // size on phone
            mainPage.orientation & Orientation.LandscapeMask ? Screen.height / 9 : Screen.width / 5
    readonly property int _height:
        Screen.sizeCategory >= Screen.Large ?
            // size on tablet
            Screen.width / 9 :
            // siez on phone
            Screen.width / 5

    canNavigateForward: newIconUuid.length !== 0
    allowedOrientations: applicationWindow.orientationSetting

    SilicaFlickable {
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: col.height

        // Show a scollbar when the view is flicked, place this over all other content
        VerticalScrollDecorator {}

        Column {
            id: col
            width: parent.width

            DialogHeader {
                id: header
                acceptText: qsTr("Select")
                cancelText: qsTr("Cancel")
                spacing: 0
            }

            Item {
                height: Theme.paddingLarge
                width: parent.width
            }

            SilicaLabel {
                text: itemType === DatabaseItemType.GROUP ? qsTr("Choose an icon for the password group:") :
                                                       qsTr("Choose an icon for the password entry:")
            }

            SectionHeader {
                text: qsTr("Keepass Icons")
            }

            SilicaGridView {
                id: keepassIconGridView
                width: editItemIconDialog.width

                model: keepassIconListModel
                cellWidth: editItemIconDialog._width
                cellHeight: editItemIconDialog._height

                delegate: iconDelegate

                Connections {
                    // for breaking the binding loop on height
                    onContentHeightChanged: keepassIconGridView.height = keepassIconGridView.contentHeight
                }
            }

            SectionHeader {
                enabled: !customDatabaseIconListModel.isEmpty
                visible: enabled
                text: qsTr("Custom Database Icons")
            }

            SilicaGridView {
                id: customDatabaseIconGridView
                width: editItemIconDialog.width

                model: customDatabaseIconListModel
                cellWidth: editItemIconDialog._width
                cellHeight: editItemIconDialog._height

                delegate: iconDelegate

                Connections {
                    // for breaking the binding loop on height
                    onContentHeightChanged: customDatabaseIconGridView.height = customDatabaseIconGridView.contentHeight
                }
            }

            SectionHeader {
                enabled: !ownKeepassIconPackListModel.isEmpty
                visible: enabled
                text: qsTr("KeePassSF Icon Pack")
            }

            SilicaGridView {
                id: ownKeepassIconPackGridView
                width: editItemIconDialog.width

                model: ownKeepassIconPackListModel
                cellWidth: editItemIconDialog._width
                cellHeight: editItemIconDialog._height

                delegate: iconDelegate

                Connections {
                    // for breaking the binding loop on height
                    onContentHeightChanged: ownKeepassIconPackGridView.height = ownKeepassIconPackGridView.contentHeight
                }
            }
        }
    }

    IconListModel {
        id: keepassIconListModel
    }

    IconListModel {
        id: customDatabaseIconListModel

        onIconListModelLoaded: { // returns result, errorMsg
            if (result !== DatabaseAccessResult.RE_OK) {
                console.log("ERROR: Loading icon list model")
            }
        }
    }

    IconListModel {
        id: ownKeepassIconPackListModel
    }

    Component {
        id: iconDelegate

        Item {
            width: editItemIconDialog._width
            height: editItemIconDialog._height

            Rectangle {
                color: Theme.rgba(Theme.highlightBackgroundColor, Theme.highlightBackgroundOpacity) //Theme.highlightColor
                visible: model.uuid === newIconUuid
                anchors.fill: parent
//                opacity: 0.5
            }

            Image {
                id: iconBackground
                anchors.centerIn: parent
                width: Theme.itemSizeMedium
                height: Theme.itemSizeMedium
                source: "image://IconBackground"
                fillMode: Image.PreserveAspectFit
                asynchronous: true

                MouseArea {
                    id: iconMouseArea
                    anchors.fill: parent
                    onClicked: {
                        // toggle icon selection
                        if(model.uuid === newIconUuid) {
                            newIconUuid = "";
                        } else {
                            newIconUuid = model.uuid;
                        }
                    }
                }
            }

            Image {
                id: icon
                anchors.centerIn: parent
                width: Theme.iconSizeMedium
                height: Theme.iconSizeMedium
                fillMode: Image.PreserveAspectFit
                asynchronous: true
                opacity: iconMouseArea.pressed ? 0.5 : 1.0
                source: "image://KeepassIcon/" + model.uuid
            }

//            Label {
//                anchors.centerIn: parent
//                color: "red"
//                text: index
//            }
        }
    }

    Component.onCompleted: {
        // Load Keepass group icons, custom database icons from Keepass 2 database and ownKeepass icon pack icons into list models
        if (itemType === DatabaseItemType.ENTRY) {
            keepassIconListModel.initListModel(IconListModel.LOAD_KEEPASS_ENTRY_ICONS)
        } else if (itemType === DatabaseItemType.GROUP) {
            keepassIconListModel.initListModel(IconListModel.LOAD_KEEPASS_GROUP_ICONS)
        }
        customDatabaseIconListModel.initListModel(IconListModel.LOAD_CUSTOM_DATABASE_ICONS)
        ownKeepassIconPackListModel.initListModel(IconListModel.LOAD_OWNKEEPASS_ICON_PACK_ICONS)
    }
}
