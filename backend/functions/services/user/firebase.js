require('dotenv').config(); //Dependency for environment variables

const firebase = require('firebase');

let _db = null;
let _user = null;

class Firebase {
    constructor() {
        firebase.initializeApp({
            apiKey: process.env.FirebaseClientAPIKey,
            authDomain: process.env.FirebaseClientAuthDomain,
            projectId: process.env.FirebaseClientProjectID,
        });

        // initialize Firestore through Firebase
        _db = firebase.firestore();

        // disable deprecated features
        _db.settings({
            timestampsInSnapshots: true
        });
    }

    async createUser(email, password) {
        firebase.auth().createUserWithEmailAndPassword(email, password)
            .then((userCredential) => {
                // Signed in
                let user = userCredential.user;
                console.log("User creation successful: " + user.email + " has signed in");
            })
            .catch((error) => {
                let errorCode = error.code;
                let errorMessage = error.message;
                console.log("User creation unsuccessful. Error " + errorCode + ": " + errorMessage);
            });
    }

    async signUserIn(email, password) {
        firebase.auth().signInWithEmailAndPassword(email, password)
            .then((userCredential) => {
                // Signed in
                let user = userCredential.user;
                console.log("Sign in successful: " + user.email + " has signed in");
            })
            .catch((error) => {
                let errorCode = error.code;
                let errorMessage = error.message;
                console.log("Sign in unsuccessful. Error " + errorCode + ": " + errorMessage);
            });
    }

    async signUserOut() {
        firebase.auth().signOut().then(() => {
            console.log("Sign out successful");
        }).catch((error) => {
            console.log("Sign out unsuccessful: " + error);
        });
    }

    async getCurrentUser() {
        _user = await firebase.auth().currentUser;
    }

    getEmail() {
        if (_user == null) return;
        return _user.email;
    }

    async updateUserEmail(email) {
        if (_user == null) return;
        await firebase.auth().currentUser.updateEmail(email).then(() => {
            console.log("Email update successful. Email changed to " + email);
        }).catch((error) => {
            console.log("Email update unsuccessful: " + error);
        });
    }

    async sendPasswordResetEmail(email) {
        firebase.auth().sendPasswordResetEmail(email)
            .then(() => {
                console.log("Password reset email sent to " + email);
            })
            .catch((error) => {
                var errorCode = error.code;
                var errorMessage = error.message;
                console.log("Password reset email not sent. Error " + errorCode + ": " + errorMessage);
            });
    }
}

module.exports = Firebase;