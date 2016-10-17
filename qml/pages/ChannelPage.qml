import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
  id: channelPage

  // properties from lower stack page
  property variant    channelIndex
  //


  property variant channel
  property variant messages
  property int messageLen: slackfishctrl.messages.len

  onMessageLenChanged: {
    refreshMessages()
  }

  function refreshMessages () {
    if (!channel) {
      return
    }
    var msg = slackfishctrl.messages.getLatest(channel.id)
    if (msg && msg.channel) {
      messagesList.model.append(msg)
    }
  }

  function loadMessages () {
    var messages = slackfishctrl.messages.getAll(channel.id)
    if (messages) {
      messages = JSON.parse(messages)
      messages.forEach(function (m) {
        messagesList.model.append(m)
      })
    }
  }

  Component.onCompleted: {
    channel = slackfishctrl.channels.get(channelIndex)
    messages = slackfishctrl.messages

    loadMessages()
  }

  SilicaListView {
    id: messagesList
    anchors.fill: parent
    anchors.margins: Theme.horizontalPageMargin
    model: ListModel{}

    header: Column {
      width: parent.width

      PageHeader {
        title: '#' + channelPage.channel.name
      }

      Label {
        width: parent.width
        wrapMode: TextEdit.WordWrap
        textFormat: Text.RichText
        font.pixelSize: Theme.fontSizeSmall
        text: channelPage.channel.purpose.value
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
          text: model.user + ' ' + new Date(model.timestamp * 1000).toLocaleTimeString()
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
