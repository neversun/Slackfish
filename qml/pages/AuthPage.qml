import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/applicationShared.js" as Globals

Page {
    id: authPage
    property string client_id: "14600308501.14604351382"
    property string scope: "channels:read"
    property string redirect_uri : "http://0.0.0.0:12345/oauth"
    property string auth_url : "https://slack.com/oauth/authorize?client_id=" + client_id + "&scope=" + scope + "&redirect_uri=" + redirect_uri
    property bool showWebview : false
    property string slack_api_code: ""

    WorkerScript {
        id: slackWorker
        source: "../js/slackWorker.js"
        onMessage: {
            if(messageObject.apiMethod === 'oauth.access') {
                tokenReceived(messageObject.data);
            } else {
                anyMessageReceived(messageObject);
            }
        }
    }

    Column {
        id: col
        spacing: 15
        visible: !showWebview
        anchors.fill: parent
        PageHeader {
            title: "Slackfish"
        }
        Image {
            width: parent.width
            height: parent.height/4
            anchors.horizontalCenter: parent.horizontalCenter
            source: "../images/slack_rgb.png"
        }

        Label {
            text: "Welcome to Slackfish, an unoffical Slack client for Sailfish OS.<br>Please press 'continue' to login or create a StackExchange account.<p>This app is not created by, affiliated with, or supported by Slack Technologies, Inc."
            anchors.left: parent.left
            anchors.leftMargin: Theme.paddingLarge
            anchors.right: parent.right
            anchors.rightMargin: Theme.paddingLarge
            wrapMode: Text.Wrap
            textFormat: Text.RichText
            color: Theme.highlightColor
        }
        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Continue"
            onClicked : {
                webview.url = auth_url;
                webview.visible = true;
                showWebview = true;
            }
        }
    }

    SilicaWebView {
        id: webview
        visible: showWebview

        anchors.fill: parent

        onUrlChanged: {
            if(url.toString().indexOf(redirect_uri)==0) {
                //Success
                console.log(url);
                var extracted = url.toString().substring(redirect_uri.length + 6).replace("&state=","");
                authPage.slack_api_code = extracted;
                authentificated();
            } else {
                console.log(url);
            }
        }

    }

    function authentificated() {
        console.log(authPage.slack_api_code);
        slackWorker.sendMessage({'apiMethod': "oauth.access", 'code': authPage.slack_api_code});
    }

    function tokenReceived(data) {
        Globals.slackToken = data.access_token;
        slackWorker.sendMessage({'apiMethod': "channels.list", 'token': Globals.slackToken});
    }

    function anyMessageReceived(data) {
        console.log(JSON.stringify(data));
    }
}
