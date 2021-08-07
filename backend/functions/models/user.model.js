const Firebase = require("../services/user/firebase");

const firebaseClient = new Firebase();

class User {
    constructor() {
        console.log("Created user class");
    }

    async createUser(email, password) {
        return await firebaseClient.createUser(email, password).then(function (result) {
            console.log("Create user response: " + result);
        });
    }

    async signUserIn(email, password) {
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