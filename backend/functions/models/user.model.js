/*require('dotenv').config(); //Dependency for environment variables

const Firebase = require('firebase');
let auth = null;
let _userCredential = null;

class User {
    constructor(useEmulator) {
        Firebase.initializeApp({
            apiKey: process.env.FirebaseClientAPIKey,
            authDomain: process.env.FirebaseClientAuthDomain,
            projectId: process.env.FirebaseClientProjectID,
        });

        auth = Firebase.auth();

        if (useEmulator === true) {
            auth.useEmulator("http://localhost:9099");
        }
    }

    async createUser(email, password) {
        let result = false;
        await auth.createUserWithEmailAndPassword(email, password)
            .then((userCredential) => {
                // Signed in
                _userCredential = userCredential;
                let user = userCredential.user;
                console.log("User creation successful: " + user.email + " has signed in");
                result = true;
            })
            .catch((error) => {
                let errorCode = error.code;
                let errorMessage = error.message;
                console.log("User creation unsuccessful. Error " + errorCode + ": " + errorMessage);
                result = false;
            });
        return result;
    }

    async signUserIn(email, password) {
        let result = false;
        await auth.signInWithEmailAndPassword(email, password)
            .then((userCredential) => {
                // Signed in
                _userCredential = userCredential;
                let user = userCredential.user;
                console.log("Sign in successful: " + user.email + " has signed in");
                result = true;
            })
            .catch((error) => {
                let errorCode = error.code;
                let errorMessage = error.message;
                console.log("Sign in unsuccessful. Error " + errorCode + ": " + errorMessage);
                result = false;
            });
        return result;
    }

    async signUserOut() {
        let result = false;
        await auth.signOut().then(() => {
            console.log("Sign out successful");
            result = true;
        }).catch((error) => {
            console.log("Sign out unsuccessful: " + error);
            result = false;
        });
        return result;
    }

    getCurrentUser() {
        console.log("getCurrentUser(): " + _userCredential.user.uid);
        return _userCredential.user;
    }

    getEmail() {
        if (_userCredential == null)
            return null;
        console.log("getEmail(): " + _userCredential.user.email);
        return _userCredential.user.email;
    }

    async updateUserEmail(newEmail, currentEmail, password) {
        let result = false;
        await auth.signInWithEmailAndPassword(currentEmail.toLowerCase(), password)
            .then((userCredential) => {
                userCredential.user.updateEmail(newEmail.toLowerCase()).then(() => {
                    console.log("Email update successful. Email changed to " + newEmail);
                    result = true;
                }).catch((error) => {
                    let errorCode = error.code;
                    let errorMessage = error.message;
                    console.log("Email update unsuccessful. Error " + errorCode + ": " + errorMessage);
                    result = false;
                });
            }).catch((error) => {
                let errorCode = error.code;
                let errorMessage = error.message;
                console.log("Email update unsuccessful. Error " + errorCode + ": " + errorMessage);
                result = false;
        });
        return result;
    }

    async sendPasswordReset(email) {
        let result = false;
        await auth.sendPasswordResetEmail(email)
            .then(() => {
                console.log("Reset password email sent to " + email);
                result = true;
            })
            .catch((error) => {
                let errorCode = error.code;
                let errorMessage = error.message;
                console.log("Reset password email not sent. Error " + errorCode + ": " + errorMessage);
                result = false;
            });
        return result;
    }
}

module.exports = User;*/