import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
  id: page

  property variant model

  ProgressBar {
    width: parent.width
    anchors.centerIn: parent
    minimumValue: 0
    maximumValue: 1
    valueText: parseInt(value * 100) + "%"
    value: image.progress
    visible: image.status === Image.Loading
  }

  SilicaFlickable {
    anchors.fill: parent
    width: parent.width
    contentHeight: column.height

    Column {
      id: column
      width: parent.width

      PageHeader { title: model.name }

      Image {
        id: image
        visible: status === Image.Ready
        source: model.source
        width: parent.width
        fillMode: Image.PreserveAspectFit
      }
    }
  }
}
