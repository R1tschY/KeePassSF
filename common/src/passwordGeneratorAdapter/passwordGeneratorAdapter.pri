#***************************************************************************
#**
#** Copyright (C) 2013 - 2016 Marko Koschak (marko.koschak@tisno.de)
#** All rights reserved.
#**
#** This file is part of KeePassSF.
#**
#** KeePassSF is free software: you can redistribute it and/or modify
#** it under the terms of the GNU General Public License as published by
#** the Free Software Foundation, either version 2 of the License, or
#** (at your option) any later version.
#**
#** KeePassSF is distributed in the hope that it will be useful,
#** but WITHOUT ANY WARRANTY; without even the implied warranty of
#** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#** GNU General Public License for more details.
#**
#** You should have received a copy of the GNU General Public License
#** along with KeePassSF. If not, see <http://www.gnu.org/licenses/>.
#**
#***************************************************************************

# for optimizing string construction
DEFINES *= QT_USE_QSTRINGBUILDER

INCLUDEPATH += $$PWD
DEPENDPATH  += $$PWD

SOURCES += \
    ../common/src/passwordGeneratorAdapter/PasswordGeneratorAdapter.cpp

HEADERS += \
    ../common/src/passwordGeneratorAdapter/PasswordGeneratorAdapter.h
