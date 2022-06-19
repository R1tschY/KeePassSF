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

#ifndef OWNKEEPASSGLOBAL_H
#define OWNKEEPASSGLOBAL_H

#include <QObject>

namespace ownKeepassPublic {

static const int baseRole = Qt::UserRole + 1;

class DatabaseAccessResult : public QObject
{
    Q_OBJECT

public:
    Q_ENUMS(eDatabaseAccessResult)

    enum eDatabaseAccessResult {
        RE_OK = 0,                                     // no error
        // to be reviewed error codes
        RE_DB_READ_ONLY,                               // database file is read-only
        RE_DB_SAVE_ERROR,                              // error saving data into database
        RE_DB_ENTRY_NOT_FOUND,                         // Entry could not be found in database (uuid or pointer is corrupt?)
        RE_DB_GROUP_NOT_FOUND,                         // Group could not be found in database (Uuid or pointer is corrupt?)
        RE_DB_NOT_OPENED,                              // database is not opened
        RE_DB_CLOSE_FAILED,                            // database closing failed
        RE_DB_FILE_ERROR,                              // file path error for new database
        RE_DB_SETKEY_ERROR,                            // error setting key (consisting of password and/or keyfile)
        RE_DB_CREATE_BACKUPGROUP_ERROR,                // error creating backup group
        RE_CRYPTO_INIT_ERROR,                          // cryptographic algorithms could not be initialized successfully, abort opening of any Keepass database for safety
        RE_MISSING_DB_HEADERS,                         // missing database headers
        RE_HEAD_HASH_MISMATCH,                         // Database head doesn't match hash
        RE_DBFILE_OPEN_ERROR,                          // Cannot open database file, more detailed error message available as attached string in signal
        RE_ERR_REMOVE_RECENT_DATABASE,                 // Could not remove database from recent database list in the settings
        RE_ERR_DELETE_DATABASE,                        // Could not delete the database file from the file system
        RE_UNKNOWN_ERROR,                              // An error occured which is not specified further

        // Keepass 1 specific
        RE_ERR_QSTRING_TO_INT,                         // conversion of QString to int failed

        // Used in KeepassXC
        RE_DB_FILE_NOT_EXISTS,                         // File %1 does not exist
        RE_DB_OPEN_FILE_ERROR,                         // Unable to open file %1
        RE_OLD_KEEPASS_1_DB,                           // When trying to open a Keepass 1 as a Keepass2 database this error occurs
        RE_NOT_SUPPORTED_DB_VERSION,                   // Unsupported KeePass database version
        RE_NOT_A_KEEPASS_DB,                           // Not a KeePass database
        RE_WRONG_PASSWORD_OR_DB_IS_CORRUPT,            // Wrong password or database file is corrupt
        RE_WRONG_PASSWORD_OR_KEYFILE_OR_DB_IS_CORRUPT, // Wrong password or wrong keyfile or either keyfile or database file is corrupt
        RE_KEYFILE_OPEN_ERROR,                         // Cannot open key file, more detailed error message available as attached string in signal
        RE_DB_LOAD_ERROR,                              // error loading data from database

        RE_LAST
    };
};

class DatabaseItemType : public QObject
{
    Q_OBJECT

public:
    Q_ENUMS(eDatabaseItemType)

    enum eDatabaseItemType {
        UNKNOWN = 0,
        GROUP,
        ENTRY,
    };
};

class Language : public QObject
{
    Q_OBJECT

public:
    Q_ENUMS(eLanguage)

    // Never change below order of languages! They are used as index in application settings (ini file).
    enum eLanguage {
        SYSTEM_DEFAULT = 0,
        EN,    // English
        SV_SE, // Swedish
        FI_FI, // Finnish
        DE_DE, // German
        CS_CZ, // Czech
        CA,    // Catalan
        NL_BE, // Dutch Belgium
        NL_NL, // Dutch
        ES,    // Spanish
        FR_FR, // French
        IT,    // Italian
        RU,    // Russian
        DA,    // Danish
        PL_PL, // Polish
        ZH_CN, // Chinese
        UK_UA, // Ukrainian - not yet started
        NB_NO, // Norwegian Bogmål
        EL,    // Greek
        JA_JP, // Japanese
        HU_HU, // Hungarian
        GL,    // Galician
        SR_RS, // Serbian
        INVALID
    };
};

class KeepassDefault : public QObject
{
    Q_OBJECT

public:
    Q_ENUMS(eKeepassDefaultEntryKeys)

    // This is the default order of Keepass standard entry keys which is used for loading and saving password entries
    enum eKeepassDefaultEntryKeys {
        TITLE = 0,
        URL,
        USERNAME,
        PASSWORD,
        NOTES,
        ADDITIONAL_ATTRIBUTES
    };
};

class Cipher : public QObject
{
    Q_OBJECT

public:
    Q_ENUMS(eKeepassDefaultEntryKeys)

    // Used database encryption algorithms
    enum eCipherAlgos {
        CIPHER_AES_256 = 0,
        CIPHER_TWOFISH_256,
        CIPHER_CHACHA20_256,
        CIPHER_UNKNOWN
    };

    // Key transformation methods
    enum eKdf {
        KDF_ARGON2 = 0,
        KDF_AES_KDBX4,
        KDF_AES_KDBX3,
        KDF_UNKNOWN
    };
};

} // namespace ownKeepassPublic
#endif // OWNKEEPASSGLOBAL_H
