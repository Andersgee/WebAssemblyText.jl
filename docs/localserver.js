const express = require('express');
const http = require('http');

var app = express();
const PORT = 8080;
app.set('port', PORT);
app.get('/', (request, response) => {response.sendFile(__dirname + '/build/index.html');});
app.use('/', express.static(__dirname + '/build'));

var server = http.Server(app);
server.listen(PORT, () => {console.log("server on port",PORT);});
