const admin = require('firebase-admin');

const db = admin.firestore();

exports.createUser = async (uid, data) => {
    let result;
    try {
        await db.collection('users')
            .add(data);
        result = true;
    } catch (error) {
        console.log(error);
        result = false;
    }
    return result;
}

exports.getUserInfo = async (email) => {
    try {
        const document = db.collection('users');
        const snapshot = await document.get();

        let list = [];

        snapshot.forEach(doc => {
            let data = doc.data();
            if (data.email === email) {
                list.push(data);
            }
        });
        return list;
    } catch (error) {
        console.log(error);
        return null;
    }
}

exports.updateUser = async (uid, data) => {
    let result;
    try {
        await db.collection('users').doc(uid)
            .delete()
            .then(() => {
                db.collection('users').doc(uid).create(data);
            });
        result = true;
    } catch (error) {
        console.log(error);
        result = false;
    }
    return result;
}