.import "../applicationShared.js" as Globals

function workerOnMessage(messageObject) {
    if(messageObject.apiMethod === 'channels.list') {
        addChannelsToModel(messageObject.data);
    } else {
        console.log("Unknown api method");
    }
}

function loadChannels() {
    slackWorker.sendMessage({'apiMethod': "channels.list", 'token': Globals.slackToken});
}


// private

function addChannelsToModel(data) {
    for(var i=0; i<data.channels.length; i++) {
        channelModel.append(data.channels[i]);
    }
}
