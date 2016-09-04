function workerOnMessage (messageObject) {
  if (messageObject.apiMethod === 'oauth.access') {
    tokenReceived(messageObject.data.access_token)
  }
}

function webViewUrlChanged (url) {
  url = url.toString()
  if (url.indexOf('redirect_uri') !== -1) {
    return
  }

  var codeIndex = url.indexOf('code=')
  if (codeIndex === -1) {
    return
  }

  authentificated(url.substring(codeIndex + 5).replace('&state=', ''))
}

function authentificated (code) {
  slackWorker.sendMessage({'apiMethod': 'oauth.access', 'code': code})
}

function tokenReceived (token) {
  // TODO: check if token is valid right now
  slackfishctrl.slack.connect(token)

  pageStack.replace(Qt.resolvedUrl('../../pages/ChannelListPage.qml'))

  slackfishctrl.settings.setToken(token)
  slackfishctrl.settings.save()
}
