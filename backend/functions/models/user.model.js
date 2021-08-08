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

    signUserIn(email, password) {
        return firebaseClient.signUserIn(email, password);
    }

    signUserOut() {
        return firebaseClient.signUserOut();
    }

    updateUserEmail(email) {
        return firebaseClient.updateUserEmail(email);
    }
}

module.exports = User;