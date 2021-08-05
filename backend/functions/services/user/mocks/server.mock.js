const express = require('express');
const cors = require('cors');
const jwt = require('express-jwt');
const jwks = require('jwks-rsa');
//const path = require('path');

const app = express();
app.use(cors());
//app.use('/', express.static(path.join(__dirname, 'public')));

const jwtCheck = jwt({
    secret: jwks.expressJwtSecret({
        cache: true,
        rateLimit: true,
        jwksRequestsPerMinute: 5,
        jwksUri: `https://${process.env.AUTH0_DOMAIN}/.well-known/jwks.json`
    }),
    audience: process.env.AUTH0_API_AUDIENCE,
    issuer: `https://${process.env.AUTH0_DOMAIN}/`,
    algorithm: 'RS256'
});

app.get('/firebase', jwtCheck, async (req, res) => {
    res.json("firebaseToken");
});

app.listen(3001, () => console.log('Mock server running on localhost:3001'));

module.exports = app;