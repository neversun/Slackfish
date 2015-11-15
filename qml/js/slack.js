/* Distributes calls of Slack API functions */
WorkerScript.onMessage = function(messageType) {
    if (messageTypetype === 'apiTest') {
        apiTest(messageTypetype);
    }
    else if (messageTypetype ==='categorySummary') {
        categorySummary(message);
    }
    else {
        console.log("Unknown request to workerScript");
    }
}

/* Slack API function wrappers */
function apiTest(messageType) {
    httpGet("https://slack.com/api/api.test", messageType);
}

/* private functions (do-stuff-things) */
function httpGet(endpoint, messageType) {
    var http = new XMLHttpRequest();

    http.onreadystatechange = function() {
     if (http.readyState === XMLHttpRequest.DONE) {
        console.log(http.responseText);
        WorkerScript.sendMessage({ 'status': 'done', 'data': http.responseText, 'type': messageType });
     }
    }

    http.open("GET", endpoint);
    http.send();
}
