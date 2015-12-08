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
        channel: channelPage.channelID
    }
    slackWorker.sendMessage({'apiMethod': "channels.info", 'token': Globals.slackToken, 'arguments': arguments });
}


function loadChannelHistory() {
    var arguments = {
        channel: channelPage.channelID,
        count: 20
    }

    slackWorker.sendMessage({'apiMethod': "channels.history", 'token': Globals.slackToken, 'arguments': arguments});
}


// private

function addMessagesToModel(data) {
    if(data.ok === false) {
        console.log("addMessagesToModel:", data.error)
    } else {
        for(var i=data.messages.length-1; i >= 0; i--) {
            messagesModel.append(data.messages[i]);
        }
    }
}

function addChannelInfoToPage(data) {
    channelPage.channelPurpose = data.channel.purpose.value;
}
