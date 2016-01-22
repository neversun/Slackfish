.import "../applicationShared.js" as Globals

function workerOnMessage(messageObject) {
    if(messageObject.apiMethod === 'channels.history') {
        addMessagesToModel(messageObject.data);
    } else if(messageObject.apiMethod === 'channels.info') {
        addChannelInfoToPage(messageObject.data);
    } else if(messageObject.apiMethod === 'chat.postMessage') {
        messageReceived(messageObject.data);
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

function sendMessage(text) {
    var arguments = {
        channel: channelPage.channelID,
        text: text,
        as_user: true
    }
    messagesModel.append({ 'text': text, 'user':'placeholder for user' });
    slackWorker.sendMessage({'apiMethod': "chat.postMessage", 'token': Globals.slackToken, 'arguments': arguments});
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

function loadRecentMessages(timestampOfOldestMessage) {
    var arguments = {
        channel: channelPage.channelID,
        oldest: timestampOfOldestMessage
    };
    slackWorker.sendMessage({'apiMethod': "channels.history", 'token': Globals.slackToken, 'arguments': arguments});
}

function messageReceived(data) {
    if(data.ok === false) {
        console.log("message not delivered:", data.error)
    } else {
        console.log("message delivered")
//        var lastMessageTimeStamp = messagesModel.get(messagesModel.count-1).ts
//        loadRecentMessages(lastMessageTimeStamp);
    }
}
