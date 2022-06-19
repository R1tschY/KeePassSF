############################################################################
#
# Copyright (C) 2013 - 2019 Marko Koschak (marko.koschak@tisno.de)
# All rights reserved.
#
# This file is part of KeePassSF.
#
# KeePassSF is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# KeePassSF is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with KeePassSF. If not, see <http://www.gnu.org/licenses/>.
#
############################################################################

# Sources of the keepass QML plugins
include(../common/src/keepassPlugin/keepass2_database/keepass2_database.pri)
include(../common/src/keepassPlugin/databaseInterface/databaseInterface.pri)
include(../common/src/fileBrowserPlugin/fileBrowserPlugin.pri)
include(../common/src/passwordGeneratorAdapter/passwordGeneratorAdapter.pri)

# Get release version from .spec file and paste it further to c++ through a define
isEmpty(VERSION) {
    error(Version string is empty)
}
DEFINES += PROGRAMVERSION=\\\"$$VERSION\\\"

# The name of the app
# NOTICE: name defined in TARGET has a corresponding QML filename.
#         If name defined in TARGET is changed, following needs to be
#         done to match new name:
#         - corresponding QML filename must be changed
#         - desktop icon filename must be changed
#         - desktop filename must be changed
#         - icon definition filename in desktop file must be changed
TARGET = harbour-keepasssf

# adding common QML files, QML imports, C++ libs and image files for the app
common_files.path   = /usr/share/$${TARGET}
common_files.files += \
    ../common/images/covericons \
    ../common/images/wallicons

# Copy *.so dependencies

contains(QT_ARCH, arm64) {
    LIB_DIR_NAME = /usr/lib64
} else {
    LIB_DIR_NAME = /usr/lib
}

dependencies.path   = /usr/share/$${TARGET}/lib
dependencies.files += \
    $$LIB_DIR_NAME/libgcrypt.so.20 \
    $$LIB_DIR_NAME/libargon2.so.0 \
    $$LIB_DIR_NAME/libgpg-error.so.0 \
    $$LIB_DIR_NAME/libsodium.so.23

# icons are put into resources
QMAKE_RESOURCE_FLAGS += -no-compress
RESOURCES = ../common/images/icons.qrc

INSTALLS += \
    common_files \
    dependencies

# adding standard installation paths for a sailfish OS app
CONFIG += sailfishapp

INCLUDEPATH += ../common/src/settings \
    ../common/src

# C++ sources
SOURCES += src/main.cpp \
    ../common/src/settings/setting.cpp \
    ../common/src/settings/RecentDatabaseListModel.cpp \
    ../common/src/settings/OwnKeepassSettings.cpp \
    ../common/src/OwnKeepassHelper.cpp

# C++ headers
HEADERS += \
    ../common/src/settings/setting.h \
    ../common/src/settings/RecentDatabaseListModel.h \
    ../common/src/settings/OwnKeepassSettings.h \
    ../common/src/OwnKeepassHelper.h \
    ../common/src/ownKeepassGlobal.h \
    ../common/src/SdCardHelper.h

OTHER_FILES += \
    ../common/images/icons.qrc \
    ../README.md \
    ../LICENSE \
    qml/common/ViewSearchPlaceholder.qml \
    qml/common/Tracer.qml \
    qml/common/SilicaLabel.qml \
    qml/common/SilicaCoverPlaceholder.qml \
    qml/common/QueryDialog.qml \
    qml/common/PageHeaderExtended.qml \
    qml/common/InfoPopup.qml \
    qml/content/ShowEntryDetailsPage.qml \
    qml/content/QueryPasswordDialog.qml \
    qml/content/KdbListItem.qml \
    qml/help/HelpPage.qml \
    qml/content/GroupsAndEntriesPage.qml \
    qml/content/ChangeLogPage.qml \
    qml/content/EditSettingsDialog.qml \
    qml/content/EditGroupDetailsDialog.qml \
    qml/content/EditEntryDetailsDialog.qml \
    qml/content/EditDatabaseSettingsDialog.qml \
    qml/content/DatabaseMenu.qml \
    qml/content/ApplicationMenu.qml \
    qml/content/AboutPage.qml \
    qml/cover/CoverPage.qml \
    qml/scripts/Global.js \
    harbour-keepasssf.desktop \
    rpm/harbour-keepasssf.spec \
    qml/Main.qml \
    qml/content/MainPage.qml \
    qml/help/HelpMainPage.qml \
    qml/help/HelpCreateNewDatabase.qml \
    qml/help/HelpOpenNewDatabase.qml \
    qml/help/HelpOpenRecentDatabase.qml \
    qml/help/HelpDatabaseSettings.qml \
    qml/content/PasswordGeneratorDialog.qml \
    qml/content/LicensePage.qml \
    qml/content/ChangeLogPage.qml \
    qml/content/LockPage.qml \
    qml/common/FileSystemDialog.qml \
    qml/content/MovePasswordEntryDialog.qml \
    qml/common/SilicaMenuLabel.qml \
    qml/components/MainPageMoreDetails.qml \
    qml/common/PasswordFieldCombo.qml


SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172 256x256

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

TRANSLATIONS += \
    translations/harbour-keepasssf-ca.ts \
    translations/harbour-keepasssf-zh_CN.ts \
    translations/harbour-keepasssf-cs_CZ.ts \
    translations/harbour-keepasssf-da.ts \
    translations/harbour-keepasssf-nl_BE.ts \
    translations/harbour-keepasssf-nl_NL.ts \
    translations/harbour-keepasssf-en.ts \
    translations/harbour-keepasssf-fi_FI.ts \
    translations/harbour-keepasssf-fr_FR.ts \
    translations/harbour-keepasssf-de_DE.ts \
    translations/harbour-keepasssf-it.ts \
    translations/harbour-keepasssf-nb_NO.ts \
    translations/harbour-keepasssf-pl_PL.ts \
    translations/harbour-keepasssf-ru.ts \
    translations/harbour-keepasssf-es.ts \
    translations/harbour-keepasssf-sv_SE.ts \
    translations/harbour-keepasssf-el.ts \
    translations/harbour-keepasssf-ja_JP.ts \
    translations/harbour-keepasssf-hu_HU.ts \
    translations/harbour-keepasssf-gl.ts \
    translations/harbour-keepasssf-sr_RS.ts

DISTFILES += \
    qml/content/EditItemIconDialog.qml \
    qml/common/EntryTextArea.qml \
    qml/components/PasswordCharSwitch.qml \
    qml/common/FileQueryListItem.qml \
    qml/help/HelpGroupsAndEntriesPage.qml
