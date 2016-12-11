import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/logic/users.js" as UsersLogic

Page{
  id: profilePage
  allowedOrientations: Orientation.All

  // properties from lower stack page
  property variant value
  //
  property variant user
  property variant model

  Component.onCompleted: {
    user = UsersLogic.get(value)
    console.log(JSON.stringify(user))

    model = {
      source: user.profile.imageOriginal || user.profile.image192,
      name: user.name
    }
  }

  SilicaFlickable {
    anchors.fill: parent
    contentHeight: content.height

    Column {
      id: content
      anchors {
        left: parent.left
        right: parent.right
        margins: Theme.paddingLarge
      }
      spacing: Theme.paddingMedium

      PageHeader {
        title: user.name
        width: parent.width
      }

      Column {
        id: portrait
        width: parent.width

        Image {
          anchors.horizontalCenter: parent.horizontalCenter

          asynchronous : true
          fillMode : Image.PreserveAspectFit
          source: profilePage.model.source

          MouseArea {
            anchors.fill: parent
            onClicked: pageStack.push(Qt.resolvedUrl("Image.qml"), {model: profilePage.model})
          }
        }

        SectionHeader {
          text: qsTr('Real Name')
        }
        Label {
          text: user.realName
          anchors.horizontalCenter: parent.horizontalCenter
        }

        SectionHeader {
          text: qsTr('Details')
        }

        DetailItem {
          label: qsTr('2FA activated')
          value: user.has2FA
        }
        DetailItem {
          label: qsTr('Admin')
          value: user.isAdmin
        }
        DetailItem {
          label: qsTr('Owner')
          value: user.isOwner
        }
        DetailItem {
          label: qsTr('Restricted')
          value: user.isRestricted
        }
      }

      Button {
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: UsersLogic.handleLink('slackfish://Chat/' + user.id)
        text: qsTr('Send message')
      }
    }
  }
}
