/* attributes */
var baseUrl = "https://slack.com/api/";
var clientID = "14600308501.14604351382";
var clientSecret = "bf0b801b1b4716b72554f4415c6df6fd";
var redirectUri = "http%3A%2F%2F0.0.0.0%3A12345%2Foauth";

/* Distributes calls of Slack API functions */
WorkerScript.onMessage = function(data) {
    console.log('workerScript onMessage:', JSON.stringify(data));
    if (data.apiMethod === 'oauth.access') {
        oauthAccessRequest(data.apiMethod, data.code);
    } else if(data.apiMethod) {
        genericApiRequest(data.apiMethod, data.token);
    }
    else {
        console.log("Unknown request to workerScript");
    }
}

/* Slack API function wrappers */
function genericApiRequest(apiMethod, token) {
    var endpoint = baseUrl + apiMethod + '?token=' + token;
    console.log('genericApiRequest:', endpoint);
    httpGet(endpoint, apiMethod);
}

function oauthAccessRequest(apiMethod, code) {
    var endpoint = baseUrl + apiMethod +
            '?client_id=' + clientID +
            '&client_secret=' + clientSecret +
            '&code=' + code +
            '&redirect_uri=' + redirectUri;
    console.log('oauth', endpoint);
    httpGet(endpoint, apiMethod);
}

/* private functions (do-stuff-things) */
function httpGet(endpoint, apiMethod) {
    var http = new XMLHttpRequest();

    http.onreadystatechange = function() {
     if (http.readyState === XMLHttpRequest.DONE) {
        console.log(http.status, http.statusText);

        if(http.status === 200) {
            WorkerScript.sendMessage({ 'status': 'done', 'data': JSON.parse(http.responseText), 'apiMethod': apiMethod });
        } else {
            WorkerScript.sendMessage({ 'status': 'error', 'data': null, 'apiMethod': apiMethod });
        }
     }
    }

    http.open("GET", endpoint);
    http.send();
}
