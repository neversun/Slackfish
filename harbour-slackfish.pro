# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-slackfish

CONFIG += sailfishapp

SOURCES += src/harbour-slackfish.cpp

OTHER_FILES += qml/harbour-slackfish.qml \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    qml/pages/SecondPage.qml \
    rpm/harbour-slackfish.changes.in \
    rpm/harbour-slackfish.spec \
    rpm/harbour-slackfish.yaml \
    translations/*.ts \
    harbour-slackfish.desktop

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/harbour-slackfish-de.ts

DISTFILES += \
    qml/pages/AuthPage.qml \
    qml/images/slack_rgb.png \
    qml/js/applicationShared.js \
    qml/js/slackWorker.js

