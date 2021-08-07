const FirebaseClient = require("../services/user/firebase.auth");

const firebaseClient = new FirebaseClient();

class User {
    constructor() {
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