let _auth0Client = null;
let _idToken = null;
let _profile = null;

class Auth0Client {
    constructor() {
        _auth0Client = {
            domain: 'Mock domain',
            audience: 'Mock audience',
            clientID: 'Mock client ID',
            redirectUri: 'Mock redirect URI',
            responseType: 'Mock response type',
            scope: 'Mock scope'
        };
    }

    getIdToken() {
        return _idToken;
    }

    getProfile() {
        return _profile;
    }

    handleCallback() {
        return new Promise((resolve, reject) => {
            _idToken = "authResult.idToken";
            _profile = "authResult.idTokenPayload";

            return resolve(true);
        });
    }

    signIn() {
        console.log("Mock sign in operation");
    }

    signOut() {
        _idToken = null;
        _profile = null;
    }
}

module.exports = Auth0Client;