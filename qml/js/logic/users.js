function get (id) {
  var rawId = id && id[0] || ''
  var response = JSON.parse(usersModel.get(rawId))

  return rawId ? response[rawId] : response
}
