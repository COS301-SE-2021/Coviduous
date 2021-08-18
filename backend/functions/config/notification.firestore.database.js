const admin = require('firebase-admin');

const db = admin.firestore();

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
        const document = db.collection('notifications').doc(notificationId); // delete document based on notificationId
        await document.delete();
        return true;
    } catch (error) {
        console.log(error);
        return false;
    }
};

exports.viewNotifications = async () => {
    try {
        const document = db.collection('notifications');
        const snapshot = await document.get();

        let list = [];

        snapshot.forEach(doc => {
            let data = doc.data();
            list.push(data);
        });

        return list;
    } catch (error) {
        console.log(error);
        return error;
    }
};

exports.viewNotificationsUserEmail = async (userEmail) => {
    try {
        const document = db.collection('notifications').where("userEmail", "==", userEmail);
        const snapshot = await document.get();

        let list = [];

        snapshot.forEach(doc => {
            let data = doc.data();
            list.push(data);
        });

        return list;
    } catch (error) {
        console.log(error);
        return error;
    }
};