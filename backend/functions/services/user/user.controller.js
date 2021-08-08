const User = require('../../models/user.model');

let userObj = null;

class UserController {
    constructor(useEmulator) {
        if (useEmulator === true) {
            userObj = new User(true);
        } else {
            userObj = new User(false);
        }
    }

    async createUser(req, res) {
        try {
            await userObj.createUser(req.body.email, req.body.password);

            console.log("User successfully created: " + req.body.email);

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
            userObj.signUserIn(req.body.email, req.body.password);

            console.log("User successfully signed in: " + req.body.email);

            return res.status(200).send({
                message: 'User successfully signed in',
                data: req.body
            });
        } catch (error) {
            console.log("Error while signing in user: " + error);
            return res.status(500).send(error);
        }
    }
}

module.exports = UserController;