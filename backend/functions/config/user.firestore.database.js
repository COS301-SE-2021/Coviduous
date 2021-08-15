let admin = require('firebase-admin');
let db = admin.firestore();

exports.createUser = async (userId, userData) => {
    try {
        await db.collection('users').doc(userId)
            .create(userData);
        return true;
    } catch (error) {
        console.log(error);
        return false;
    }
}

exports.getUsers = async () => {
    try {
        const document = await db.collection('users');
        const snapshot = await document.get();

        let list = [];
        snapshot.forEach(doc => {
            let data = doc.data();
            list.push(data);
        });

        return list;
    } catch (error) {
        console.log(error);
        return null;
    }
}

exports.getUserDetails = async (userId) => {
    try {
        const document = await db.collection('users').doc(userId);
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
}

exports.updateUser = async (userId, userData) => {
    try {
        const document = await db.collection('users').doc(userId);
        await document.set({
            ...((userData.firstName != null && userData.firstName !== "") && {firstName: userData.firstName}),
            ...((userData.lastName != null && userData.lastName !== "") && {lastName: userData.lastName}),
            ...((userData.email != null && userData.email !== "") && {email: userData.email}),
            ...((userData.userName != null && userData.userName !== "") && {userName: userData.userName}),
            ...((userData.companyName != null && userData.companyName !== "") && {companyName: userData.companyName}),
            ...((userData.companyAddress != null && userData.companyAddress !== "") && {companyAddress: userData.companyAddress}),
        });
    } catch (error) {
        console.log(error);
        return false;
    }
}

exports.deleteUser = async (userId) => {
    try {
        const document = db.collection('users').doc(userId);
        await document.delete();

        return true;
    } catch (error) {
        console.log(error);
        return false;
    }
}