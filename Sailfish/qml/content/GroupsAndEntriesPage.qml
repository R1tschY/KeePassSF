/***************************************************************************
**
** Copyright (C) 2013 - 2015 Marko Koschak (marko.koschak@tisno.de)
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
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with KeePassSF. If not, see <http://www.gnu.org/licenses/>.
**
***************************************************************************/

import QtQuick 2.0
import Sailfish.Silica 1.0
import "../common"
import "../scripts/Global.js" as Global
import harbour.keepasssf 1.0

Page {
    id: groupsAndEntriesPage

    // This page is preloaded when the Query Password Dialog is shown. But without password the
    // database cannot be opened and therefore within this page it will give an error if we load groups
    // from the KdbListModel on startup. So the init() function is invoked later when the database could
    // be opened successfully with the master password.
    property bool initOnPageConstruction: true
    // ID of the keepass group which should be shown ("0" for master groups)
    property string groupId: "0"
    property string parentIconUuid: "icf0"
    property string pageTitle: qsTr("Password groups and entries")

    // private properties and funtions
    property bool __closeOnError: false
    property string __saveState: state

    function init() {
        if (ownKeepassSettings.showSearchBar) {
            groupsAndEntriesPage.state = "SEARCH_BAR_SHOWN"
        } else {
            groupsAndEntriesPage.state = "SEARCH_BAR_HIDDEN"
        }

        loadGroups()
    }

    function loadGroups() {
            kdbListModel.loadGroupsAndEntriesFromDatabase(groupId)
    }

    function closeOnError() {
        __closeOnError = true
        if (status === PageStatus.Active) pageStack.pop(pageStack.previousPage(groupsAndEntriesPage))
    }

    allowedOrientations: applicationWindow.orientationSetting

    Item {
        id: headerBox
        // attach y position of header box to list view content y position
        // that way the header box moves accordingly when pulley menus are opened
        y: 0 - listView.contentY - height
        z: 1
        width: parent.width
        height: pageHeader.height + searchField.height

        PageHeaderExtended {
            id: pageHeader
            anchors.top: parent.top
            anchors.left: parent.left
            width: parent.width
            subTitle: "KeePassSF"
            subTitleOpacity: 0.5
            subTitleBottomMargin: groupsAndEntriesPage.orientation & Orientation.PortraitMask ? Theme.paddingSmall : 0
        }

        SearchField {
            id: searchField
            property int enabledHeight: 0
            anchors.top: pageHeader.bottom
            anchors.left: parent.left
            width: parent.width
            opacity: enabled ? 1.0 : 0.0
            placeholderText: qsTr("Search")
            EnterKey.iconSource: "image://theme/icon-m-enter-close"
            EnterKey.onClicked: listView.focus = true

            onTextChanged: {
                if (text.length > 0) {
                    // set group Id from which the search should be performed
                    kdbListModel.searchRootGroupId = groupId
                    kdbListModel.searchEntriesInKdbDatabase(searchField.text)
                } else {
                    kdbListModel.clearListModel()
                    // reload original group content when searchfield is empty
                    loadGroups()
                }
            }

            onFocusChanged: {
                if (focus) {
                    groupsAndEntriesPage.state = "SEARCHING"
                } else {
                    if (text.length === 0 && groupsAndEntriesPage.state === "SEARCHING") {
                        groupsAndEntriesPage.state = "SEARCH_BAR_SHOWN"
                    }
                }
            }

            onEnabledChanged: {
                // save height of search field once it is set to zero so that we can restore it again (when search bar shall appear again triggered by pulley menu item)
                if (enabledHeight === 0) {
                    enabledHeight = height
                }
                height = enabled ? enabledHeight : 0
            }

            Behavior on height { NumberAnimation { duration: 200; easing.type: Easing.OutQuad }}
            Behavior on opacity { FadeAnimation { duration: 200 }}
        }
    }

    SilicaListView {
        id: listView
        currentIndex: -1
        anchors.fill: parent
        model: kdbListModel

        header: Item {
            // This is just a placeholder for the header box. To avoid the
            // list view resetting the input box everytime the model resets,
            // the search entry is defined outside the list view.
            height: headerBox.height

        }

        ViewSearchPlaceholder {
            id: searchNoEntriesFoundPlaceholder
            // we need to bind the y position of the placeholder to the list view content so that it moves when pulley menu is opened
            y: 0 - listView.contentY
            height: parent.height - headerBox.height
            width: parent.width
            text: qsTr("No entries found")

            onClicked: {
                searchField.forceActiveFocus()
            }
        }

        Item {
            anchors.fill: parent

            Column {
                anchors.centerIn: parent
                width: parent.width
                spacing: Theme.paddingLarge

                SilicaLabel {
                    horizontalAlignment: Text.AlignHCenter
                    enabled: busyIndicator.running
                    visible: busyIndicator.running
                    text: qsTr("Decrypting Keepass database")
                    color: Theme.secondaryHighlightColor
                    font.pixelSize: Theme.fontSizeExtraLarge
                    Behavior on opacity { FadeAnimation {} }
                }

                BusyIndicator {
                    id: busyIndicator
                    anchors.horizontalCenter: parent.horizontalCenter
                    enabled: running
                    visible: running
                    running: false
                    size: BusyIndicatorSize.Large
                    Behavior on opacity { FadeAnimation {} }
                }
            }
        }

        ViewPlaceholder {
            id: viewPlaceholder
            verticalOffset: wallImage.height / 2

            text: qsTr("Group is empty")
            hintText: !ownKeepassDatabase.readOnly ? qsTr("Pull down to add password groups or entries") : ""

            Image {
                id: wallImage
                anchors.bottom: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                source: "../../wallicons/wall-group.png"
                width: height
                height: implicitHeight * Screen.height / 1920
            }
        }

        DatabaseMenu {
            id: databaseMenu
            menuLabelText: Global.activeDatabase

            onNewPasswordGroupClicked: {
                // empty searchField
                searchField.text = ""
                // set default icon id and delete custom icon uuid per default, too
                pageStack.push(Global.env.mainPage.editGroupDetailsDialogComponent,
                               { "createNewGroup": true, "parentGroupId": groupId, "iconUuid": parentIconUuid })
            }

            onNewPasswordEntryClicked: {
                // empty searchField
                searchField.text = ""
                // reset entry object and init with icon and parent groupId
                Global.env.mainPage.kdbEntry.clearData()
                // Convert group icon uuid to entry icon uuid
                Global.env.mainPage.kdbEntry.iconUuid = parentIconUuid.replace('f', '')
                Global.env.mainPage.kdbEntry.groupId = groupId
                pageStack.push(Global.env.mainPage.editEntryDetailsDialogComponent,
                               { "createNewEntry": true })
            }

            onSearchClicked: {
                // empty searchField
                searchField.text = ""
                // toggle search bar
                if (groupsAndEntriesPage.state === "SEARCH_BAR_HIDDEN") {
                    // show search bar
                    groupsAndEntriesPage.state = "SEARCH_BAR_SHOWN"
                    // save to settings
                    ownKeepassSettings.showSearchBar = true
                } else if (groupsAndEntriesPage.state === "SEARCH_BAR_SHOWN" ||
                           groupsAndEntriesPage.state === "SEARCHING") {
                    // steal focus from search bar so that is not active next time when the user
                    // selects "Show search" from pulley menu, otherwise its behaviour is weird
                    listView.focus = true
                    // hide search bar a bit delayed to let the pulley menu snap back and avoid motor saw sound
                    searchBarHiddenTimer.restart()
                    // save to settings
                    ownKeepassSettings.showSearchBar = false
                }
            }
        }

        ApplicationMenu {
            helpContent: "GroupsAndEntriesPage"
        }

        VerticalScrollDecorator {}

        delegate: Global.env.mainPage.kdbListItemComponent
    }

    KdbListModel {
        id: kdbListModel
        onGroupsAndEntriesLoaded: {
            Global.env.mainPage.errorHandler(result, errorMsg)
            // automatically focus search bar on master group page but not on sub-group pages
            if (groupId === 0 && ownKeepassSettings.showSearchBar && ownKeepassSettings.focusSearchBarOnStartup && !isEmpty) {
                    searchField.focus = true
            }
            // Close search bar if the list view is empty
            if (isEmpty) {
                groupsAndEntriesPage.state = "SEARCH_BAR_HIDDEN"
            }
        }
// TODO cleanup masterGroupsLoaded, it is not needed anymore...
        onMasterGroupsLoaded: {
            Global.env.mainPage.errorHandler(result, errorMsg)
        }
        onSearchEntriesCompleted: Global.env.mainPage.errorHandler(result, errorMsg)
        onLastItemDeleted: {
            // If the last entry or group is deleted from the list view make the placeholder appear again
            // In searching mode it needs to be checked if the search bar is actually not used (empty)
            if (groupsAndEntriesPage.state !== "SEARCHING" ||
                    searchField.text.length === 0) {
                groupsAndEntriesPage.state = "SEARCH_BAR_HIDDEN"
            }
        }
    }

    Timer {
        id: searchBarHiddenTimer
        interval: 500
        onTriggered: groupsAndEntriesPage.state = "SEARCH_BAR_HIDDEN"
    }

    state: "LOADING"

    states: [
        State {
            name: "LOADING"
            PropertyChanges { target: databaseMenu; enableDatabaseSettingsMenuItem: false
                enableNewPasswordGroupsMenuItem: false
                enableNewPasswordEntryMenuItem: false
                enableSearchMenuItem: false; isTextHideSearch: false }
            PropertyChanges { target: viewPlaceholder; enabled: false }
            PropertyChanges { target: searchNoEntriesFoundPlaceholder; enabled: false }
            PropertyChanges { target: busyIndicator; running: true }
            PropertyChanges { target: pageHeader; title: qsTr("Loading") }
            PropertyChanges { target: searchField; enabled: false }
            // Don't set cover state here, it will overwrite cover state from Query password dialog

//            PropertyChanges { target: rectState; color: "white" }
        },
        State {
            name: "SEARCH_BAR_HIDDEN"
            PropertyChanges { target: databaseMenu; enableDatabaseSettingsMenuItem: true
                enableNewPasswordGroupsMenuItem: true
                enableNewPasswordEntryMenuItem: true
                enableSearchMenuItem: !kdbListModel.isEmpty; isTextHideSearch: false }
            PropertyChanges { target: viewPlaceholder; enabled: kdbListModel.isEmpty }
            PropertyChanges { target: searchNoEntriesFoundPlaceholder; enabled: false }
            PropertyChanges { target: busyIndicator; running: false }
            PropertyChanges { target: pageHeader
                title: groupId === "0" ? qsTr("Password groups and entries") :
                                       groupsAndEntriesPage.pageTitle }
            PropertyChanges { target: searchField; enabled: false }
            PropertyChanges { target: applicationWindow.cover
                title: groupId === "0" ? qsTr("Password groups and entries") :
                                       groupsAndEntriesPage.pageTitle
                state: "GROUPS_VIEW" }

//            PropertyChanges { target: rectState; color: "red" }
        },
        State {
            name: "SEARCH_BAR_SHOWN"
            PropertyChanges { target: databaseMenu; enableDatabaseSettingsMenuItem: true
                enableNewPasswordGroupsMenuItem: true
                enableNewPasswordEntryMenuItem: true
                enableSearchMenuItem: !kdbListModel.isEmpty; isTextHideSearch: true }
            PropertyChanges { target: viewPlaceholder; enabled: kdbListModel.isEmpty }
            PropertyChanges { target: searchNoEntriesFoundPlaceholder; enabled: false }
            PropertyChanges { target: busyIndicator; running: false }
            PropertyChanges { target: pageHeader
                title: groupId === "0" ? qsTr("Password groups and entries") :
                                       groupsAndEntriesPage.pageTitle }
            PropertyChanges { target: searchField
                enabled: !kdbListModel.isEmpty }
            PropertyChanges { target: applicationWindow.cover
                title: groupId === "0" ? qsTr("Password groups and entries") :
                                       groupsAndEntriesPage.pageTitle
                state: "GROUPS_VIEW" }

//            PropertyChanges { target: rectState; color: "yellow" }
        },
        State {
            name: "SEARCHING"
            PropertyChanges { target: databaseMenu; enableDatabaseSettingsMenuItem: true
                enableNewPasswordGroupsMenuItem: true
                enableNewPasswordEntryMenuItem: true
                enableSearchMenuItem: true/*searchField.text.length === 0*/; isTextHideSearch: true }
            PropertyChanges { target: viewPlaceholder; enabled: false }
            PropertyChanges { target: searchNoEntriesFoundPlaceholder; enabled: kdbListModel.isEmpty }
            PropertyChanges { target: pageHeader
                title: groupId === "0" ? qsTr("Search in all groups") :
                                       qsTr("Search in") + " " + groupsAndEntriesPage.pageTitle }
            PropertyChanges { target: searchField; enabled: true }
            PropertyChanges { target: applicationWindow.cover
                title: groupId === "0" ? qsTr("Search in all groups") :
                                       qsTr("Search in") + " " + groupsAndEntriesPage.pageTitle
                state: "SEARCH_VIEW" }

//            PropertyChanges { target: rectState; color: "green" }
        }
    ]

    onStatusChanged: {
        if (__closeOnError && status === PageStatus.Active) {
            pageStack.pop(pageStack.previousPage(groupsAndEntriesPage))
        } else if (status === PageStatus.Active) {

            // check if page state needs to change because search bar state was changed on a sub-page
            if (ownKeepassSettings.showSearchBar && state === "SEARCH_BAR_HIDDEN") {
                state = "SEARCH_BAR_SHOWN"
            } else if (!ownKeepassSettings.showSearchBar && state !== "SEARCH_BAR_HIDDEN") {
                // steal focus from search bar
                listView.focus = true
                state = "SEARCH_BAR_HIDDEN"
            } else {
                // restore group title and state in cover page
                switch (state) {
                case "SEARCH_BAR_HIDDEN":
                    applicationWindow.cover.title = groupId === "0" ? qsTr("Password groups and entries") :
                                                                    groupsAndEntriesPage.pageTitle
                    applicationWindow.cover.state = "GROUPS_VIEW"
                    break
                case "SEARCH_BAR_SHOWN":
                    applicationWindow.cover.title = groupId === "0" ? qsTr("Password groups and entries") :
                                                                    groupsAndEntriesPage.pageTitle
                    applicationWindow.cover.state = "GROUPS_VIEW"
                    break
                case "SEARCHING":
                    applicationWindow.cover.title = groupId === "0" ? qsTr("Search in all groups") :
                                                                    qsTr("Search in") + " " + groupsAndEntriesPage.pageTitle
                    applicationWindow.cover.state = "SEARCH_VIEW"
                    break
                default:
                    applicationWindow.cover.title = pageTitle
                    applicationWindow.cover.state = "GROUPS_VIEW"
                    break
                }
            }
            // set ID of currently viewed group
            Global.activeGroupId = groupId
            // set menu label, it will have changed after initialization of this page in QueryPasswordDialog
            databaseMenu.menuLabelText = Global.activeDatabase
        }
    }

    Component.onCompleted: {
        if (initOnPageConstruction) {
            init()
        }
    }
}
