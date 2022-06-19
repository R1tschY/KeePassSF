/***************************************************************************
**
** Copyright (C) 2012 Marko Koschak (marko.koschak@tisno.de)
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
** along with KeePassSF.  If not, see <http://www.gnu.org/licenses/>.
**
***************************************************************************/

#ifndef KDBGROUP_H
#define KDBGROUP_H

#include <QObject>
#include "private/AbstractDatabaseInterface.h"

namespace kpxPublic {

class KdbGroup : public QObject
{
    Q_OBJECT

public:
    Q_PROPERTY(QString groupId READ getGroupId WRITE setGroupId STORED true SCRIPTABLE true)

public:
    Q_INVOKABLE void loadGroupData();
    Q_INVOKABLE void createNewGroup(QString title, QString notes, QString parentGroupId, QString iconUuid);
    Q_INVOKABLE void saveGroupData(QString title, QString notes, QString iconUuid);
    Q_INVOKABLE void deleteGroup();
    Q_INVOKABLE void moveGroup(QString newParentGroupId);

signals:
    // signals to QML
    void groupDataLoaded(int result,
                         QString errorMsg,
                         QString title,
                         QString notes,
                         QString iconUuid);
    void groupDataSaved(int result,
                        QString errorMsg);
    void newGroupCreated(int result,
                         QString errorMsg);
    void groupDeleted(int result,
                      QString errorMsg);
    void groupMoved(int result,
                    QString errorMsg);

    // signals to database client
    void loadGroupFromKdbDatabase(QString groupId);
    void saveGroupToKdbDatabase(QString groupId,
                                QString title,
                                QString notes,
                                QString iconUuid);
    void createNewGroupInKdbDatabase(QString title,
                                     QString notes,
                                     QString parentGroupId,
                                     QString iconUuid);
    void deleteGroupFromKdbDatabase(QString groupId);
    void moveGroupInKdbDatabase(QString groupId,
                                QString newGroupId);

public slots:
    // signals from database client
    void slot_groupDataLoaded(int result,
                              QString errorMsg,
                              QString groupId,
                              QString title,
                              QString notes,
                              QString iconUuid);
    void slot_groupDataSaved(int result,
                             QString errorMsg,
                             QString groupId);
    void slot_newGroupCreated(int result,
                              QString errorMsg,
                              QString groupId);
    void slot_groupDeleted(int result,
                           QString errorMsg,
                           QString groupId);
    void slot_groupMoved(int result,
                         QString errorMsg,
                         QString groupId);

public:
    KdbGroup(QObject *parent = 0);
    virtual ~KdbGroup() {}

    QString getGroupId() const { return m_groupId; }
    void setGroupId(const QString value) { m_groupId = value; }

private:
    QString m_groupId;
    bool m_new_group_triggered;
};

}
#endif // KDBGROUP_H
