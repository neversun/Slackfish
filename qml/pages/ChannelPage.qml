import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
  id: channelPage
  allowedOrientations: Orientation.All

  // properties from lower stack page
  property variant    channelIndex
  //


  property variant channel
  property variant messages
  property int messageLen: messages.len

  onMessageLenChanged: {
    console.log('changed!', messageLen, messagesList.model.count)
    refreshMessages()
  }

  function refreshMessages () {
    if (!channel || !messagesList.model.count) {
      return
    }

    if (messageLen === -1) {
      console.log('no new messages, but refreshing')
      loadMessages()
      return
    }

    var msg = messagesModel.getLatest(channel.id)
    console.log(msg, JSON.stringify(msg))
    if (msg && msg.channel) {
      messagesList.model.append(msg)
    }
  }

  function loadMessages () {
    console.log('loadMessages')
    messagesList.model.clear()
    appendMessagesToModel(messagesModel.getAll(channel.id))
  }

  function loadChannelHistory () {
    var msg = messagesList && messagesList.model.get(0)
    var timestamp = msg && msg.timestamp || ''
    var messagesJson = messagesModel.getAllWithHistory(channel.id, timestamp)
    if (messagesJson.length < 3) {
      return
    }
    appendMessagesToModel(messagesJson)
  }

  function appendMessagesToModel (messages) {
    // go binding returns null as string
    if (messages === 'null') {
      return
    }
    messages = JSON.parse(messages)
    console.log(messages)
    console.log(JSON.stringify(messages))
    messages.forEach(function (m) {
      messagesList.model.append(m)
    })
  }


  Component.onCompleted: {
    console.log(channelIndex)
    channel = channelsModel.get(channelIndex)
    messages = messagesModel

    loadMessages()
    if (messagesList.model.count === 0) {
      loadChannelHistory()
    }
    messagesList.positionViewAtEnd()
  }


  SilicaListView {
    id: messagesList
    model: ListModel{}
    anchors.fill: parent

    PullDownMenu {
      MenuItem {
        text: "load more messages"
        onClicked: loadChannelHistory()
      }
    }

    header: Column {
      width: parent.width - Theme.paddingLarge
      x: Theme.paddingLarge

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

      Rectangle {
        color: "transparent"
        width: parent.width
        height: Theme.paddingMedium
      }
    }



    delegate: ListItem {
      contentHeight: column.height

      Column {
        id: column
        width: parent.width - Theme.paddingLarge
        anchors.verticalCenter: parent.verticalCenter
        x: Theme.paddingLarge

        Label {
          anchors.left: parent.left
          width: parent.width
          wrapMode: TextEdit.WordWrap
          text: model.text
          textFormat: Text.RichText
          font.pixelSize: Theme.fontSizeSmall
          color: model.processing ? Theme.secondaryColor : Theme.primaryColor
        }

        SectionHeader {
          anchors.right: parent.right
          width: parent.width
          text: model.user + ' ' + new Date(model.timestamp * 1000).toLocaleTimeString()
        }
      }
    }

    footer: TextArea {
      id: textAreaMessage
      width: parent.width
      placeholderText: qsTr("Message " + '#' + channelPage.channel.name)

      EnterKey.enabled: text.length > 0
      EnterKey.iconSource: "image://theme/icon-m-enter-accept"
      EnterKey.onClicked: {
        channelPage.messages.sendMessage(channelPage.channel.id, text)
        text = ""
      }
    }
    // TODO: enable once sailfish uses Qt >= 5.4
    // footerPositioning: ListView.OverlayFooter
  }
}
