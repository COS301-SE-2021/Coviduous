let admin = require('firebase-admin');
let db = admin.firestore();

exports.createBooking = async (bookingNumber, bookingData) => {
    try {
        await db.collection('bookings').doc(bookingNumber)
            .create(bookingData);
        return true;
    } catch (error) {
        console.log(error);
        return false;
    }
}

exports.getBookings = async (userId) => {
    try {
        const document = db.collection('bookings').where("userId","==", userId);
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

exports.deleteBooking= async (bookingNumber) => {
    try {
        const document = db.collection('bookings').doc(bookingNumber);
        await document.delete();
        return true;
    } catch (error) {
        console.log(error);
        return false;
    }
}