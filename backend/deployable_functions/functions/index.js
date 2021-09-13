let admin = require('firebase-admin');
admin.initializeApp(); 

module.exports = {
    ...require("./controllers/office.controller.js"),
    ...require("./controllers/user.controller.js"),
    ...require("./controllers/shift.controller.js"),
    ...require('./controllers/announcement.controller.js'),
    ...require('./controllers/floorplan.controller.js'),
    ...require('./controllers/notification.controller.js')
}


