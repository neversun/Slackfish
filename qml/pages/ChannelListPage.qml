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


    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column

            width: channelListPage.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("Channels")
            }

            SilicaListView {
                id: channelList
                width: parent.width
                height: parent.height
                model: channelListModel

                delegate: BackgroundItem {
                    onClicked: { pageStack.push(Qt.resolvedUrl("ChannelPage.qml"), { channelName: model.name, channelID: model.id  }) }
                    width: parent.width
                    Label {
                        text: '#' + model.name
                        font.pixelSize: Theme.fontSizeLarge
                        height: Theme.itemSizeLarge
                        width: parent.width
                        color: highlighted ? Theme.highlightColor : Theme.primaryColor
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }
        }
    }
}
