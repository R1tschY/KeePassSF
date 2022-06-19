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

#include <QDebug>
#include "ownKeepassGlobal.h"
#include "KdbGroup.h"
#include "private/DatabaseClient.h"

using namespace kpxPublic;
using namespace kpxPrivate;
using namespace ownKeepassPublic;

KdbGroup::KdbGroup(QObject *parent)
    : QObject(parent),
      m_groupId(""),
      m_new_group_triggered(false)
{
    // connect signals to backend
    bool ret = connect(this,
                       SIGNAL(loadGroupFromKdbDatabase(QString)),
                       DatabaseClient::getInstance()->getInterface(),
                       SLOT(slot_loadGroup(QString)));
    Q_ASSERT(ret);
    ret = connect(DatabaseClient::getInstance()->getInterface(),
                  SIGNAL(groupLoaded(int,QString,QString,QString,QString,QString)),
                  this,
                  SLOT(slot_groupDataLoaded(int,QString,QString,QString,QString,QString)));
    Q_ASSERT(ret);
    ret = connect(this,
                  SIGNAL(saveGroupToKdbDatabase(QString,QString,QString,QString)),
                  DatabaseClient::getInstance()->getInterface(),
                  SLOT(slot_saveGroup(QString,QString,QString,QString)));
    Q_ASSERT(ret);
    ret = connect(DatabaseClient::getInstance()->getInterface(),
                  SIGNAL(groupSaved(int,QString,QString)),
                  this,
                  SLOT(slot_groupDataSaved(int,QString,QString)));
    Q_ASSERT(ret);
    ret = connect(this,
                  SIGNAL(createNewGroupInKdbDatabase(QString,QString,QString,QString)),
                  DatabaseClient::getInstance()->getInterface(),
                  SLOT(slot_createNewGroup(QString,QString,QString,QString)));
    Q_ASSERT(ret);
    ret = connect(DatabaseClient::getInstance()->getInterface(),
                  SIGNAL(newGroupCreated(int,QString,QString)),
                  this,
                  SLOT(slot_newGroupCreated(int,QString,QString)));
    Q_ASSERT(ret);
    ret = connect(this,
                  SIGNAL(deleteGroupFromKdbDatabase(QString)),
                  DatabaseClient::getInstance()->getInterface(),
                  SLOT(slot_deleteGroup(QString)));
    Q_ASSERT(ret);
    ret = connect(DatabaseClient::getInstance()->getInterface(),
                  SIGNAL(groupDeleted(int,QString,QString)),
                  this,
                  SLOT(slot_groupDeleted(int,QString,QString)));
    Q_ASSERT(ret);
}

void KdbGroup::loadGroupData()
{
    Q_ASSERT(m_groupId != "");
    // trigger loading from database client
    emit loadGroupFromKdbDatabase(m_groupId);
}

void KdbGroup::saveGroupData(QString title, QString notes, QString iconUuid)
{
    Q_ASSERT(m_groupId != "");
    // trigger loading from database client
    emit saveGroupToKdbDatabase(m_groupId, title, notes, iconUuid);
}

void KdbGroup::createNewGroup(QString title, QString notes, QString parentGroupId, QString iconUuid)
{
    Q_ASSERT(parentGroupId != "");
    // trigger creation of new entry in database client
    m_new_group_triggered = true;
    emit createNewGroupInKdbDatabase(title, notes, parentGroupId, iconUuid);
}


void KdbGroup::deleteGroup()
{
    Q_ASSERT(m_groupId != "");
    // trigger deletion of entry in database client
    emit deleteGroupFromKdbDatabase(m_groupId);
}

void KdbGroup::moveGroup(QString newParentGroupId)
{
    Q_ASSERT(m_groupId != "");
    Q_ASSERT(newParentGroupId != "");
    // trigger moving of entry in database client
    emit moveGroupInKdbDatabase(m_groupId, newParentGroupId);
}

void KdbGroup::slot_groupDataLoaded(int result, QString errorMsg, QString groupId, QString title, QString notes, QString iconUuid)
{
    // forward signal to QML only if the signal is for us
    if (groupId.compare(m_groupId) == 0) {
        emit groupDataLoaded(result, errorMsg, title, notes, iconUuid);
    }
}

void KdbGroup::slot_groupDataSaved(int result, QString errorMsg, QString groupId)
{
    // forward signal to QML only if the signal is for us
    if (groupId.compare(m_groupId) == 0) {
        emit groupDataSaved(result, errorMsg);
    }
}

void KdbGroup::slot_newGroupCreated(int result, QString errorMsg, QString groupId)
{
    if (m_new_group_triggered) {
        if (result == DatabaseAccessResult::RE_OK) {
            m_groupId = groupId;
        }
        m_new_group_triggered = false;
        // forward signal to QML
        emit newGroupCreated(result, errorMsg);
    }
}

void KdbGroup::slot_groupDeleted(int result, QString errorMsg, QString groupId)
{
    // forward signal to QML only if the signal is for us
    if (groupId.compare(m_groupId) == 0) {
        emit groupDeleted(result, errorMsg);
        m_groupId = "";
    }
}

void KdbGroup::slot_groupMoved(int result, QString errorMsg, QString groupId)
{
    // forward signal to QML only if the signal is for us
    if (groupId.compare(m_groupId) == 0) {
        emit groupMoved(result, errorMsg);
    }
}
