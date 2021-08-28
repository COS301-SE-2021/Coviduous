//Floor plan controller handles the operations of the floor plan service with business logic and CRUD operations

const Room = require("../../models/room.model");
const uuid = require("uuid"); // npm install uuid

let database; //this variable holds the database
let reportingDatabase;

//This function allows dependency injections for production or mock databases
exports.setDatabase = async(db) => {
  database = db;
}

exports.setReportingDatabase = async (db) => {
  reportingDatabase = db;
}

/**
 * This function creates a specified floor plan via an HTTP CREATE request.
 * @param req The request object must exist and have the correct fields. It will be denied if not.
 * The request object should contain the following:
 *   numFloors: num
 *   adminId: string
 *   companyId: string
 * @param res The response object is sent back to the requester, containing the status code and a message.
 * @returns res - HTTP status indicating whether the request was successful or not.
 */
exports.createFloorPlan = async (req, res) => {
  let fieldErrors = [];

  if (req == null) {
    fieldErrors.push({field: null, message: 'Request object may not be null'});
  }

  //Look into express.js middleware so that these lines are not necessary
  let reqJson;
  try {
    reqJson = JSON.parse(req.body);
  } catch (e) {
    reqJson = req.body;
  }
  console.log(reqJson);
  //////////////////////////////////////////////////////////////////////

  if (reqJson.numFloors == null || reqJson.numFloors === '') {
    fieldErrors.push({field: 'numFloors', message: 'Number of floors may not be empty'});
  }

  if (reqJson.adminId == null || reqJson.adminId === '') {
    fieldErrors.push({field: 'adminId', message: 'Admin ID may not be empty'});
  }

  if (reqJson.companyId == null || reqJson.companyId === '') {
    fieldErrors.push({field: 'companyId', message: 'Company ID may not be empty'});
  }

  if (fieldErrors.length > 0) {
    console.log(fieldErrors);
    return res.status(400).send({
      message: '400 Bad Request: Incorrect fields',
      errors: fieldErrors
    });
  }

  try {
  let floorplanNumber = "FLP-" + uuid.v4();
    
  let floorplanData = {
    floorplanNumber: floorplanNumber,
    numFloors: reqJson.numFloors,
    adminId: reqJson.adminId,
    companyId: reqJson.companyId
  }
  await database.createFloorPlan(floorplanNumber,floorplanData);
  for (let index = 0; index < reqJson.numFloors; index++) {
  let floorNumber = "FLR-" + uuid.v4();
  let floorData = {
    floorNumber: floorNumber,
    numRooms: 0,
    currentCapacity: 0,
    maxCapacity: 0,
    floorplanNumber: floorplanNumber,
    adminId: reqJson.adminId,
    companyId:reqJson.companyId
  }
  await database.createFloor(floorNumber,floorData);
  console.log("Floor with floorNumber : "+floorNumber+" succesfully created under floorplan : "+floorplanNumber);

  }
  console.log("Floorplan with floorplanNumber : "+floorplanNumber+" succesfully created");

  // company-data summary
  let companyData = await reportingDatabase.getCompanyData(reqJson.companyId);
  await reportingDatabase.addNumberOfFloorplansCompanyData(reqJson.companyId, companyData.numberOfFloorplans);
  for (let i = 0; i < reqJson.numFloors; i++) {
    await reportingDatabase.addNumberOfFloorsCompanyData(reqJson.companyId, parseInt(companyData.numberOfFloors) + i);
  }

  return res.status(200).send({
  message: 'floorplan successfully created',
  data: reqJson
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

    let reqJson = JSON.parse(req.body);
    console.log(reqJson);
    
    let floorData = {
      floorNumber: floorNumber,
      numRooms: 0,
      currentCapacity: 0,
      maxCapacity: 0,
      floorplanNumber: reqJson.floorplanNumber,
      adminId: reqJson.adminId,
      companyId:reqJson.companyId
    }

    let floorplan = await database.getFloorPlan(reqJson.floorplanNumber);
    await database.addFloor(reqJson.floorplanNumber,floorplan.numFloors);
    await database.createFloor(floorNumber,floorData);
    console.log("Floor with floorNumber : "+floorNumber+" succesfully created under floorplan : "+reqJson.floorplanNumber);
    
    // company-data summary
    let companyData = await reportingDatabase.getCompanyData(reqJson.companyId);
    await reportingDatabase.addNumberOfFloorsCompanyData(reqJson.companyId, companyData.numberOfFloors);

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
// when creating a room , we need to initialize desks associated with that room as well
exports.createRoom = async (req, res) => {
try {
  let roomNumber = "RMN-" + uuid.v4();

  let reqJson = JSON.parse(req.body);
  console.log(reqJson);
  
  let room = new Room(reqJson.currentNumberRoomInFloor,roomNumber,"",reqJson.floorNumber,
      reqJson.roomArea,reqJson.deskArea, reqJson.numberDesks,reqJson.capacityPercentage);
  let roomData = {
    currentNumberRoomInFloor:room.currentNumberRoomInFloor,
    floorNumber:room.floorNumber,
    roomNumber:room.roomNumber,
    roomName:room.roomName,
    roomArea:room.roomArea, 
    capacityPercentage:room.capacityPercentage,
    numberDesks: room.numberDesks,
    occupiedDesks:room.occupiedDesks,
    currentCapacity:room.currentCapacity,
    deskArea:room.deskArea, 
    capacityOfPeopleForSixFtGrid:room.capacityOfPeopleForSixFtGrid,
    capacityOfPeopleForSixFtCircle:room.capacityOfPeopleForSixFtCircle
  }

  let floor = await database.getFloor(reqJson.floorNumber);

  await database.addRoom(reqJson.floorNumber,reqJson.currentNumberRoomInFloor);
  await database.createRoom(roomNumber,roomData);
  console.log("Room with roomNumber : "+roomNumber+" succesfully created under floor : "+reqJson.floorNumber);

  // company-data summary
  let companyData = await reportingDatabase.getCompanyData(floor.companyId);
  await reportingDatabase.addNumberOfRoomsCompanyData(floor.companyId, companyData.numberOfRooms);
  
  for (let index = 0; index < reqJson.numberDesks; index++) {
    let deskNumber = "DSK-" + uuid.v4();
    let deskData = {
      deskNumber: deskNumber,
      roomNumber: roomNumber,
      deskArea: reqJson.deskArea
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
      let reqJson = JSON.parse(req.body);
      console.log(reqJson);
    let filteredList=[];
    let floorplans = await database.getFloorPlans();

    
      floorplans.forEach(obj => {
      if(obj.companyId===reqJson.companyId)
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
      message: error.message || "Some error occurred while fetching floorplans."
    });
}
};

//This function fetches all floors under a floorplan
exports.viewFloors = async (req, res) => {
try {
    let reqJson = JSON.parse(req.body);
    let filteredList=[];
    let floors = await database.getFloors();
    
    floors.forEach(obj => {
      if(obj.floorplanNumber===reqJson.floorplanNumber)
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
    let reqJson = JSON.parse(req.body);
    let filteredList=[];
    let rooms = await database.getRooms();
    
    rooms.forEach(obj => {
      if(obj.floorNumber===reqJson.floorNumber)
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

  let reqJson = JSON.parse(req.body);
  console.log(reqJson);
  
try {
  let room =new Room(0,reqJson.roomNumber, reqJson.roomName, reqJson.floorNumber,reqJson.roomArea,reqJson.deskArea,reqJson.numberDesks,reqJson.capacityPercentage);
  let roomData = {
    floorNumber:room.floorNumber,
    roomNumber:room.roomNumber,
    roomName:room.roomName,
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
    data: reqJson
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

    let reqJson = JSON.parse(req.body);
    console.log(reqJson);

        desks.forEach(obj4 =>{
        if(obj4.roomNumber===reqJson.roomNumber)
        {
           database.deleteDesk(obj4.deskNumber);
        }
        else
        {
  
        }

        });

    let floor = await database.getFloor(reqJson.floorNumber);
    await database.removeRoom(reqJson.floorNumber,floor.numRooms)
    await database.deleteRoom(reqJson.roomNumber);

    // company-data summary
    let companyData = await reportingDatabase.getCompanyData(floor.companyId);
    await reportingDatabase.decreaseNumberOfRoomsCompanyData(floor.companyId, companyData.numberOfRooms);

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
    let numRoomsToDelete = 0;

    let reqJson = JSON.parse(req.body);
    console.log(reqJson);

    rooms.forEach(obj => {
      if(obj.floorNumber===reqJson.floorNumber)
      {
        filteredList.push(obj);
        numRoomsToDelete++;
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
    let floorplan= await  database.getFloorPlan(reqJson.floorplanNumber);
    await database.removeFloor(reqJson.floorplanNumber,floorplan.numFloors);
    await database.deleteFloor(reqJson.floorNumber);

    // company-data summary
    let companyData = await reportingDatabase.getCompanyData(floorplan.companyId);
    await reportingDatabase.decreaseNumberOfFloorsCompanyData(floorplan.companyId, companyData.numberOfFloors);
    for (let i = 0; i < numRoomsToDelete; i++) {
      await reportingDatabase.decreaseNumberOfRoomsCompanyData(floorplan.companyId, parseInt(companyData.numberOfRooms) - i);
    }

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
    let numFloorsToDelete = 0;
    let numRoomsToDelete = 0;

    let reqJson = JSON.parse(req.body);
    console.log(reqJson);

    let floorplan = await database.getFloorPlan(reqJson.floorplanNumber);

    floors.forEach(obj => {
      if(obj.floorplanNumber===reqJson.floorplanNumber)
      {
        filteredList.push(obj);
        numFloorsToDelete++;
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
          numRoomsToDelete++;
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

    await database.deleteFloorPlan(reqJson.floorplanNumber);

    // company-data summary
    let companyData = await reportingDatabase.getCompanyData(floorplan.companyId);
    await reportingDatabase.decreaseNumberOfFloorplansCompanyData(floorplan.companyId, companyData.numberOfFloorplans);
    for (let i = 0; i < numFloorsToDelete; i++) {
      await reportingDatabase.decreaseNumberOfFloorsCompanyData(floorplan.companyId, parseInt(companyData.numberOfFloors) - i);
    }
    for (let i = 0; i < numRoomsToDelete; i++) {
      await reportingDatabase.decreaseNumberOfRoomsCompanyData(floorplan.companyId, parseInt(companyData.numberOfRooms) - i);
    }

      return res.status(200).send({
        message: 'Floor Plan successfully deleted',
      });
  } catch (error) {
    console.log(error);
    return res.status(500).send(error);
  }
};