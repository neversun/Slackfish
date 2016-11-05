import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
  id: channelListPage

  Component.onCompleted: {
    channelsModel.getChannels(false);
  }

  // -------------------------

  SilicaListView {
    anchors.fill: parent

    model: channelsModel.len

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
