const User = require('../../models/user.model');

let database;
let userObj = null;

class UserController {
    constructor(useEmulator) {
        if (useEmulator === true) {
            userObj = new User(true);
        } else {
            userObj = new User(false);
        }
    }

    async setDatabase (db) {
        database = db;
    }

    async createUser(req, res) {
        try {
            await userObj.createUser(req.body.email, req.body.password);
            await database.createUser(req.body.uid, req.body.email);

            return res.status(200).send({
                message: 'User successfully created',
                data: req.body
            });
        } catch (error) {
            console.log("Error while creating new user: " + error);
            return res.status(500).send(error);
        }
    }

    async signUserIn(req, res) {
        try {
            await userObj.signUserIn(req.body.email, req.body.password);

            let userInfo = await database.getUserDetails(req.body.email);
            console.log(userInfo);

            return res.status(200).send({
                message: 'User successfully signed in',
                data: req.body
            });
        } catch (error) {
            console.log("Error while signing in user: " + error);
            return res.status(500).send(error);
        }
    }

    async getUserDetails(req, res) {
        try {
            await database.getUserDetails(req.body.email);

            return res.status(200).send({
               message: 'User details found',
               data: req.body
            });
        } catch (error) {
            console.log("Error while retrieving user details: " + error);
            return res.status(500).send(error);
        }
    }

    async updateUserDetails(req, res) {
        try {
            await database.updateUserDetails(req.body.currentEmail, req.body.firstName, req.body.lastName,
                req.body.companyID, req.body.companyName, req.body.companyAddress);

            return res.status(200).send({
                message: 'User updated',
                data: req.body
            });
        } catch (error) {
            console.log("Error while updating user details: " + error);
            return res.status(500).send(error);
        }
    }

    async updateUserEmail(req, res) {
        try {
            await database.updateEmail(req.body.newEmail, req.body.currentEmail);
            await userObj.updateUserEmail(req.body.newEmail, req.body.currentEmail, req.body.password);

            return res.status(200).send({
                message: 'User updated',
                data: req.body
            });
        } catch (error) {
            console.log("Error while updating user details: " + error);
            return res.status(500).send(error);
        }
    }

    async sendPasswordResetEmail(req, res) {
        try {
            await userObj.sendPasswordReset(req.body.email);

            return res.status(200).send({
               message: 'Password reset email sent',
               data: req.body
            });
        } catch (error) {
            console.log("Error while sending reset password email: " + error);
            return res.status(500).send(error);
        }
    }
}

module.exports = UserController;