import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
  id: channelListPage
  allowedOrientations: Orientation.All

  Component.onCompleted: {
    if (channelsModel.len) {
      return
    }
    channelsModel.getChannels(false);
  }

  // -------------------------

  SilicaListView {
    anchors.fill: parent
    model: channelsModel.len

    PullDownMenu {
      MenuItem {
        text: "About"
        onClicked: pageStack.push(Qt.resolvedUrl("About.qml"))
      }
      MenuItem {
        text: "Sign out"
        onClicked: {
          settingsModel.token = ''
          settingsModel.save()
          slack.disconnect()
          pageStack.replace(Qt.resolvedUrl("AuthPage.qml"))
        }
      }
    }

    header: PageHeader {
      title: qsTr("Channels")
    }

    delegate: ListItem {
      onClicked: {
        pageStack.push(Qt.resolvedUrl("ChannelPage.qml"), { channelIndex: index})
      }

      Label {
        text: '#' + channelsModel.get(index).name
        font.pixelSize: Theme.fontSizeLarge
        width: parent.width
        color: highlighted ? Theme.highlightColor : Theme.primaryColor
        horizontalAlignment: Text.AlignHCenter
      }
    }
  }
}
