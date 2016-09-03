import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/logic/channelListPageLogic.js" as Logic

Page {
  id: channelListPage

  ListModel {
    id: channelListModel
  }


  WorkerScript {
    id: slackWorker
    source: "../js/services/slackWorker.js"
    onMessage: {
      Logic.workerOnMessage(messageObject);
    }
  }


  Component.onCompleted: {
    Logic.loadChannels();
  }

  // -------------------------



  SilicaListView {
    anchors.fill: parent

    model: channelListModel

    header: PageHeader {
      title: qsTr("Channels")
    }

    delegate: ListItem {
      onClicked: { pageStack.push(Qt.resolvedUrl("ChannelPage.qml"), { channelName: model.name, channelID: model.id  }) }

      Label {
        text: '#' + model.name
        font.pixelSize: Theme.fontSizeLarge
        width: parent.width
        color: highlighted ? Theme.highlightColor : Theme.primaryColor
        horizontalAlignment: Text.AlignHCenter
      }
    }
  }
}
