const admin = require('firebase-admin');

const db = admin.firestore();

//generate notification id
exports.createNotification = async (notificationId, data) => {
    try {
        await db.collection('notifications').doc(notificationId)
            .create(data); // .add - auto generates document id
        return true;
    } catch (error) {
        console.log(error);
        return false;
    }
};

exports.deleteNotification = async (notificationId) => {
    try {
        const document = db.collection('announcements').doc(notificationId); // delete document based on announcementID
        await document.delete();
        return true;
    } catch (error) {
        console.log(error);
        return false;
    }
};