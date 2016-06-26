#
# Do NOT Edit the Auto-generated Part!
# Generated by: spectacle version 0.27
#

Name:       harbour-slackfish

# >> macros
# << macros

%{!?qtc_qmake:%define qtc_qmake %qmake}
%{!?qtc_qmake5:%define qtc_qmake5 %qmake5}
%{!?qtc_make:%define qtc_make make}
%{?qtc_builddir:%define _builddir %qtc_builddir}
Summary:    Slackfish
Version:    1.0
Release:    1
Group:      Qt/Qt
License:    LICENSE
URL:        http://example.org/
Source0:    %{name}-%{version}.tar.bz2
Source100:  harbour-slackfish.yaml
Requires:   sailfishsilica-qt5 >= 0.10.9
BuildRequires:  pkgconfig(sailfishapp) >= 1.0.2
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  desktop-file-utils

%description
Short description of my SailfishOS Application


%prep
# >> setup
#%setup -q -n example-app-%{version}
rm -rf vendor
# << setup

%build
# >> build pre
GOPATH=%(pwd):~/
GOROOT=~/go
export GOPATH GOROOT
cd %(pwd)
if [ $DEB_HOST_ARCH == "armel" ]
then
~/go/bin/linux_arm/go build -ldflags "-s" -o %{name}
else
~/go/bin/go build -ldflags "-s" -o %{name}
fi
# << build pre

# >> build post
# << build post

%install
rm -rf %{buildroot}
# >> install pre
# << install pre
install -d %{buildroot}%{_bindir}
install -p -m 0755 %(pwd)/%{name} %{buildroot}%{_bindir}/%{name}
install -d %{buildroot}%{_datadir}/applications
install -d %{buildroot}%{_datadir}/%{name}/qml
install -d %{buildroot}%{_datadir}/%{name}/qml/pages
install -d %{buildroot}%{_datadir}/%{name}/qml/cover
install -d %{buildroot}%{_datadir}/%{name}/qml/images
install -d %{buildroot}%{_datadir}/%{name}/qml/js
install -d %{buildroot}%{_datadir}/%{name}/qml/js/logic
install -d %{buildroot}%{_datadir}/%{name}/qml/js/services
install -d %{buildroot}%{_datadir}/%{name}/qml/i18n
install -m 0444 -t %{buildroot}%{_datadir}/%{name}/qml qml/*.qml
install -m 0444 -t %{buildroot}%{_datadir}/%{name}/qml/pages qml/pages/*.qml
install -m 0444 -t %{buildroot}%{_datadir}/%{name}/qml/images qml/images/*.png
install -m 0444 -t %{buildroot}%{_datadir}/%{name}/qml/js/ qml/js/*.js
install -m 0444 -t %{buildroot}%{_datadir}/%{name}/qml/js/logic qml/js/logic/*.js
install -m 0444 -t %{buildroot}%{_datadir}/%{name}/qml/js/services qml/js/services/*.js
#install -m 0444 -t %{buildroot}%{_datadir}/%{name}/qml/i18n i18n/*.qm
install -d %{buildroot}%{_datadir}/icons/hicolor/86x86/apps
install -m 0444 -t %{buildroot}%{_datadir}/icons/hicolor/86x86/apps data/%{name}.png
install -p %(pwd)/harbour-slackfish.desktop %{buildroot}%{_datadir}/applications/%{name}.desktop
# >> install post
# << install post

desktop-file-install --delete-original       \
  --dir %{buildroot}%{_datadir}/applications             \
   %{buildroot}%{_datadir}/applications/*.desktop

%files
%defattr(-,root,root,-)
%{_datadir}/applications/%{name}.desktop
%{_datadir}/%{name}/qml
%{_datadir}/%{name}/qml/i18n
%{_datadir}/icons/hicolor/86x86/apps
%{_bindir}
# >> files
# << files
