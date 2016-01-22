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
               margins: Theme.horizontalPageMargin
            }

            PageHeader {
                title: '#' + channelPage.channelName
            }

            Label {
                wrapMode: TextEdit.WordWrap
                textFormat: Text.RichText
                width: parent.width
                font.pixelSize: Theme.fontSizeSmall
                text: channelPage.channelPurpose
                color: Theme.secondaryColor
            }

            SilicaListView {
                id: channelList
                height: Theme.itemSizeLarge * messagesModel.count
                width: parent.width
                model: messagesModel

                delegate: BackgroundItem {
                    width: ListView.view.width
                    height: Theme.itemSizeLarge

                    SectionHeader {
                        text: model.user + ' ' + new Date(model.ts * 1000).toLocaleTimeString()
                    }

                    Label {
                        text: model.text
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.primaryColor
                        wrapMode: TextEdit.WordWrap
                    }
                }

                footer:
                    TextArea {
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
    }
}
