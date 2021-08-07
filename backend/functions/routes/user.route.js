let router = require('express').Router();

// Set default API response
router.get('/', function (req, res) {
    res.json({
        status: 200,
        message: 'This is the default announcement API route'
    });
});

// Import user controller
const userController = require("../services/user/user.controller");

// User routes
// N.B. paths for a subsystem can all be the same
router.get('/users', userController.signUserIn);
router.post('/users', userController.createUser);

// Export API routes
module.exports = router;