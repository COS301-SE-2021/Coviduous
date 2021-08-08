let router = require('express').Router();

//default response
router.get('/', function (req, res) {
    res.json({
        status: 200,
        message: 'This is the default notification API route'
    });
});
