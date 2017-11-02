'use strict';

const express = require('express');
const HOST = "0.0.0.0";
const appName = typeof process.argv[2] != "undefined" ? process.argv[2] : "DEFAULT_APP";
const port = typeof process.argv[3] != "undefined" ? process.argv[3] :  8080;

const app = express();

app.get('/', (req, res) => {
    res.send(`Hello from host:  ${appName}\n`);
});

console.log(`Running app: ${appName} on port: ${port}`);
app.listen(port, HOST);
