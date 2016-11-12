import QtQuick 2.0
import Sailfish.Silica 1.0

Page{
  id: aboutPage
  allowedOrientations: Orientation.All

  SilicaFlickable {
    id: flickerList
    anchors.fill: aboutPage
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
        title: "About"
        width: parent.width
      }

      Column {
        id: portrait
        width: parent.width

        SectionHeader {
          text: 'Made by'
        }

        Label {
          text: 'neversun'
          anchors.horizontalCenter: parent.horizontalCenter
        }

        SectionHeader {
          text: 'Source'
        }

        Label {
          text: "github.com"
          font.underline: true;
          anchors.horizontalCenter: parent.horizontalCenter
          MouseArea {
            anchors.fill : parent
            onClicked: Qt.openUrlExternally("https://github.com/neversun/Slackfish")
          }
        }
      }
    }
  }
}
