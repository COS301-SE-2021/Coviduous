let router = require('express').Router();

// Set default API response
router.get('/', function (req, res) {
    res.json({
        status: 200,
        message: 'This is the default user API route'
    });
});

// Import user controller
const UserController = require("../services/user/user.controller");
const devDatabase = require("../config/user.firestore.database.js");

// Optionally use emulator instead of actual Firebase Auth service
const userController = new UserController(true);

// Set database
userController.setDatabase(devDatabase);

// User routes
router.get('/users', userController.getUserDetails);
router.post('/users/signUp', userController.createUser);
router.get('/users/signIn', userController.signUserIn);
router.post('/users/updateDetails', userController.updateUserDetails);
router.post('/users/updateEmail', userController.updateUserEmail);
router.get('/passwordReset', userController.sendPasswordResetEmail);

// Export API routes
module.exports = router;