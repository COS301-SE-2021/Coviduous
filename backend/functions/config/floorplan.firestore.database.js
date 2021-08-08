let admin = require('firebase-admin');
let db = admin.firestore();
let response;
let lastQuerySucceeded=true;


class Firestore {
  
    constructor() {
        console.log("Firestore database initialized");

    }

    async createFloorPlan(floorplanNumber, floorplanData) {
      try {
        response=await db.collection('floorplan').doc(floorplanNumber)
            .create(floorplanData); 
            lastQuerySucceeded=true;
      } catch (error) {
        console.log(error);
        lastQuerySucceeded=false;
      }
    }

    getIfLastQuerySucceeded() {
        return true;
    }

}

module.exports = Firestore;