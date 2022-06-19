/***************************************************************************
**
** Copyright (C) 2015 Marko Koschak (marko.koschak@tisno.de)
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
import "../common"
import "../scripts/Global.js" as Global

Page {
    id: lockPage

    property string firstChar: ""
    property string secondChar: ""
    property string thirdChar: ""
    property Page mainPage
    property string recoverCoverState: "NO_DATABASE_OPENED"

    // internal
    property int __counter: ownKeepassSettings.fastUnlockRetryCount + 1

    backNavigation: false
    allowedOrientations: applicationWindow.orientationSetting

    SilicaFlickable {
        id: lockView
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: col.height

        // Show a scollbar when the view is flicked, place this over all other content
        VerticalScrollDecorator {}

        PullDownMenu {
            MenuItem {
                text: qsTr("Close Database")
                onClicked: {
                    pageStack.pop(mainPage)
                }
            }

            SilicaMenuLabel {
                text: Global.activeDatabase
                elide: Text.ElideMiddle
            }
        }

        ApplicationMenu {
            disableSettingsItem: true
        }

        Column {
            id: col
            width: parent.width
            spacing: -23

            PageHeaderExtended {
                title: "KeePassSF"
                subTitle: qsTr("Password Safe")
                subTitleOpacity: 0.5
                subTitleBottomMargin: lockPage.orientation & Orientation.PortraitMask ? Theme.paddingSmall : 0
            }

            // Add padding in landscape mode on tablet
            Item {
                enabled: lockPage.orientation !== Orientation.Portrait
                visible: enabled
                height: Screen.sizeCategory >= Screen.Large ?
                            // size on tablet
                            Screen.width / 7 :
                            // size on phone
                            0
                width: parent.width
            }

            Image {
                enabled: lockPage.orientation & Orientation.PortraitMask
                visible: enabled
                source: "../../wallicons/wall-key.png"
                anchors.horizontalCenter: parent.horizontalCenter
                width: height
                height: implicitHeight * Screen.height / 1920
            }

            Item {
                width: parent.width
                height: lockPage.orientation & Orientation.PortraitMask ?
                            fastPasswordFieldsColumn.height :
                            (fastPasswordFieldsColumn.height + Theme.paddingLarge)

                Image {
                    id: lockImageLandscape
                    enabled: lockPage.orientation !== Orientation.Portrait
                    visible: enabled
                    width: lockPage.orientation & Orientation.PortraitMask ? 0 : height
                    height: implicitHeight * Screen.height / 1920
                    source: "../../wallicons/wall-key.png"
                    anchors.left: parent.left
                    anchors.leftMargin: lockPage.orientation & Orientation.PortraitMask ? 0 : Theme.horizontalPageMargin
                    anchors.bottom: parent.bottom
                }

                Column {
                    id: fastPasswordFieldsColumn
                    anchors.right: parent.right
                    anchors.rightMargin: Theme.horizontalPageMargin
                    anchors.left: lockImageLandscape.right
                    anchors.leftMargin: Theme.paddingLarge
                    anchors.bottom: parent.bottom

                    Label {
                        width: parent.width
                        anchors.horizontalCenter: parent.horizontalCenter
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: Theme.fontSizeSmall
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        text: qsTr("Unlock your Password Safe with the first 3 characters of your master password:") + "\n"
                    }

                    Item {
                        width: parent.width
                        height: firstFast.height

                        TextField {
                            id: firstFast
                            width: Screen.width / 7
                            anchors.top: parent.top
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.horizontalCenterOffset: -(parent.width / 6)
                            inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
                            echoMode: TextInput.Password
                            placeholderText: ""
                            text: ""
                            font.family: 'monospace'
                            maximumLength: 1
                            focus: true
                            EnterKey.highlighted: false
                            EnterKey.iconSource: "image://theme/icon-m-enter-close"
                            EnterKey.onClicked: parent.focus = true
                            onTextChanged: {
                                if (text.length !== 0) {
                                    secondFast.focus = true
                                }
                            }
                            onClicked: {
                                text = ""
                                secondFast.text = ""
                                thirdFast.text = ""
                            }
                            focusOutBehavior: -1
                        }

                        TextField {
                            id: secondFast
                            width: Screen.width / 7
                            anchors.top: parent.top
                            anchors.horizontalCenter: parent.horizontalCenter
                            inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
                            echoMode: TextInput.Password
                            placeholderText: ""
                            text: ""
                            font.family: 'monospace'
                            maximumLength: 1
                            EnterKey.highlighted: false
                            EnterKey.iconSource: "image://theme/icon-m-enter-close"
                            EnterKey.onClicked: parent.focus = true
                            onTextChanged: {
                                if (text.length !== 0) {
                                    thirdFast.focus = true
                                }
                            }
                            onClicked: {
                                text = ""
                                thirdFast.text = ""
                            }
                            focusOutBehavior: -1
                        }

                        TextField {
                            id: thirdFast
                            width: Screen.width / 7
                            anchors.top: parent.top
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.horizontalCenterOffset: parent.width / 6
                            inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
                            echoMode: TextInput.Password
                            placeholderText: ""
                            text: ""
                            font.family: 'monospace'
                            maximumLength: 1
                            EnterKey.highlighted: false
                            EnterKey.iconSource: "image://theme/icon-m-enter-close"
                            EnterKey.onClicked: parent.focus = true
                            onTextChanged: {
                                if (text.length !== 0) {
                                    parent.focus = true
                                }

                                if (firstFast.text.length !== 0 && secondFast.text.length !== 0 && thirdFast.text.length !== 0) {
                                    if (firstFast.text === firstChar && secondFast.text === secondChar && thirdFast.text === thirdChar) {
                                        // enable fast unlock again
                                        Global.enableDatabaseLock = true
                                        lockPage.backNavigation = true
                                        pageStack.pop()
                                        // restore state of cover page
                                        Global.env.coverPage.state = recoverCoverState
                                    } else {
                                        if (__counter === 1) {
                                            pageStack.pop(mainPage)
                                        } else {
                                            __counter--
                                            firstFast.text = ""
                                            secondFast.text = ""
                                            text = ""
                                            if (__counter > 1) {
                                                var message = qsTr("You have %1 tries left").arg(__counter)
                                            } else {
                                                message = qsTr("You have one try left")
                                            }
                                            applicationWindow.infoPopup.show(Global.warning, qsTr("Wrong unlock code"), message, 3)
                                        }
                                    }
                                }
                            }
                            onClicked: text = ""
                            focusOutBehavior: -1
                        }
                    }
                }
            }
        }
    }
}
