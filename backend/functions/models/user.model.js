const FirebaseClient = require("../services/user/firebase.auth");

let firebaseClient = null;

class User {
    constructor(useEmulator) {
        if (useEmulator === true) {
            firebaseClient = new FirebaseClient(true);
        } else {
            firebaseClient = new FirebaseClient(false);
        }
        console.log("Created user class");
    }

    async createUser(email, password) {
        return await firebaseClient.createUser(email, password);
    }

    async signUserIn(email, password) {
        return await firebaseClient.signUserIn(email, password);
    }

    async signUserOut() {
        return await firebaseClient.signUserOut();
    }

    async updateUserEmail(newEmail, currentEmail, password) {
        return await firebaseClient.updateUserEmail(newEmail, currentEmail, password);
    }
}

module.exports = User;