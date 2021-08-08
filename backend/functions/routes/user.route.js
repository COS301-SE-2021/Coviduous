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

// Optionally use emulator instead of actual Firebase Auth service
const userController = new UserController(true);

// User routes
// N.B. paths for a subsystem can all be the same
router.get('/users', userController.signUserIn);
router.post('/users', userController.createUser);

// Export API routes
module.exports = router;