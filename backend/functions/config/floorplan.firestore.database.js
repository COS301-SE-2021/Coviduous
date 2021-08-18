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

    async createDesk(deskNumber, deskData) {
      try {
        response=await db.collection('desks').doc(deskNumber)
            .create(deskData); 
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

    async addRoom(floorNumber,currentNumRoomsInFloor) {
      try {
        console.log(currentNumRoomsInFloor);
        let rooms = parseInt(currentNumRoomsInFloor)+1;
        response= await db.collection('floors').doc(floorNumber).update(
          {
            "numRooms": rooms
        }
        );
        
        return true;
      } catch (error) {
        console.log(error);
        return false;
      }
    }

    async addFloor(floorplanNumber,currentNumFloorsInFloorplan) {
      try {
        let numFloors=parseInt(currentNumFloorsInFloorplan)+1;
        response= await db.collection('floorplans').doc(floorplanNumber).update(
          {
            "numFloors": numFloors
        }
        );
        
        return true;
      } catch (error) {
        console.log(error);
        return false;
      }
    }

    async removeRoom(floorNumber,currentNumRoomsInFloor) {
      try {
        let numRooms=parseInt(currentNumRoomsInFloor)-1;
        response= await db.collection('floors').doc(floorNumber).update(
          {
            "numRooms": numRooms
        }
        );
        
        return true;
      } catch (error) {
        console.log(error);
        return false;
      }
    }

    async removeFloor(floorplanNumber,currentNumFloorsInFloorplan) {
      try {
        let numFloors=parseInt(currentNumFloorsInFloorplan)-1;
        response= await db.collection('floorplans').doc(floorplanNumber).update(
          {
            "numRooms": numFloors
        }
        );
        
        return true;
      } catch (error) {
        console.log(error);
        return false;
      }
    }

    async getFloor(floorNumber) {
      try {
        //response= await db.collection('floors').doc(floorNumber).get();
        let response = db.collection('floors').doc(floorNumber);
        let doc = await response.get();
        let res=doc.data()
        
        return res;
      } catch (error) {
        console.log(error);
        return false;
      }
    }

    async getFloorPlan(floorplanNumber) {
      try {
  
        let response = db.collection('floorplans').doc(floorplanNumber);
        let doc = await response.get();
        let res=doc.data()
        
        return res;
      } catch (error) {
        console.log(error);
        return false;
      }
    }

    async editRoom(roomData) {
      try {
        response= await db.collection('rooms').doc(roomData.roomNumber).update(
        roomData
        );
        
        return true;
      } catch (error) {
        console.log(error);
        return false;
      }
    }
    
    async deleteRoom(roomNumber){
      try {
          const document = db.collection('rooms').doc(roomNumber); 
          await document.delete();
    
          return true;
      } catch (error) {
          console.log(error);
          return false;
      }
  }

  async deleteFloor(floorNumber){
    try {
        const document = db.collection('floors').doc(floorNumber); 
        await document.delete();
  
        return true;
    } catch (error) {
        console.log(error);
        return false;
    }
}

async deleteFloorPlan(floorplanNumber){
  try {
      const document = db.collection('floorplans').doc(floorplanNumber); 
      await document.delete();

      return true;
  } catch (error) {
      console.log(error);
      return false;
  }
}

async deleteDesk(deskNumber){
  try {
      const document = db.collection('desks').doc(deskNumber); 
      await document.delete();

      return true;
  } catch (error) {
      console.log(error);
      return false;
  }
}

async getDesks() {
  try {
    const document = db.collection('desks');
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

    getIfLastQuerySucceeded() {
        return true;
    }



}

module.exports = Firestore;