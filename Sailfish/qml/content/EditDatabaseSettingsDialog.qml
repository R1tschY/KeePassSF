/***************************************************************************
**
** Copyright (C) 2013 Marko Koschak (marko.koschak@tisno.de)
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

import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.keepasssf 1.0
import "../common"
import "../scripts/Global.js" as Global

Dialog {
    id: editDatabaseSettingsDialog

    // save cover state because database settings page can be opened from various
    // pages like list view or edit dialogs, which have different cover states
    property string saveCoverState: ""
    property string saveCoverTitle: ""
    property bool masterPasswordChanged: false
    property bool cryptAlgorithmChanged: false
    property bool keyTransfRoundsChanged: false
    property bool keyDerivationFunctionChanged: false

    function updateCoverState() {
        if (saveCoverState === "") // save initial state
            saveCoverState = applicationWindow.cover.state
        if (saveCoverTitle === "") // save initial state
            saveCoverTitle = applicationWindow.cover.title
        if (masterPasswordChanged || cryptAlgorithmChanged || keyTransfRoundsChanged) {
            applicationWindow.cover.state = "UNSAVED_CHANGES"
            applicationWindow.cover.title = "Database Settings"
        } else {
            applicationWindow.cover.state = saveCoverState
            applicationWindow.cover.title = saveCoverTitle
        }
    }

    // forbit page navigation if master password is not confirmed and key transformation rounds is zero
    canNavigateForward: !databaseMasterPassword.errorHighlight &&
                        databaseMasterPassword.text === confirmDatabaseMasterPassword.text &&
                        !databaseKeyTransfRounds.errorHighlight
    allowedOrientations: applicationWindow.orientationSetting

    SilicaFlickable {
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: col.height

        VerticalScrollDecorator {}

        PullDownMenu {
            SilicaMenuLabel {
                text: Global.activeDatabase
                elide: Text.ElideMiddle
            }
        }

        ApplicationMenu {
            helpContent: "DatabaseSettings"
            disableSettingsItem: true
        }

        Column {
            id: col
            width: parent.width
            spacing: Theme.paddingLarge

            DialogHeader {
                acceptText: qsTr("Save")
                cancelText: qsTr("Discard")
                title: qsTr("Database Settings")
            }

            SilicaLabel {
                text: qsTr("Change settings of your currently opened Keepass database here")
            }

            Column {
                width: parent.width
                spacing: Theme.paddingMedium

                SilicaLabel {
                    text: qsTr("Note: By changing the master password here, you will need to remember it next time when opening the Keepass database!")
                    font.pixelSize: Theme.fontSizeExtraSmall
                    color: Theme.secondaryColor
                }

                TextField {
                    id: databaseMasterPassword
                    width: parent.width
                    inputMethodHints: Qt.ImhNoPredictiveText
                    echoMode: TextInput.Password
                    label: qsTr("Master password")
                    text: ""
                    font.family: 'monospace'
                    placeholderText: qsTr("Change master password")
                    errorHighlight: text.length > 0 && text.length < 3
                    EnterKey.enabled: !errorHighlight
                    EnterKey.highlighted: text.length > 0
                    EnterKey.iconSource: "image://theme/icon-m-enter-next"
                    EnterKey.onClicked: {
                        confirmDatabaseMasterPassword.focus = true
                    }
                    onTextChanged: {
                        editDatabaseSettingsDialog.masterPasswordChanged =
                                databaseMasterPassword.text !== ""
                        editDatabaseSettingsDialog.updateCoverState()
                    }
                }
            }

            TextField {
                id: confirmDatabaseMasterPassword
                enabled: databaseMasterPassword.text !== ""
                opacity: databaseMasterPassword.text !== "" ? 1.0 : 0.0
                height: databaseMasterPassword.text !== "" ? implicitHeight : 0
                width: parent.width
                inputMethodHints: Qt.ImhNoPredictiveText
                echoMode: TextInput.Password
                errorHighlight: databaseMasterPassword.text !== text && text.length !== 0
                label: !errorHighlight ? qsTr("Master password confirmed") : qsTr("Confirm master password")
                text: ""
                font.family: 'monospace'
                placeholderText: qsTr("Confirm master password")
                EnterKey.enabled: text.length === 0 || (databaseMasterPassword.text.length >= 3 && !errorHighlight)
                EnterKey.highlighted: databaseMasterPassword.text.length > 0 && !errorHighlight
                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                EnterKey.onClicked: {
                    parent.focus = true
                }
                Behavior on opacity { NumberAnimation { duration: 200 } }
                Behavior on height { NumberAnimation { duration: 200; easing.type: Easing.OutQuad } }
            }

            ComboBox {
                id: databaseCryptAlgorithm
                enabled: false
                width: parent.width
                label: qsTr("Encryption currently in use:")
                currentIndex: ownKeepassDatabase.cryptAlgorithm
                menu: ContextMenu {
                    // Do not change order of menu items below - it needs to be consistent to Cipher::eCipherAlgos
                    MenuItem { text: "AES (256-bit)" }
                    MenuItem { text: "Twofish (256-bit)" }
                    MenuItem { text: "ChaCha20 (256-bit)" }
               }
                onCurrentIndexChanged: {
                    editDatabaseSettingsDialog.cryptAlgorithmChanged =
                            databaseCryptAlgorithm.currentIndex !== ownKeepassDatabase.cryptAlgorithm
                    editDatabaseSettingsDialog.updateCoverState()
                }
            }

            ComboBox {
                id: keyDerivationFunction
                enabled: false
                width: parent.width
                label: qsTr("Key derivation function in use:")
                currentIndex: ownKeepassDatabase.keyDerivationFunction
                menu: ContextMenu {
                    // Do not change order of menu items below - it needs to be consistent to Cipher::eKdf
                    MenuItem { text: "Argon2 (KDBX 4) - " + qsTr("recommended") }
                    MenuItem { text: "AES-KDF (KDBX 4)" }
                    MenuItem { text: "AES-KDF (KDBX 3.1)" }
                }
                onCurrentIndexChanged: {
                    editDatabaseSettingsDialog.keyDerivationFunctionChanged =
                            currentIndex !== ownKeepassDatabase.keyDerivationFunction
                    editDatabaseSettingsDialog.updateCoverState()
                }
            }

            Column {
                enabled: false
                width: parent.width
                spacing: 0

                TextField {
                    id: databaseKeyTransfRounds
                    width: parent.width
                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                    validator: RegExpValidator { regExp: /^[0-9]*$/ }
                    errorHighlight: Number(text) === 0
                    label: qsTr("Key transformation rounds")
                    placeholderText: label
                    text: ownKeepassDatabase.keyTransfRounds
                    EnterKey.enabled: !errorHighlight
                    EnterKey.iconSource: "image://theme/icon-m-enter-close"
                    EnterKey.onClicked: parent.focus = true
                    onTextChanged: {
                        editDatabaseSettingsDialog.keyTransfRoundsChanged =
                                Number(databaseKeyTransfRounds.text) !== ownKeepassDatabase.keyTransfRounds
                        editDatabaseSettingsDialog.updateCoverState()
                    }
                }

                SilicaLabel {
                    text: qsTr("Setting this value higher increases opening time of the Keepass database but makes it more robust against brute force attacks")
                    font.pixelSize: Theme.fontSizeExtraSmall
                    color: Theme.secondaryColor
                }
            }
        }
    } // SilicaFlickable

    // user wants to save new Settings
    onAccepted: {
        // first save locally database settings then trigger saving
        kdbListItemInternal.setDatabaseSettings(databaseMasterPassword.text,
                                                databaseCryptAlgorithm.currentIndex,
                                                keyDerivationFunction.currentIndex,
                                                Number(databaseKeyTransfRounds.text))
        kdbListItemInternal.saveDatabaseSettings()
    }
    // user has rejected changing database settings, check if there are unsaved details
    onRejected: {
        // no need for saving if input field for master password is invalid
        if (canNavigateForward) {
            // first save locally database settings then trigger check for unsaved changes
            kdbListItemInternal.setDatabaseSettings(databaseMasterPassword.text,
                                                    databaseCryptAlgorithm.currentIndex,
                                                    keyDerivationFunction.currentIndex,
                                                    Number(databaseKeyTransfRounds.text))
            kdbListItemInternal.checkForUnsavedDatabaseSettingsChanges()
        }
    }
}
