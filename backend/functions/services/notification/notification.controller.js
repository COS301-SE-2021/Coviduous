let database;
exports.setDatabase = async (db) => {
    database = db;
}
exports.createNotification = async (req, res) => {
    try {
        if (await database.createNotification(req.body.announcementId, req.body) == true)
        {
            return res.status(200).send({
                message: 'Notification successfully created',
                data: req.body
            });
        }
    } catch (error) {
        console.log(error);
        return res.status(500).send(error);
    }
};

exports.deleteNotification = async (req, res) => {
    try {
        if (await database.deleteNotification(req.body.announcementId) == true)
        {
            return res.status(200).send({
                message: 'Notification successfully deleted',
            });
        }
    } catch (error) {
        console.log(error);
        return res.status(500).send(error);
    }
};
/*
//trying another method of deleting above hence commented code.
exports.deleteNotification = async (req, res) => {

    if(req.body.notificationID === null){
        return res.status(400).send({
            message: 'Request parameter is null'
        });
    }
    try {
        const document = db.collection('notifications').doc(req.body.notificationID); // delete based on notificationID
        await document.delete();
        return res.status(200).send({
            message: 'Notification successfully deleted'
        });
    } catch (error) {
        console.log(error);
        return res.status(500).send(error);
    }

};
 */

exports.viewNotifications = async (req, res) => {
    try {
        let announcements = await database.viewNotifications();
        return res.status(200).send({
            message: 'Successfully retrieved notifications',
            data: announcements
        });
    } catch (error) {
        console.log(error);
        return res.status(500).send({
            message: error.message || "Some error occurred while fetching notifications."
        });
    }
};