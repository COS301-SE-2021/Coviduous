let admin = require('firebase-admin');
let db = admin.firestore();
let response;
let lastQuerySucceeded=true;


class Firestore {
  
    constructor() {
        console.log("Firestore database initialized");

    }

    async createBooking(bookingNumber, bookingData) {
      try {
        response=await db.collection('bookings').doc(bookingNumber)
            .create(bookingData); 
            lastQuerySucceeded=true;
      } catch (error) {
        console.log(error);
        lastQuerySucceeded=false;
      }
    }
}

module.exports = Firestore;