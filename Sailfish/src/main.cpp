/***************************************************************************
**
** Copyright (C) 2013 - 2014 Marko Koschak (marko.koschak@tisno.de)
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

#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <QString>
#include <QDebug>
#include <QGuiApplication>
#include <QQuickView>
#include <QScopedPointer>
#include <QtQml>
#include <sailfishapp.h>

#include "KdbDatabase.h"
#include "KdbListModel.h"
#include "KdbEntry.h"
#include "KdbGroup.h"
#include "private/DatabaseClient.h"
#include "OwnKeepassHelper.h"
#include "OwnKeepassSettings.h"
#include "RecentDatabaseListModel.h"
#include "FileBrowserPlugin.h"
#include "ownKeepassGlobal.h"
#include "PasswordGeneratorAdapter.h"
#include "KeepassIcon.h"

int main(int argc, char *argv[])
{
    // SailfishApp::main() will display "qml/harbour-keepasssf.qml", if you need more
    // control over initialization, you can use:
    //
    //   - SailfishApp::application(int, char *[]) to get the QGuiApplication *
    //   - SailfishApp::createView() to get a new QQuickView * instance
    //   - SailfishApp::pathTo(QString) to get a QUrl to a resource file
    //
    // To display the view, call "show()" (will show fullscreen on device).

    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
    QScopedPointer<QQuickView> view(SailfishApp::createView());

    const QString settingsFilePath(
                QStandardPaths::writableLocation(QStandardPaths::AppConfigLocation)
                + "/settings.ini");

    Q_INIT_RESOURCE(icons);

    // @uri harbour.keepasssf
    const char* uri("harbour.keepasssf");
    // make the following classes available in QML
    qmlRegisterType<kpxPublic::KdbListModel>(uri, 1, 0, "KdbListModel");
    qmlRegisterType<kpxPublic::KdbEntry>(uri, 1, 0, "KdbEntry");
    qmlRegisterType<kpxPublic::KdbGroup>(uri, 1, 0, "KdbGroup");
    qmlRegisterType<kpxPublic::IconListModel>(uri, 1, 0, "IconListModel");
    qmlRegisterType<FileBrowserListModel>(uri, 1, 0, "FileBrowserListModel");
    qmlRegisterType<PasswordGeneratorAdapter>(uri, 1, 0, "PasswordGenerator");

    // provide only one instance of KdbDatabase to QML, only one database can be open at a time
    QScopedPointer<kpxPublic::KdbDatabase> database(new kpxPublic::KdbDatabase());
    view->rootContext()->setContextProperty("ownKeepassDatabase", database.data());

    // exporting some enums
    qmlRegisterType<ownKeepassPublic::Language>(uri, 1, 0, "Language");
    qmlRegisterType<ownKeepassPublic::DatabaseAccessResult>(uri, 1, 0, "DatabaseAccessResult");
    qmlRegisterType<ownKeepassPublic::DatabaseItemType>(uri, 1, 0, "DatabaseItemType");
    qmlRegisterType<ownKeepassPublic::KeepassDefault>(uri, 1, 0, "KeepassDefault");
    qmlRegisterType<ownKeepassPublic::Cipher>(uri, 1, 0, "Cipher");

    // Setup some class as context properties and make them accessible in QML
    QScopedPointer<OwnKeepassHelper> helper(new OwnKeepassHelper());
    view->rootContext()->setContextProperty("ownKeepassHelper", helper.data());
    QScopedPointer<settingsPublic::OwnKeepassSettings> okpSettings(new settingsPublic::OwnKeepassSettings(settingsFilePath, helper.data()));
    view->rootContext()->setContextProperty("ownKeepassSettings", okpSettings.data());
    view->rootContext()->setContextProperty("recentDatabaseModel", okpSettings->recentDatabaseModel());
    view->engine()->addImageProvider(QLatin1String("KeepassIcon"), new kpxPublic::KeepassIcon());
    view->engine()->addImageProvider(QLatin1String("IconBackground"), new kpxPublic::IconBackground());

    // Check if user has set language explicitly to be used in the app
    QString locale = QLocale::system().name();
    view->rootContext()->setContextProperty("DebugLocale",QVariant(locale));

    // When editing or adding new languages make sure to update all relevant data in:
    // EditSettingsDialog.qml, Global.js, ownKeepassGlobal.h and below
    QTranslator translator;
    if (ownKeepassPublic::Language::SYSTEM_DEFAULT != okpSettings->language()) {
        switch (okpSettings->language()) {
        // Catalan
        case ownKeepassPublic::Language::CA:
            translator.load("harbour-keepasssf-ca.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // Chinese
        case ownKeepassPublic::Language::ZH_CN:
            translator.load("harbour-keepasssf-zh_CN.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // Czech
        case ownKeepassPublic::Language::CS_CZ:
            translator.load("harbour-keepasssf-cs_CZ.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // Danish
        case ownKeepassPublic::Language::DA:
            translator.load("harbour-keepasssf-da.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // Dutch Belgium
        case ownKeepassPublic::Language::NL_BE:
            translator.load("harbour-keepasssf-nl_BE.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // Dutch
        case ownKeepassPublic::Language::NL_NL:
            translator.load("harbour-keepasssf-nl_NL.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // Finnish
        case ownKeepassPublic::Language::FI_FI:
            translator.load("harbour-keepasssf-fi_FI.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // French
        case ownKeepassPublic::Language::FR_FR:
            translator.load("harbour-keepasssf-fr_FR.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // German
        case ownKeepassPublic::Language::DE_DE:
            translator.load("harbour-keepasssf-de_DE.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // Italian
        case ownKeepassPublic::Language::IT:
            translator.load("harbour-keepasssf-it.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // Polish
        case ownKeepassPublic::Language::PL_PL:
            translator.load("harbour-keepasssf-pl_PL.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // Russian
        case ownKeepassPublic::Language::RU:
            translator.load("harbour-keepasssf-ru.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // Spanish
        case ownKeepassPublic::Language::ES:
            translator.load("harbour-keepasssf-es.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // Swedish
        case ownKeepassPublic::Language::SV_SE:
            translator.load("harbour-keepasssf-sv_SE.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // Ukrainian
        case ownKeepassPublic::Language::UK_UA:
            translator.load("harbour-keepasssf-uk_UA.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // Norwegian Bogmål
        case ownKeepassPublic::Language::NB_NO:
            translator.load("harbour-keepasssf-nb_NO.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // Greek
        case ownKeepassPublic::Language::EL:
            translator.load("harbour-keepasssf-el.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // Japanese
        case ownKeepassPublic::Language::JA_JP:
            translator.load("harbour-keepasssf-ja_JP.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // Hungarian
        case ownKeepassPublic::Language::HU_HU:
            translator.load("harbour-keepasssf-hu_HU.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // Galician
        case ownKeepassPublic::Language::GL:
            translator.load("harbour-keepasssf-gl.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // Serbian
        case ownKeepassPublic::Language::SR_RS:
            translator.load("harbour-keepasssf-sr_RS.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // English
        default:
            translator.load("harbour-keepasssf-en.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        }
        // install translator for specific language
        // otherwise the system language will be set by SailfishApp
        app->installTranslator(&translator);
    }

    // enable access to qml import libs
    view->engine()->addImportPath(SailfishApp::pathTo("lib/").toLocalFile());

    // Set main QML file and go ahead
    view->setSource(SailfishApp::pathTo("qml/Main.qml"));
    view->show();

    // Check settings version after QML is loaded because it might want to show an info popup in QML
    okpSettings->checkSettingsVersion();

    return app->exec();
}
