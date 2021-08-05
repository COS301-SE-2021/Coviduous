const express = require('express');
const cors = require('cors');
const jwt = require('express-jwt');
const jwks = require('jwks-rsa');
//const path = require('path');

const app = express();
app.use(cors());
//app.use('/', express.static(path.join(__dirname, 'public')));

module.exports = app;