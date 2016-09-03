import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/logic/channelPageLogic.js" as Logic

Page {
  id: channelPage

  // properties from lower stack page
  property variant    channelName
  property variant    channelID

  property string channelPurpose

  ListModel {
    id: messagesModel
  }

  WorkerScript {
    id: slackWorker
    source: "../js/services/slackWorker.js"
    onMessage: {
      Logic.workerOnMessage(messageObject);
    }
  }


  Component.onCompleted: {
    Logic.loadChannelInfo();
    Logic.loadChannelHistory();
  }

  SilicaListView {
    anchors.fill: parent
    anchors.margins: Theme.horizontalPageMargin
    id: channelList
    model: messagesModel

    header: Column {
      width: parent.width

      PageHeader {
        title: '#' + channelPage.channelName
      }

      Label {
        width: parent.width
        wrapMode: TextEdit.WordWrap
        textFormat: Text.RichText
        font.pixelSize: Theme.fontSizeSmall
        text: channelPage.channelPurpose
        color: Theme.secondaryColor
      }
    }

    delegate: ListItem {
      contentHeight: column.height

      Column {
        id: column
        width: parent.width

        Label {
          width: parent.width
          wrapMode: TextEdit.WordWrap
          text: model.text
          textFormat: Text.RichText
          font.pixelSize: Theme.fontSizeSmall
          color: Theme.primaryColor
        }

        SectionHeader {
          width: parent.width
          text: model.user + ' ' + new Date(model.ts * 1000).toLocaleTimeString()
        }
      }
    }

    footer: TextArea {
      id: textAreaMessage
      width: parent.width
      placeholderText: qsTr("Enter message here")

      EnterKey.enabled: text.length > 0
      EnterKey.iconSource: "image://theme/icon-m-enter-accept"
      EnterKey.onClicked: {
        Logic.sendMessage(text)
        text = ""
      }
    }
  }
}
