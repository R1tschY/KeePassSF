Name:       harbour-keepasssf

%define __provides_exclude_from ^%{_datadir}/.*$
%define __requires_exclude ^libgcrypt|libgpg-error|libargon2|libsodium.*$

%{!?qtc_qmake:%define qtc_qmake %qmake}
%{!?qtc_qmake5:%define qtc_qmake5 %qmake5}
%{!?qtc_make:%define qtc_make make}
%{?qtc_builddir:%define _builddir %qtc_builddir}
Summary:    A password safe application
Version:    2.0.2
Release:    1
Group:      Qt/Qt
License:    GPL v2
URL:        https://github.com/R1tschY/keepasssf
Source0:    %{name}-%{version}.tar.bz2
Requires:   sailfishsilica-qt5 >= 0.10.9
BuildRequires:  pkgconfig(sailfishapp) >= 0.0.10
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  pkgconfig(Qt5Concurrent)
BuildRequires:  libargon2-devel
BuildRequires:  pkgconfig(libsodium)
BuildRequires:  pkgconfig(libgcrypt)
BuildRequires:  qt5-qttools-linguist

%description
KeePassSF is a password safe application for the Sailfish OS platform.
You can use it to store your passwords for webpages, PINs, TANs and any
other data that should be kept secret on your Jolla Smartphone. The
database where that data is stored is encrypted using a master password.

%prep
%setup -q -n %{name}-%{version}

%build

%qtc_qmake5  \
    VERSION=%{version}

%qtc_make %{?_smp_mflags}

%install
rm -rf %{buildroot}

%qmake5_install

%files
%defattr(-,root,root,-)
%defattr(644,root,root,-)
%{_datadir}/icons/hicolor/*/apps/%{name}.png
%{_datadir}/applications
%{_datadir}/harbour-keepasssf
%attr(755,-,-) %{_bindir}
