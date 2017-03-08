import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/logic/users.js" as UsersLogic

Page {
  // init
  id: channelListPage
  allowedOrientations: Orientation.All

  // view

  SilicaFlickable {
    anchors.fill: parent
    contentHeight: content.height

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

    Column {
      id: content
      width: parent.width

      PageHeader {
        title: qsTr("Channels")
      }

      ColumnView {
        model: channelsModel.len
        itemHeight: Theme.itemSizeSmall

        delegate: ListItem {
          onClicked: {
            pageStack.push(Qt.resolvedUrl("ChannelPage.qml"), { channelIndex: index, type: 'channel'})
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

      PageHeader {
        title: qsTr("Direct messages")
      }

      ColumnView {
        model: imChannelsModel.len
        itemHeight: Theme.itemSizeSmall

        delegate: ListItem {
          property variant user: UsersLogic.get(imChannelsModel.get(index).user)
          onClicked: {
            imChannelsModel.open(user.id)
            pageStack.push(Qt.resolvedUrl("ChannelPage.qml"), { channelIndex: index, type: 'im'})
          }

          Label {
            text: {
              return user.realName || user.name
            }
            font.pixelSize: Theme.fontSizeLarge
            width: parent.width
            color: highlighted ? Theme.highlightColor : Theme.primaryColor
            horizontalAlignment: Text.AlignHCenter
          }
        }
      }
    }
  }
}
