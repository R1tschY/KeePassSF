/***************************************************************************
**
** Copyright (C) 2013-2019 Marko Koschak (marko.koschak@tisno.de)
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

HelpPage {
    text: qsTr("This page is showing password groups and entries of your Keepass database. \
A password group is a container for password entries. \
A password entry finally stores the bits of information \
secretly in the database.<br><br>\
\
You can use password groups to organize your password entries. For \
example create groups for \"Online shops\", \"Email Accounts\", \"Social media \
pages\", etc.<br><br>\
\
A search bar can be enabled from pulley menu which is shown on top of the \
password group list. With it you can search for password entries throughout the \
whole Keepass database or in a specific password group. \
If you want that the search bar automatically gets focus \
when you open the Keepass database please open the setting page and check the \
corresponding switch.<br><br>")
}
