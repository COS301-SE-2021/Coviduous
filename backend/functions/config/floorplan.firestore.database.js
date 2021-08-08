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
        response=await db.collection('floorplans').doc(floorplanNumber)
            .create(floorplanData); 
            lastQuerySucceeded=true;
      } catch (error) {
        console.log(error);
        lastQuerySucceeded=false;
      }
    }

    async createFloor(floorNumber, floorData) {
      try {
        response=await db.collection('floors').doc(floorNumber)
            .create(floorData); 
            lastQuerySucceeded=true;
      } catch (error) {
        console.log(error);
        lastQuerySucceeded=false;
      }
    }

    async createRoom(roomNumber, roomData) {
      try {
        response=await db.collection('rooms').doc(roomNumber)
            .create(roomData); 
            lastQuerySucceeded=true;
      } catch (error) {
        console.log(error);
        lastQuerySucceeded=false;
      }
    }

    async getFloorPlans() {
      try {
        const document = db.collection('floorplans');
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


    async getFloors() {
      try {
        const document = db.collection('floors');
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

    async getRooms() {
      try {
        const document = db.collection('rooms');
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


    async editRoom(roomNumber,roomArea,deskArea,numDesks,percentage,maxCapacity,currentCapacity) {
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
    }
    
    getIfLastQuerySucceeded() {
        return true;
    }

}

module.exports = Firestore;