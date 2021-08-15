let router = require('express').Router();

// Set default API response
router.get('/', function (req, res) {
    res.json({
        status: 200,
        message: 'This is the default user API route'
    });
});

// Import user controller
const userController = require("../services/user/user.controller");
// import database
const devDatabase = require("../config/user.firestore.database.js");

// Set database
userController.setDatabase(devDatabase);

// User routes
router.delete('/users', userController.deleteUser);
router.get('/users', userController.getUsers);
router.get('/users/user-id', userController.getUserDetails);
router.post('/users', userController.createUser);
router.put('/users', userController.updateUser);

// Export API routes
module.exports = router;