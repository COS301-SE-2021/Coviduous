const User = require('../../models/user.model');

const userObj = new User();

exports.createUser = async (req, res) => {
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

exports.signUserIn = async (req, res) => {
    try {
        await userObj.signUserIn(req.body.email, req.body.password);

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