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

    async getBookings() {
      try {
        const document = db.collection('bookings');
        const snapshot = await document.get();
        
        let list = [];
        
        snapshot.forEach(doc => {
            let data = doc.data();
            list.push(data);
        });
    
        lastQuerySucceeded=true;
        return list;
      } catch (error) {
        console.log(error);
        lastQuerySucceeded=false;
      }
    }

    async deleteBooking(bookingNumber){
      try {
          const document = db.collection('bookings').doc(bookingNumber); 
          await document.delete();
          return true;
      } catch (error) {
          console.log(error);
          return false;
      }
  }
    // a booking cannot be edited because it is fixed to a specific shift and room which dictates the time so if weedit thetime of a booking it will not match the time of a shift , in that case they both need to be updated.
    //when you update a shift you must update all its corresponding bookings
    /*async editBooking(roomNumber,roomArea,deskArea,numDesks,percentage,maxCapacity,currentCapacity) {
      try {
        response= await db.collection('rooms').doc(roomNumber).update(
          {
            "roomArea": roomArea,
            "maxCapacity": maxCapacity,
            "roomNumber": "RMNR-test",
            "floorNumber": "test1",
            "deskArea": deskArea,
            "roomPercentage": percentage,
            "currentCapacity": currentCapacity,
            "numDesks": numDesks
        }
        );
        
        return true;
      } catch (error) {
        console.log(error);
        return false;
      }
    }*/
}

module.exports = Firestore;