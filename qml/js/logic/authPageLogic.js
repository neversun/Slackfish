.import "../applicationShared.js" as Globals

function workerOnMessage(messageObject) {
    if(messageObject.apiMethod === 'oauth.access') {
        tokenReceived(messageObject.data);
    } else {
        anyMessageReceived(messageObject);
    }
}

function webViewUrlChanged(url) {
    if(url.toString().indexOf(redirect_uri)==0) {
        //Success
        console.log(url);
        var extractedCode = url.toString().substring(redirect_uri.length + 6).replace("&state=","");
        authentificated(extractedCode);
    } else {
        console.log(url);
    }
}

// private

function anyMessageReceived(data) {
    console.log(JSON.stringify(data));
}

function authentificated(code) {
    console.log(authPage.slack_api_code);
    slackWorker.sendMessage({'apiMethod': "oauth.access", 'code': code});
}

function tokenReceived(data) {
    Globals.slackToken = data.access_token;

    slackWorker.sendMessage({'apiMethod': "channels.list", 'token': Globals.slackToken});
}
