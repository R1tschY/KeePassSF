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
import "../scripts/Global.js" as Global

PushUpMenu {
    id: applicationMenu

    property bool disableNewEntryAttribute: true
    property bool disableSettingsItem: false
    property string helpContent: ""

    signal addAdditionalAttribute

    MenuItem {
        enabled: !disableNewEntryAttribute
        visible: enabled
        text: qsTr("Add Additional Attribute")
        onClicked: addAdditionalAttribute()
    }

    MenuItem {
        text: qsTr("About")
        onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
    }

    MenuItem {
        enabled: helpContent !== ""
        visible: enabled
        text: qsTr("Help")
        onClicked: pageStack.push(Qt.resolvedUrl("../help/Help" + helpContent + ".qml"))
    }

    MenuItem {
        enabled: !disableSettingsItem
        visible: enabled
        text: qsTr("Settings")
        onClicked: pageStack.push(Global.env.mainPage.editSettingsDialogComponent)
    }
}
