/***************************************************************************
**
** Copyright (C) 2014 - 2015 Marko Koschak (marko.koschak@tisno.de)
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

#ifndef OWNKEEPASSSETTINGS_H
#define OWNKEEPASSSETTINGS_H

#include <QObject>
#include <QAbstractListModel>
#include "setting.h"
#include "RecentDatabaseListModel.h"
#include "OwnKeepassHelper.h"

namespace settingsPublic {

const QString OWN_KEEPASS_VERSION(PROGRAMVERSION); // get version from yaml/spec file

class OwnKeepassSettings : public QObject
{
    Q_OBJECT

public:
    Q_PROPERTY(QString version READ version NOTIFY versionChanged)
    Q_PROPERTY(int defaultCryptAlgorithm READ defaultCryptAlgorithm WRITE setDefaultCryptAlgorithm NOTIFY defaultCryptAlgorithmChanged)
    Q_PROPERTY(int defaultKeyDerivationFunction READ defaultKeyDerivationFunction WRITE setDefaultKeyDerivationFunction NOTIFY defaultKeyDerivationFunctionChanged)
    Q_PROPERTY(int defaultKeyTransfRounds READ defaultKeyTransfRounds WRITE setDefaultKeyTransfRounds NOTIFY defaultKeyTransfRoundsChanged)
    Q_PROPERTY(int locktime READ locktime WRITE setLocktime NOTIFY locktimeChanged)
    Q_PROPERTY(bool sortAlphabeticallyInListView READ sortAlphabeticallyInListView WRITE setSortAlphabeticallyInListView NOTIFY sortAlphabeticallyInListViewChanged)
    Q_PROPERTY(bool showUserNamePasswordInListView READ showUserNamePasswordInListView WRITE setShowUserNamePasswordInListView NOTIFY showUserNamePasswordInListViewChanged)
    Q_PROPERTY(bool showSearchBar READ showSearchBar WRITE setShowSearchBar NOTIFY showSearchBarChanged)
    Q_PROPERTY(bool focusSearchBarOnStartup READ focusSearchBarOnStartup WRITE setFocusSearchBarOnStartup NOTIFY focusSearchBarOnStartupChanged)
    Q_PROPERTY(bool showUserNamePasswordOnCover READ showUserNamePasswordOnCover WRITE setShowUserNamePasswordOnCover NOTIFY showUserNamePasswordOnCoverChanged)
    Q_PROPERTY(bool lockDatabaseFromCover READ lockDatabaseFromCover WRITE setLockDatabaseFromCover NOTIFY lockDatabaseFromCoverChanged)
    Q_PROPERTY(bool copyNpasteFromCover READ copyNpasteFromCover WRITE setCopyNpasteFromCover NOTIFY copyNpasteFromCoverChanged)
    Q_PROPERTY(int pwGenLength READ pwGenLength WRITE setPwGenLength NOTIFY pwGenLengthChanged)
    Q_PROPERTY(bool pwGenLowerLetters READ pwGenLowerLetters WRITE setPwGenLowerLetters NOTIFY pwGenLowerLettersChanged)
    Q_PROPERTY(bool pwGenUpperLetters READ pwGenUpperLetters WRITE setPwGenUpperLetters NOTIFY pwGenUpperLettersChanged)
    Q_PROPERTY(bool pwGenNumbers READ pwGenNumbers WRITE setPwGenNumbers NOTIFY pwGenNumbersChanged)
    Q_PROPERTY(bool pwGenSpecialChars READ pwGenSpecialChars WRITE setPwGenSpecialChars NOTIFY pwGenSpecialCharsChanged)
    Q_PROPERTY(bool pwGenExcludeLookAlike READ pwGenExcludeLookAlike WRITE setPwGenExcludeLookAlike NOTIFY pwGenExcludeLookAlikeChanged)
    Q_PROPERTY(bool pwGenCharFromEveryGroup READ pwGenCharFromEveryGroup WRITE setPwGenCharFromEveryGroup NOTIFY pwGenCharFromEveryGroupChanged)
    Q_PROPERTY(int clearClipboard READ clearClipboard WRITE setClearClipboard NOTIFY clearClipboardChanged)
    Q_PROPERTY(int language READ language WRITE setLanguage NOTIFY languageChanged)
    Q_PROPERTY(bool fastUnlock READ fastUnlock WRITE setFastUnlock NOTIFY fastUnlockChanged)
    Q_PROPERTY(int fastUnlockRetryCount READ fastUnlockRetryCount WRITE setFastUnlockRetryCount NOTIFY fastUnlockRetryCountChanged)
    Q_PROPERTY(int uiOrientation READ uiOrientation WRITE setUiOrientation NOTIFY uiOrientationChanged)

    Q_INVOKABLE void addRecentDatabase(QString uiName,
                                       QString uiPath,
                                       int dbLocation,
                                       QString dbFilePath,
                                       bool useKeyFile,
                                       int keyFileLocation,
                                       QString keyFilePath);
    Q_INVOKABLE void removeRecentDatabase(QString uiName,
                                          int dbLocation,
                                          QString dbFilePath);
    Q_INVOKABLE void loadDatabaseDetails();

public:
    OwnKeepassSettings(const QString filePath, OwnKeepassHelper *helper, QObject *parent = 0);
    virtual ~OwnKeepassSettings();

    QAbstractListModel* recentDatabaseModel() const { return (QAbstractListModel*)m_recentDatabaseModel.data(); }
    QString version() const { return m_version; }
    int defaultCryptAlgorithm() const { return m_defaultCryptAlgorithm; }
    void setDefaultCryptAlgorithm(const int value);
    int defaultKeyDerivationFunction() const { return m_defaultKeyDerivationFunction; }
    void setDefaultKeyDerivationFunction(const int value);
    int defaultKeyTransfRounds() const { return m_defaultKeyTransfRounds; }
    void setDefaultKeyTransfRounds(const int value);
    int locktime() const { return m_locktime; }
    void setLocktime(const int value);
    bool sortAlphabeticallyInListView() const { return m_sortAlphabeticallyInListView; }
    void setSortAlphabeticallyInListView(const bool value);
    bool showUserNamePasswordInListView() const { return m_showUserNamePasswordInListView; }
    void setShowUserNamePasswordInListView(const bool value);
    bool showSearchBar() const { return m_showSearchBar; }
    void setShowSearchBar(const bool value);
    bool focusSearchBarOnStartup() const { return m_focusSearchBarOnStartup; }
    void setFocusSearchBarOnStartup(const bool value);
    bool showUserNamePasswordOnCover() const { return m_showUserNamePasswordOnCover; }
    void setShowUserNamePasswordOnCover(const bool value);
    bool lockDatabaseFromCover() const { return m_lockDatabaseFromCover; }
    void setLockDatabaseFromCover(const bool value);
    bool copyNpasteFromCover() const { return m_copyNpasteFromCover; }
    void setCopyNpasteFromCover(const bool value);
    int pwGenLength() const { return m_pwGenLength; }
    void setPwGenLength(const int value);
    bool pwGenLowerLetters() const { return m_pwGenLowerLetters; }
    void setPwGenLowerLetters(const bool value);
    bool pwGenUpperLetters() const { return m_pwGenUpperLetters; }
    void setPwGenUpperLetters(const bool value);
    bool pwGenNumbers() const { return m_pwGenNumbers; }
    void setPwGenNumbers(const bool value);
    bool pwGenSpecialChars() const { return m_pwGenSpecialChars; }
    void setPwGenSpecialChars(const bool value);
    bool pwGenExcludeLookAlike() const { return m_pwGenExcludeLookAlike; }
    void setPwGenExcludeLookAlike(const bool value);
    bool pwGenCharFromEveryGroup() const { return m_pwGenCharFromEveryGroup; }
    void setPwGenCharFromEveryGroup(const bool value);
    int clearClipboard() const { return m_clearClipboard; }
    void setClearClipboard(const int value);
    int language() const { return m_language; }
    void setLanguage(const int value);
    bool fastUnlock() const { return m_fastUnlock; }
    void setFastUnlock(const bool value);
    int fastUnlockRetryCount() const { return m_fastUnlockRetryCount; }
    void setFastUnlockRetryCount(const int value);
    int uiOrientation() const { return m_uiOrientation; }
    void setUiOrientation(const int value);

    void checkSettingsVersion();

signals:
    // Signal to QML
    void showChangeLogBanner();
    void databaseDetailsLoaded(bool databaseExists,
                               int dbLocation,
                               QString dbFilePath,
                               bool useKeyFile,
                               int keyFileLocation,
                               QString keyFilePath);
    void recentDatabaseRemoved(int result, QString name);

    // Signals for property
    void recentDatabaseModelChanged();
    void versionChanged();
    void defaultCryptAlgorithmChanged();
    void defaultKeyDerivationFunctionChanged();
    void defaultKeyTransfRoundsChanged();
    void locktimeChanged();
    void sortAlphabeticallyInListViewChanged();
    void showUserNamePasswordInListViewChanged();
    void showSearchBarChanged();
    void focusSearchBarOnStartupChanged();
    void showUserNamePasswordOnCoverChanged();
    void lockDatabaseFromCoverChanged();
    void copyNpasteFromCoverChanged();
    void pwGenLengthChanged();
    void pwGenLowerLettersChanged();
    void pwGenUpperLettersChanged();
    void pwGenNumbersChanged();
    void pwGenSpecialCharsChanged();
    void pwGenExcludeLookAlikeChanged();
    void pwGenCharFromEveryGroupChanged();
    void clearClipboardChanged();
    void languageChanged();
    void fastUnlockChanged();
    void fastUnlockRetryCountChanged();
    void uiOrientationChanged();

private:
    void loadSettings();

private:
    QScopedPointer<settingsPrivate::RecentDatabaseListModel> m_recentDatabaseModel;
    OwnKeepassHelper *m_helper; // owned by parent

    // Settings version
    // This is used to check if settings from some older ownKeepass version are available
    // If yes they might need to be merged into new version
    QString m_previousVersion; // this is to internally detect if the settings.ini file has an older version than the application
    QString m_version;
    // Default encryption: AES = 0, Twofish = 1, ChaCha20 = 2
    int m_defaultCryptAlgorithm;
    // Default key derivation function: Argon2 = 0, AES-KDF KDBX4 = 1, AES-KDF KDBX3.1 = 2
    int m_defaultKeyDerivationFunction;
    int m_defaultKeyTransfRounds;
    int m_locktime;  // min = 0, max = 10, default = 3
    bool m_sortAlphabeticallyInListView;
    bool m_showUserNamePasswordInListView;
    bool m_showSearchBar;
    bool m_focusSearchBarOnStartup;
    bool m_showUserNamePasswordOnCover;
    bool m_lockDatabaseFromCover;
    bool m_copyNpasteFromCover;

    QList<QVariantMap> m_recentDatabaseList;
    int m_recentDatabaseListLength;

    // settings for password generator
    int m_pwGenLength;
    bool m_pwGenLowerLetters;
    bool m_pwGenUpperLetters;
    bool m_pwGenNumbers;
    bool m_pwGenSpecialChars;
    bool m_pwGenExcludeLookAlike;
    bool m_pwGenCharFromEveryGroup;

    int m_clearClipboard;
    int m_language;
    bool m_fastUnlock;
    int m_fastUnlockRetryCount;
    int m_uiOrientation;

    Settings* m_settings;
};

} // namespace
#endif // OWNKEEPASSSETTINGS_H
