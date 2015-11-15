/* Distributes calls of Slack API functions */
WorkerScript.onMessage = function(apiMethod) {
    if (apiMethod) {
        genericApiRequest(apiMethod);
    }
    else {
        console.log("Unknown request to workerScript");
    }
}

/* Slack API function wrappers */
function genericApiRequest(apiMethod) {
    var endpoint = "https://slack.com/api/" + apiMethod;
    httpGet(endpoint, apiMethod);
}

/* private functions (do-stuff-things) */
function httpGet(endpoint, apiMethod) {
    var http = new XMLHttpRequest();

    http.onreadystatechange = function() {
     if (http.readyState === XMLHttpRequest.DONE) {
        console.log(http.status, http.statusText);

        if(http.status === 200) {
            WorkerScript.sendMessage({ 'status': 'done', 'data': http.responseText, 'apiMethod': apiMethod });
        } else {
            WorkerScript.sendMessage({ 'status': 'error', 'data': null, 'apiMethod': apiMethod });
        }
     }
    }

    http.open("GET", endpoint);
    http.send();
}
