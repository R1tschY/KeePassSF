# ownKeepass

This is ownKeepass repository for OBS builds in Chum. This version is cleaned up and the build process slightly adjusted to make it possible to build at OBS.

ownKeepass looks for new developer(s) interested in working on it.

__Original README below:__

__I am sorry to say but I don't have the time to continue working on ownKeepass. That might change but currenlty I am too exhausted by private issues and duties.__

[Bug reports go here] - [Translations here]

## Status

Development towards 2.0.0
* Removed legacy code for Keepass 1 support
* New created databases have now Keepass 2 file format
* Default encryption algorithm, key derivation function (kdf) and key transformation rounds for a new Keepass 2 database can be adjusted in application settings

Release 1.2.6
* Added support for KDBX 4 database format by changing database code from KeepassX to [KeepassXC] (many thanks to [24mu13](https://github.com/24mu13))
* Added support for new database cipher algorithms and key derivation functions like Twofish, Chacha20 and Argon2 for Keepass 2 databases
* Show used database cipher, key derivation function and key transformation rounds for a Keepass 2 database in database settings dialog
* Added new translation for Belgisch-Nederlands
* Updated translations from transifex

## Roadmap

List of planned features for ownKeepass to happen somewhere the next time. Priority
in descending order.

*   Implement importing old Keepass 1 database into a new Keepass 2 database
*   Do some art work: new icons, wall paper, better support for light ambiances
*   Merge databases (local and remote copy) which have diverged e.g. when using Syncthing for syncing databases across devices
*   Integrate WebDav support for loading and saving Keepass database to a server (Has low prio since Syncthing works flawlessly here)

## Building

In order to succesfully build this application, you need the following steps:
- Clone this repository including the [KeepassXC] submodule (`git clone --recursive`)
- Make sure the _Sailfish OS Build Engine_ has the following packages. Currently these packages are only available from **3rd-party repositories**.
  - libargon2-devel 
  - libsodium-devel 
- Build the project using _Qt Creator_

### How to use a _3rd-party repository_ on Sailfish OS Build Engine

In order to use a 3rd-party repository, you need to add it to the _Build Engine_.
First ssh into Sailfish OS build engine:

    $ ssh -p 2222 -i ~/SailfishOS/vmshare/ssh/private_keys/engine/mersdk mersdk@localhost
    
Add the repository to all applicable Kits, e.g.:

    $ sb2 -t SailfishOS-3.1.0.12-armv7hl -m sdk-install -R zypper ar -f http://repo.merproject.org/obs/home:/yeoldegrove:/crypt/sailfish_latest_armv7hl crypt
    $ sb2 -t SailfishOS-3.1.0.12-armv7hl -m sdk-install -R zypper ar -f http://repo.merproject.org/obs/home:/nielnielsen/sailfish_latest_armv7hl sodium
    $ sb2 -t SailfishOS-3.1.0.12-armv7hl -m sdk-install -R zypper ref
    $ sb2 -t SailfishOS-3.1.0.12-i486 -m sdk-install -R zypper ar -f http://repo.merproject.org/obs/home:/yeoldegrove:/crypt/sailfish_latest_i486 crypt
    $ sb2 -t SailfishOS-3.1.0.12-i486 -m sdk-install -R zypper ar -f http://repo.merproject.org/obs/home:/nielnielsen/latest_i486 sodium
    $ sb2 -t SailfishOS-3.1.0.12-i486 -m sdk-install -R zypper ref

See also: https://gist.github.com/skvark/49a2f1904192b6db311a

Now with these repositories added the build engine can automatically install libargon2-devel and libsodium-devel as they are listed under PkgConfigBR in the harbour-ownkeepass.yaml config file.

Building ownKeepass in Qt Creator should proceed succesfully.

## What is this?

ownKeepass is a password safe application for the Jolla Smartphone with the purpose to
protect sensible data like passwords for web pages, credit card numbers,
PINs, TANs and other bits of information which should be kept secret. All that information
is saved in a database file which is encrypted and stored locally on your phone. To open
the database you need to know the master password of the database. ownKeepass can use Keepass
version 1 and 2 databases. That means you can use [Keepass] or [KeepassX] on your desktop
system to decrypt and open that database file, too.

## Why?

I started to work on this project beginning of 2012 when QML started to get usable from development point
of view for the Nokia N9. Writing a QML UI for the stable KeepassX 0.4.3 version was just born out of the
idea to take my favourite Password Safe application to new Qt platforms like the Nokia N9. Although
ownKeepass was quite usable for me on my Nokia N9 I never released it for the Nokia N9 due to lack of
time and motivation (Nokia's Qt strategy disruption) to make the application usable for a wider audience.
Mid of 2013 I decided to continue development on the new Sailfish OS platform from the finnish Smartphone
start-up Jolla. This platform offers Qt5 with QtQuick2 and Wayland which really marks the edge of UI
development. This is so much of technical motivation to me to do some great UI stuff with ownKeepass :)

## Some words about Keepass database security

The database code in ownKeepass is based on the [KeepassX] project and as such contains a lot of
security related features. It uses proven encryption algorithms like Advanced Encryption Standard
(AES / Rijndael) or Twofish with 128 bits block size and 256 bits key size, SHA-256 as hashing
algorithm and in-memory encryption of all passwords. Furthermore it protects the master
password against Brute-Force and Dictonary Attacks by hashing and encrypting it before
using it to decrypt the Keepass database. This feature is called key transformation rounds and can be
adjusted in database settings. Anyway that all just adds additional security to two points which
you should be aware of:

*   Always use a long enough and difficult to guess master password.
*   Protect your system from spyware which might be specialized to attack ownKeepass.

The second is law #1 of the [10 Immutable Laws of Security]: "If a bad guy can persuade you to run
his program on your computer, it's not your computer anymore".

## Sharing Keepass database between your jolla phone and your desktop PC

The Keepass database file format is perfect to share your password safe between different
systems like phones, tablets, desktop PC and so on. That is because there are a lot of Keepass
implementations available for those platforms. Have a look at the [Keepass download page] to get the classic Keepass 1 or
the new Keepass version 2 for the desktop PC. There is also a list of alternative Keepass implementations on that page.
I would also like to point you to [KeepassX] which is also compatible with Keepass version 1 and 2 databases.
You can share your Keepass database file via SD card or via a cloud service like Dropbox.
When using a cloud server I would recommend to use a key file in addition to the master password.
The additional key file will be used by ownKeepass to decrypt the database. Store this key file
only locally on your phone and on your desktop PC. Do not upload it to the cloud service. If an attacker
hacks your cloud service he will be left without the key file. By doing so you make it even
harder for an attacker to crack your Keepass database because the key file content is usually
impossible to guess.

Optionally you could use [Syncthing] to sync the password safe between different devices. Syncthing is available for
all platforms including Sailfish OS. For Sailfish OS it is available in openrepos as the [core] and a [GUI].
Syncthing does not require a sync over the internet but it can sync locally between devices.

Copyright 2014 - 2017 Marko Koschak. Licensed under GPLv2. See LICENSE for more info.


[openrepos.net]: https://openrepos.net/content/jobe/ownkeepass                             "Beta and testing releases"
[Keepass]: http://www.keepass.info/help/v1/setup.html                                      "Official Keepass homepage for version 1"
[KeepassX]: http://www.keepassx.org                                                        "KeepassX project homepage"
[KeepassXC]: http://www.keepassxc.org                                                      "KeepassXC project homepage"
[10 Immutable Laws of Security]: http://technet.microsoft.com/en-us/library/cc722487.aspx  "10 Immutable Laws of Security"
[Keepass download page]: http://www.keepass.info/download.html                             "Download classic Keepass"
[Bug reports go here]: https://github.com/jobe-m/ownkeepass/issues
[Translations here]: https://www.transifex.com/projects/p/jobe_m-ownKeepass/
[Syncthing]: https://syncthing.net/                                                        "Syncthing homepage"
[core]: https://openrepos.net/content/fooxl/syncthing-inotify-bin                          "Syncthing core for SFOS"
[GUI]: https://openrepos.net/content/fooxl/syncthing-sf                                    "Syncthing GUI for SFOS"
[SFOS manual building]: https://sailfishos.org/wiki/Tutorial_-_Building_packages_manually  "Tutorial - Building packages manually"
[libsodium]: https://openrepos.net/content/birdzhang/libsodium                             "Libsodium on OpenRepos.net"
