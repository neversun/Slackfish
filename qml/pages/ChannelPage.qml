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

    // -------------------------


    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            width: channelPage.width
            spacing: Theme.paddingLarge
            anchors {
               left: parent.left
               right: parent.right
               margins: Theme.paddingLarge
            }

            PageHeader {
                title: '#' + channelPage.channelName
            }

            Column {
                width: parent.width
                spacing: Theme.paddingLarge

                Label {
                    wrapMode: TextEdit.WordWrap
                    textFormat: Text.RichText
                    width: parent.width
                    font.pixelSize: Theme.fontSizeSmall
                    text: channelPage.channelPurpose
                    color: Theme.secondaryColor
                }

                ColumnView {
                    id: channelList
                    width: parent.width
                    height: parent.heighth
                    model: messagesModel
                    itemHeight: Theme.itemSizeSmall

                    delegate: BackgroundItem {
                        width: parent.width
                        Label {
                            width: parent.width
                            text: model.text
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.primaryColor
                            wrapMode: TextEdit.WordWrap
                        }
                    }
                }
            }
        }
    }
}
