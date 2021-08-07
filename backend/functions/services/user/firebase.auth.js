require('dotenv').config(); //Dependency for environment variables

const Firebase = require('firebase');
let auth = null;

let _db = null;
let _user = null;

class FirebaseClient {
    constructor() {
        Firebase.initializeApp({
            apiKey: process.env.FirebaseClientAPIKey,
            authDomain: process.env.FirebaseClientAuthDomain,
            projectId: process.env.FirebaseClientProjectID,
        });

        // initialize Firestore through Firebase
        _db = Firebase.firestore();

        // disable deprecated features
        _db.settings({
            timestampsInSnapshots: true
        });

        auth = Firebase.auth();
        auth.useEmulator("http://localhost:9099");
    }

    async createUser(email, password) {
        await auth.createUserWithEmailAndPassword(email, password)
            .then((userCredential) => {
                // Signed in
                let user = userCredential.user;
                console.log("User creation successful: " + user.email + " has signed in");
                return true;
            })
            .catch((error) => {
                let errorCode = error.code;
                let errorMessage = error.message;
                console.log("User creation unsuccessful. Error " + errorCode + ": " + errorMessage);
                return false;
            });
        return false;
    }

    async signUserIn(email, password) {
        await auth.signInWithEmailAndPassword(email, password)
            .then((userCredential) => {
                // Signed in
                let user = userCredential.user;
                console.log("Sign in successful: " + user.email + " has signed in");
                return true;
            })
            .catch((error) => {
                let errorCode = error.code;
                let errorMessage = error.message;
                console.log("Sign in unsuccessful. Error " + errorCode + ": " + errorMessage);
                return false;
            });
        return false;
    }

    async signUserOut() {
        await auth.signOut().then(() => {
            console.log("Sign out successful");
            return true;
        }).catch((error) => {
            console.log("Sign out unsuccessful: " + error);
            return false;
        });
        return false;
    }

    async getCurrentUser() {
        _user = await Firebase.auth().currentUser;
        return _user;
    }

    getEmail() {
        if (_user == null) return;
        return _user.email;
    }

    async updateUserEmail(email) {
        if (_user == null) return;
        await auth.currentUser.updateEmail(email).then(() => {
            console.log("Email update successful. Email changed to " + email);
            return true;
        }).catch((error) => {
            console.log("Email update unsuccessful: " + error);
            return false;
        });
        return false;
    }

    async sendPasswordResetEmail(email) {
        await auth.sendPasswordResetEmail(email)
            .then(() => {
                console.log("Password reset email sent to " + email);
                return true;
            })
            .catch((error) => {
                var errorCode = error.code;
                var errorMessage = error.message;
                console.log("Password reset email not sent. Error " + errorCode + ": " + errorMessage);
                return false;
            });
        return false;
    }
}

module.exports = FirebaseClient;