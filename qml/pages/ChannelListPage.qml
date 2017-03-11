import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/logic/users.js" as UsersLogic

Page {
  // init
  id: channelListPage
  allowedOrientations: Orientation.All

  property variant users: UsersLogic.get()
  property int usersLatestChange: usersModel.latestChange
  onUsersLatestChangeChanged: {
    users = UsersLogic.get()
  }

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
          property variant user: channelListPage.users[imChannelsModel.get(index).user]
          onClicked: {
            imChannelsModel.open(user.id)
            pageStack.push(Qt.resolvedUrl("ChannelPage.qml"), { channelIndex: index, type: 'im'})
          }

          Image {
            x: Theme.horizontalPageMargin
            anchors.verticalCenter: parent.verticalCenter
            source: 'image://theme/icon-s-chat?' + (user.active ? '#7fff00' : '#A9A9A9')
          }

          Label {
            anchors.verticalCenter: parent.verticalCenter
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
