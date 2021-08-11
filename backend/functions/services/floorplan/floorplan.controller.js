//Floorplan controller handles the operations of the floorplan service with business logic and CRUD operations
let database; //this variable holds the database
const Room = require("../../models/room.model");
const uuid = require("uuid"); // npm install uuid


//Create floorplan function will create a floorplan under the given database
//when a floorplan is created it is given the number n of floors within that floorplan 
//this function initiates n floors under a created floorplan
exports.createFloorPlan = async (req, res) => {
  try {
  let floorplanNumber = "FLP-" + uuid.v4();
  // let timestamp = new Date().toISOString();
  await database.createFloorPlan(floorplanNumber,req.body);
  for (let index = 0; index < req.body.numFloors; index++) {
  let floorNumber = "FLR-" + uuid.v4();
  let floorData = {
    floorNumber: floorNumber,
    numRooms: 0,
    currentCapacity: 0,
    maxCapacity: 0,
    floorplanNumber: floorplanNumber,
    adminId: req.body.adminId,
    companyId:req.body.companyId
  }
  await database.createFloor(floorNumber,floorData);
  console.log("Floor with floorNumber : "+floorNumber+" succesfully created under floorplan : "+floorplanNumber);

  }
  console.log("Floorplan with floorplanNumber : "+floorplanNumber+" succesfully created");
  return res.status(200).send({
  message: 'floorplan successfully created',
  data: req.body
  });
  } catch (error) {
  console.log(error);
  return res.status(500).send(error);
  }

  };


  //This function adds a single floor to a specific floorplan
  exports.createFloor = async (req, res) => {
  try {
    let floorNumber = "FLR-" + uuid.v4();
    let floorData = {
      floorNumber: floorNumber,
      numRooms: 0,
      currentCapacity: 0,
      maxCapacity: 0,
      floorplanNumber: req.body.floorplanNumber,
      adminId: req.body.adminId,
      companyId:req.body.companyId
    }
    await database.createFloor(floorNumber,floorData);
    console.log("Floor with floorNumber : "+floorNumber+" succesfully created under floorplan : "+req.body.floorplanNumber);
    
    return res.status(200).send({
      message: 'floor successfully created',
      data: floorData
    });
  } catch (error) {
    console.log(error);
    return res.status(500).send(error);
  }

};

//creating a room / adding a room to a floor 
// when creating a room , we need to initialize desks assosiated with that room as well
exports.createRoom = async (req, res) => {
try {
  let randInt2 = Math.floor(1000 + Math.random() * 9000);
  let roomNumber = "RMN-" + uuid.v4();
  let room =new Room(roomNumber,req.body.floorNumber,req.body.roomArea,req.body.deskArea,req.body.numberDesks,req.body.capacityPercentage);
  let roomData = {
    floorNumber:room.floorNumber,
    roomNumber:room.roomNumber,
    roomArea:room.roomArea, 
    capacityPercentage:room.capacityPercentage,
    numberDesks: room.numberDesks,
    occupiedDesks:room.occupiedDesks,
    currentCapacity:room.currentCapacity,
    deskArea:room.deskArea, 
    capacityOfPeopleForSixFtGrid:room.capacityOfPeopleForSixFtGrid,
    capacityOfPeopleForSixFtCircle:room.capacityOfPeopleForSixFtCircle
  }
  
  await database.createRoom(roomNumber,roomData);
  await database.addRoom(req.body.floorNumber,req.body.currentNumberRoomInFloor);
  console.log("Room with roomNumber : "+roomNumber+" succesfully created under floor : "+req.body.floorNumber);
  
  for (let index = 0; index < req.body.numberDesks; index++) {
    let deskNumber = "DSK-" + uuid.v4();
    let deskData = {
      deskNumber: deskNumber,
      roomNumber: roomNumber,
      deskArea: req.body.deskArea
    }
    await database.createDesk(deskNumber,deskData);
    console.log("Desk with deskNumber : "+deskNumber+" succesfully created under room : "+roomNumber);
    
  }
  
  return res.status(200).send({
    message: 'room successfully created',
    data: roomData
  });
} catch (error) {
  console.log(error);
  return res.status(500).send(error);
}

};

//This function returns all floorplans under a given company
//NB the spelling of companyId and companyId is very important for this function we query companyId
exports.viewFloorPlans = async (req, res) => {
try {
    let filteredList=[];
    let floorplans = await database.getFloorPlans();
    floorplans.forEach(obj => {
      if(obj.companyId===req.body.companyId)
      {
        filteredList.push(obj);
      }
      else
      {
      }
    });
    return res.status(200).send({
      message: 'Successfully retrieved floorplans based on your company',
      data: filteredList
    });
} catch (error) {
    console.log(error);
    return res.status(500).send({
      message: err.message || "Some error occurred while fetching floorplans."
    });
}
};

