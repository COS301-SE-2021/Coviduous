const express = require('express');
const cors = require('cors');
const FirebaseAdmin = require('firebase-admin');
const serviceAccount = require("../user/firebase-key");

const app = express();
app.use(cors());

var _serverInstance = null;

class Server {
    constructor() {
    }

    initializeApp() {
        FirebaseAdmin.initializeApp({
            credential: FirebaseAdmin.credential.cert(serviceAccount),
            databaseURL: `https://${serviceAccount.project_id}.firebaseio.com`
        });

        app.get('/firebase', async (req, res) => {
            const {sub: uid} = req.user;

            try {
                const firebaseToken = await FirebaseAdmin.auth().createCustomToken(uid);
                res.json({firebaseToken});
            } catch (error) {
                res.status(500).send({
                    message: 'Something went wrong acquiring a Firebase token.',
                    error: error
                });
            }
        });

        _serverInstance = app.listen(3001, () => console.log('Server running on localhost:3001'));
    }

    shutDownApp() {
        if (_serverInstance != null) {
            try {
                _serverInstance.close();
                console.log("Server shut down successfully");
            } catch (error) {
                console.log("Server failed to shut down: " + error);
            }
        }
    }
}

module.exports = Server;