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
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with KeePassSF. If not, see <http://www.gnu.org/licenses/>.
**
***************************************************************************/

#ifndef OWNKEEPASSHELPER_H
#define OWNKEEPASSHELPER_H

#include <QObject>
#include <QDir>

// A convenience class with helper functions used in QML context
class OwnKeepassHelper : public QObject
{
    Q_OBJECT

public:
    Q_INVOKABLE bool fileExists(const QString filePath) const;
    Q_INVOKABLE bool createFilePathIfNotExist(const QString filePath) const;
    Q_INVOKABLE bool sdCardExists();
    Q_INVOKABLE QString getHomePath();
    Q_INVOKABLE QString getSdCardPath();
    Q_INVOKABLE QString getAndroidStoragePath();
    Q_INVOKABLE QString getLocationRootPath(const int value);

public:
    OwnKeepassHelper(QObject *parent = 0);
    virtual ~OwnKeepassHelper() {}

signals:
    // Signal to QML
    void showErrorBanner();

private:
    QStringList mountPoints() const;
    QStringList sdCardPartitions();
};

#endif // OWNKEEPASSHELPER_H