//This function fetches all floors under a floorplan
exports.viewFloors = async (req, res) => {
try {
    let filteredList=[];
    let floors = await database.getFloors();
    floors.forEach(obj => {
      if(obj.floorplanNumber===req.body.floorplanNumber)
      {
        filteredList.push(obj);
      }
      else
      {

      }
    });
    return res.status(200).send({
      message: 'Successfully retrieved floors based on your floorplan',
      data: filteredList
    });
} catch (error) {
    console.log(error);
    return res.status(500).send({
      message: err.message || "Some error occurred while fetching floors."
    });
}
};

//we query rooms based on the floor they in using the floor number
exports.viewRooms = async (req, res) => {
try {
  
    let filteredList=[];
    let rooms = await database.getRooms();
    rooms.forEach(obj => {
      if(obj.floorNumber===req.body.floorNumber)
      {
        filteredList.push(obj);
      }
      else
      {

      }
    });
    return res.status(200).send({
      message: 'Successfully retrieved rooms based on your floor number',
      data: filteredList
    });
} catch (error) {
    console.log(error);
    return res.status(500).send({
      message: err.message || "Some error occurred while fetching rooms."
    });
}
};

  exports.createFloorPlanMock = async (floorplanNumber, data) => {
      return await database.createFloorPlan(floorplanNumber,data);

};


// This function updates the contents of a room by recalculating its capacity and other attributes
exports.updateRoom = async (req, res) => {
try {
  let room =new Room(req.body.roomNumber,req.body.floorNumber,req.body.roomArea,req.body.deskArea,req.body.numberDesks,req.body.capacityPercentage);
  let roomData = {
    floorNumber:room.floorNumber,
    roomNumber:room.roomNumber,
    roomArea:room.roomArea, 
    capacityPercentage:room.capacityPercentage,
    numberDesks: room.numberDesks,
    occupiedDesks:room.occupiedDesks,
    currentCapacity:room.currentCapacity,
    deskArea:room.deskArea, 
    capacityOfPeopleForSixFtGrid:room.capacityOfPeopleForSixFtGrid,
    capacityOfPeopleForSixFtCircle:room.capacityOfPeopleForSixFtCircle
  }
  await database.editRoom(roomData);
  
  return res.status(200).send({
    message: 'room successfully updated',
    data: req.body
  });
} catch (error) {
  console.log(error);
  return res.status(500).send(error);
}

};


//Deletes a single room with all its desks
exports.deleteRoom = async (req, res) => {
  try {
        let desks= await database.getDesks();
        desks.forEach(obj4 =>{
        if(obj4.roomNumber===req.body.roomNumber)
        {
           database.deleteDesk(obj4.deskNumber);
        }
        else
        {
  
        }

        });
    await database.deleteRoom(req.body.roomNumber);
      return res.status(200).send({
        message: 'Room successfully deleted',
      });
  } catch (error) {
    console.log(error);
    return res.status(500).send(error);
  }
};

//Deletes a floor with all its rooms and desks
exports.deleteFloor = async (req, res) => {
  try {
    let filteredList=[];
    let rooms = await database.getRooms();
    rooms.forEach(obj => {
      if(obj.floorNumber===req.body.floorNumber)
      {
        filteredList.push(obj);
      }
      else
      {

      }
    });

    let desks= await database.getDesks();
    filteredList.forEach(obj => {
      
        desks.forEach(obj4 =>{
        if(obj4.roomNumber===obj.roomNumber)
        {
          database.deleteDesk(obj4.deskNumber);
        }
        else
        {
  
        }

        });

    database.deleteRoom(obj.roomNumber);
    });

    await database.deleteFloor(req.body.floorNumber);
      return res.status(200).send({
        message: 'Floor successfully deleted',
      });
  } catch (error) {
    console.log(error);
    return res.status(500).send(error);
  }
};


//Deletes a floorplan with all its floors and rooms and desks
exports.deleteFloorPlan = async (req, res) => {
  try {
    let filteredList=[];
    let floors = await database.getFloors();
    floors.forEach(obj => {
      if(obj.floorplanNumber===req.body.floorplanNumber)
      {
        filteredList.push(obj);
      }
      else
      {

      }
    });
    let desks= await database.getDesks();
    let rooms = await database.getRooms();
    filteredList.forEach(obj => {
      let filteredList2=[];
      rooms.forEach(obj2 => {
        if(obj2.floorNumber===obj.floorNumber)
        {
          filteredList2.push(obj2);
        }
        else
        {
  
        }
      });
      
     
      filteredList2.forEach(obj3 => {
        
        desks.forEach(obj4 =>{
        if(obj4.roomNumber===obj3.roomNumber)
        {
           database.deleteDesk(obj4.deskNumber);
        }
        else
        {
  
        }

        });
        database.deleteRoom(obj3.roomNumber);
        });
    database.deleteFloor(obj.floorNumber);
    });

    await database.deleteFloorPlan(req.body.floorplanNumber);
      return res.status(200).send({
        message: 'Floor Plan successfully deleted',
      });
  } catch (error) {
    console.log(error);
    return res.status(500).send(error);
  }
};

//This function allows dependency injections for production or mock databases
exports.setDatabse= async(db)=>{

  database=db;
}