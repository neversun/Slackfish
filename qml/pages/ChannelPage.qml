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

                Label {
                    wrapMode: TextEdit.WordWrap
                    textFormat: Text.RichText
                    width: parent.width
                    font.pixelSize: Theme.fontSizeSmall
                    text: channelPage.channelPurpose
                }

                SilicaListView {
                    id: channelList
                    width: parent.width
                    height: parent.heighth
                    //                model: channelModel

                    //                delegate: BackgroundItem {
                    //                    width: parent.width
                    //                    Label {
                    //                        text: '#' + model.name
                    //                        font.pixelSize: Theme.fontSizeLarge
                    //                        height: Theme.itemSizeLarge
                    //                        width: parent.width
                    //                        color: highlighted ? Theme.highlightColor : Theme.primaryColor
                    //                        horizontalAlignment: Text.AlignHCenter
                    //                    }
                    //                }
                }
            }
        }
    }
}
