.import "../applicationShared.js" as Globals

function workerOnMessage(messageObject) {
    if(messageObject.apiMethod === 'channels.history') {
        addMessagesToModel(messageObject.data);
    } else if(messageObject.apiMethod === 'channels.info') {
        addChannelInfoToPage(messageObject.data);
    } else {
        console.log("Unknown api method");
    }
}

function loadChannelInfo() {
    var arguments = {
        channel: channelPage.channelID,
        count: 42
    }
    slackWorker.sendMessage({'apiMethod': "channels.info", 'token': Globals.slackToken, 'arguments': arguments });
}


function loadChannelHistory() {
    slackWorker.sendMessage({'apiMethod': "channels.history", 'token': Globals.slackToken});
}


// private

function addMessagesToModel(data) {
    for(var i=0; i<data.messages.length; i++) {
        channelList.append(data.messages[i]);
    }
}

function addChannelInfoToPage(data) {
    channelPage.channelPurpose = data.channel.purpose.value;
}
