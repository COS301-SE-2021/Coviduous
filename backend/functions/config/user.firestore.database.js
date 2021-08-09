const admin = require('firebase-admin');

const db = admin.firestore();

exports.createUser = async (uid, email) => {
    let result;
    try {
        await db.collection('users')
            .add({
                uid: uid,
                email: email.toLowerCase()
            });
        result = true;
    } catch (error) {
        console.log(error);
        result = false;
    }
    return result;
}

exports.updateEmail = async (newEmail, currentEmail) => {
    let result;
    try {
        const document = db.collection('users');
        const snapshot = await document.get();

        let id = null;

        snapshot.forEach(doc => {
            let data = doc.data();
            if (data.email === currentEmail) {
                id = doc.id;
            }
        });

        if (id != null) {
            try {
                await db.collection('users')
                    .doc(id)
                    .set({
                        email: newEmail
                    }, { merge: true });
                console.log("User table updated");
                result = true;
            } catch (error) {
                console.log("Error while updating user info: " + error);
                result = false;
            }
        } else {
            console.log("Error while updating user info, could not find user with email: " + currentEmail);
            result = false;
        }
    } catch (error) {
        console.log("Error while accessing user table: " + error);
        result = false;
    }
    return result;
}

exports.getUserDetails = async (email) => {
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

exports.updateUserDetails = async (currentEmail, firstName, lastName, userType, companyID, companyName, companyAddress) => {
    let result;
    try {
        const document = db.collection('users');
        const snapshot = await document.get();

        let id = null;

        snapshot.forEach(doc => {
           let data = doc.data();
           if (data.email === currentEmail) {
               id = doc.id;
           }
        });

        if (id != null) {
            try {
                await db.collection('users')
                    .doc(id)
                    .set({
                        ...((firstName != null && firstName !== "") && {firstName: firstName}),
                        ...((lastName != null && lastName !== "") && {lastName: lastName}),
                        ...((userType != null && userType.toLowerCase() === "admin") && {userType: "admin"}),
                        ...((userType != null && userType.toLowerCase() === "user") && {userType: "user"}),
                        ...((companyID != null && companyID !== "") && {companyID: companyID}),
                        ...((companyName != null && companyName !== "") && {companyName: companyName}),
                        ...((companyAddress != null && companyAddress !== "") && {companyAddress: companyAddress})
                    }, { merge: true });
                console.log("User table updated")
                result = true;
            } catch (error) {
                console.log("Error while updating user info: " + error);
                result = false;
            }
        } else {
            console.log("Error while updating user info, could not find user with email: " + currentEmail);
            result = false;
        }
    } catch (error) {
        console.log("Error while accessing user table: " + error);
        result = false;
    }
    return result;
}