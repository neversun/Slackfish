function get (id) {
  var rawId
  if (id) {
    rawId = Array.isArray(id) ? id[0] : id
  }
  rawId = rawId || ''

  var response = JSON.parse(usersModel.get(rawId))
  return rawId ? response[rawId] : response
}

function handleLink (link) {
    if (/^slackfish:\/\//.test(link)) {
      var split = /^slackfish:\/\/(.*?)\/(.*)/.exec(link)
      pageStack.push(Qt.resolvedUrl('../../pages/' + split[1] + '.qml'), { value: split[2] })
      return
    }

    console.log("external link", link)
    Qt.openUrlExternally(link)
}
