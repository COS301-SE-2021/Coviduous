//A floorplan represents a building each building has floors and within the floors there are rooms
//This is a identical defination to a floorplan , a floorplan is characterized by the floors it has and the rooms in them.
let functions = require("firebase-functions");
let admin = require('firebase-admin');
let express = require('express');
let cors = require('cors');
let floorPlanApp = express();
const authMiddleware = require('../authMiddleWare.js');

floorPlanApp.use(cors({ origin: true }));
floorPlanApp.use(express.urlencoded({ extended: true }));
floorPlanApp.use(express.json());

// floorPlanApp.use(authMiddleware);

let database = admin.firestore();
let uuid = require("uuid");

//////////////////////////////////////////////////////////////////GENERAL FUNCTIONS AND OBJECTS/////////////////////////////////////////////////

 /**
 * This function returns the current date in a specified format.
 * @returns {string} The current date as a string in the format DD/MM/YYYY
 */
  Date.prototype.today = function () { 
    return ((this.getDate() < 10)?"0":"") + this.getDate() + "/" +
        (((this.getMonth()+1) < 10)?"0":"") + (this.getMonth()+1) +"/"+ this.getFullYear();
  }
  
  /**
  * This function returns the current time in a specified format.
  * @returns {string} The current time as a string in the format HH:MM:SS.
  */
  Date.prototype.timeNow = function () {
    return ((this.getHours() < 10)?"0":"") + this.getHours() + ":" +
        ((this.getMinutes() < 10)?"0":"") + this.getMinutes() + ":" +
        ((this.getSeconds() < 10)?"0":"") + this.getSeconds();
  }

  class Room {
    constructor(numOfRoomsInFloor, roomNum, roomName, floorNum, dimensions, deskDimentions, numDesks, percentage)
    {
        this.currentNumberRoomInFloor = numOfRoomsInFloor;
        this.floorNumber = floorNum;
        this.roomNumber = roomNum;
        this.roomName = roomName;
        this.roomArea = dimensions; //The dimensions of a room are determined by the square ft of the room which the admin can calculate or fetch from the buildings architectural documentation.
        this.capacityPercentage = percentage;
        this.numberDesks = numDesks;
        this.occupiedDesks = 0;
        this.currentCapacity = 0;
        this.deskArea=deskDimentions; // dimentions of a desk
        //this.capacityOfPeopleForTwelveFtGrid =(((roomArea) - ((deskArea) * numDesks)) / 144);
        this.capacityOfPeopleForSixFtGrid =((((dimensions) - ((deskDimentions) * numDesks)) *(percentage / 100.0)) /36);
        this.capacityOfPeopleForSixFtCircle =((((dimensions) - ((deskDimentions) * numDesks)) *(percentage / 100.0)) /28);
        //this.capacityOfPeopleForEightFtGrid = ((((roomArea) - (deskArea * numDesks)) * (percentage / 100.0)) /64);

        console.log("created room class");
    }

}
//////////////////////////////////////////////////////////////////GENERAL FUNCTIONS AND OBJECTS/////////////////////////////////////////////////


////////////////////////////////////////////////////////////////// FLOORPLAN ///////////////////////////////////////////////////////////////////
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
/**
 * @swagger
 * /floorplan:
 *   post:
 *     description: create a floorplan
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
floorPlanApp.post('/api/floorplan',async (req, res) => {
  let fieldErrors = [];

  if (req == null) {
    fieldErrors.push({field: null, message: 'Request object may not be null'});
  }

  let reqJson;
  try {
    reqJson = JSON.parse(req.body);
  } catch (e) {
    reqJson = req.body;
  }

  console.log("Request to create floorplan");
  console.log(reqJson);

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
    companyId: reqJson.companyId,
    base64String: reqJson.base64String
  }

  await database.collection('floorplans').doc(floorplanNumber).create(floorplanData); 

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
  await database.collection('floors').doc(floorNumber).create(floorData);
  console.log("Floor with floorNumber : "+floorNumber+" succesfully created under floorplan : "+floorplanNumber);

  }
  console.log("Floorplan with floorplanNumber : "+floorplanNumber+" succesfully created");

  // company-data summary
  // This needs a review
  let response = database.collection('company-data').doc(reqJson.companyId);
  let doc = await response.get();
  let companyData = doc.data();

  // Needs review
  
  let newNumFloorplans = parseInt(companyData.numberOfFloorplans) + 1;
  newNumFloorplans = newNumFloorplans.toString();

  response = await database.collection('company-data').doc(reqJson.companyId).update({
      "numberOfFloorplans": newNumFloorplans
  });
  
    
  let newNumFloors = parseInt(companyData.numberOfFloors) + parseInt(reqJson.numFloors);
  newNumFloors = newNumFloors.toString();

  response = await database.collection('company-data').doc(reqJson.companyId).update({
      "numberOfFloors": newNumFloors
  });


  return res.status(200).send({
  message: 'floorplan successfully created',
  data: reqJson
  });
  } catch (error) {
  console.log(error);
  return res.status(500).send(error);
  }

  });


  /**
 * This function creates a specified floor via an HTTP CREATE request.
 * @param req The request object must exist and have the correct fields. It will be denied if not.
 * The request object should contain the following:
 *   floorplanNumber: string
 *   adminId: string
 *   companyId: string
 * @param res The response object is sent back to the requester, containing the status code and a message.
 * @returns res - HTTP status indicating whether the request was successful or not.
 */
/**
 * @swagger
 * /floorplan/floor:
 *   post:
 *     description: create a floor in a floorplan
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
  //This function adds a single floor to a specific floorplan
  floorPlanApp.post('/api/floorplan/floor', async (req, res) => {
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
        companyId:reqJson.companyId,
      }
  
      //getFloorPlan
      let response = database.collection('floorplans').doc(reqJson.floorplanNumber);
      let doc = await response.get();
      let floorplan=doc.data()
      //addFloor
      let numFloors=parseInt(floorplan.numFloors)+1;
      await database.collection('floorplans').doc(reqJson.floorplanNumber).update(
      {
            "numFloors": numFloors
        });
      //create floor
      await database.collection('floors').doc(floorNumber).create(floorData);
      console.log("Floor with floorNumber : "+floorNumber+" succesfully created under floorplan : "+reqJson.floorplanNumber);
      
      // company-data summary
      //getCompanyData()
      let result = database.collection('company-data').doc(reqJson.companyId);
      let document = await result.get();
      let companyData = document.data();
      //addNumberOfFloorsCompanyData()
      let newNumFloors = parseInt(companyData.numberOfFloors) + 1;
      newNumFloors = newNumFloors.toString();
      result = await database.collection('company-data').doc(reqJson.companyId).update({
          "numberOfFloors": newNumFloors
      });
  
      return res.status(200).send({
        message: 'floor successfully created',
        data: floorData
      });
    } catch (error) {
      console.log(error);
      return res.status(500).send(error);
    }
  
  });

/**
 * This function creates a specified room via an HTTP CREATE request.
 * @param req The request object must exist and have the correct fields. It will be denied if not.
 * The request object should contain the following:
 *   currentNumberRoomInFloor: num
 *   floorNumber: string
 *   roomArea: num
 *   deskArea: num
 *   numberDesks: num
 *   capacityPercentage: num
 * @param res The response object is sent back to the requester, containing the status code and a message.
 * @returns res - HTTP status indicating whether the request was successful or not.
 */
/**
 * @swagger
 * /floorplan/room:
 *   post:
 *     description: create a room in a floor
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
  //This function adds a single floor to a specific floorplan
  floorPlanApp.post('/api/floorplan/room',async (req, res) => {
  try {
    let roomNumber = "RMN-" + uuid.v4();
  
    let reqJson = JSON.parse(req.body);
    console.log(reqJson);
    
    let room = new Room(reqJson.currentNumberRoomInFloor,roomNumber,reqJson.roomName,reqJson.floorNumber,
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
      capacityOfPeopleForSixFtCircle:room.capacityOfPeopleForSixFtCircle,
      base64String: reqJson.base64String
    }
    
    //getFloor()
    let response = database.collection('floors').doc(reqJson.floorNumber);
    let doc = await response.get();
    let floor=doc.data();
  
    //addRoom()
    let rooms = parseInt(reqJson.currentNumberRoomInFloor)+1;
    response= await database.collection('floors').doc(reqJson.floorNumber).update(
      {
        "numRooms": rooms
    }
    );
   //createRoom()
   await database.collection('rooms').doc(roomNumber).create(roomData);
   console.log("Room with roomNumber : "+roomNumber+" succesfully created under floor : "+reqJson.floorNumber);
  
    // company-data summary
    //getCompanyData()
    let result = database.collection('company-data').doc(floor.companyId);
    let document = await result.get();
    let companyData = document.data();
    //addNumberOfRoomsCompanyData()
    let newNumRooms = parseInt(companyData.numberOfRooms) + 1;
    newNumRooms = newNumRooms.toString();
    await database.collection('company-data').doc(floor.companyId).update({
        "numberOfRooms": newNumRooms
    });
    
    for (let index = 0; index < reqJson.numberDesks; index++) {
      let deskNumber = "DSK-" + uuid.v4();
      let deskData = {
        deskNumber: deskNumber,
        roomNumber: roomNumber,
        deskArea: reqJson.deskArea
      }
      //create desk
      await database.collection('desks').doc(deskNumber).create(deskData);
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
  
  });

  /**
 * This function brings a list of floorplans using the companyId.
 * @param req The request object must exist and have the correct fields. It will be denied if not.
 * The request object should contain the following:
 *   companyId: string
 * @param res The response object is sent back to the requester, containing the status code and a message.
 * @returns res - HTTP status indicating whether the request was successful or not.
 */
/**
 * @swagger
 * /floorplan/view:
 *   post:
 *     description: retrieve all floorplans by companyId
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
  floorPlanApp.post('/api/floorplans/view', async (req, res) => {
  try {
        let reqJson = JSON.parse(req.body);
        console.log(reqJson);
        let filteredList=[];
        //getFloorPlans()
        const document = database.collection('floorplans');
        const snapshot = await document.get();
        
        let floorplans = [];
        
        snapshot.forEach(doc => {
            let data = doc.data();
            floorplans.push(data);
        });
  
        floorplans.forEach(obj => {
        if(obj.companyId===reqJson.companyId)
        {
          filteredList.push(obj);
        }
        else
        {
        }
      });
  
      //Without these headers, the connection closes before it can send the whole base64String
      res.set({
        'Connection': 'Keep-Alive',
        'Keep-Alive': 'timeout=10, max=1000'
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
  });


   /**
 * This function brings a list of floors using the companyId.
 * @param req The request object must exist and have the correct fields. It will be denied if not.
 * The request object should contain the following:
 *   floorplanNumber: string
 * @param res The response object is sent back to the requester, containing the status code and a message.
 * @returns res - HTTP status indicating whether the request was successful or not.
 */
/**
 * @swagger
 * /floorplan/floors:
 *   post:
 *     description: retrieve all floors by floorplanNumber
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
    floorPlanApp.post('/api/floorplan/floors/view',async (req, res) => {
    try {
        let reqJson = JSON.parse(req.body);
        let filteredList=[];
        const document = database.collection('floors');
        const snapshot = await document.get();
        
        let floors = [];
        
        snapshot.forEach(doc => {
            let data = doc.data();
            floors.push(data);
        });
        
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
    });

  /**
 * This function brings a list of rooms using the companyId.
 * @param req The request object must exist and have the correct fields. It will be denied if not.
 * The request object should contain the following:
 *   floorNumber: string
 * @param res The response object is sent back to the requester, containing the status code and a message.
 * @returns res - HTTP status indicating whether the request was successful or not.
 */
/**
 * @swagger
 * /floorplan/floors/rooms:
 *   post:
 *     description: retrieve all rooms by floorNumber
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
   floorPlanApp.post('/api/floorplan/rooms/view',async (req, res) => {
  try {
      let reqJson = JSON.parse(req.body);
      let filteredList=[];
      //getRooms()
      const document = database.collection('rooms');
        const snapshot = await document.get();
        
        let rooms = [];
        
        snapshot.forEach(doc => {
            let data = doc.data();
            rooms.push(data);
        });
      
      rooms.forEach(obj => {
        if(obj.floorNumber===reqJson.floorNumber)
        {
          filteredList.push(obj);
        }
        else
        {
  
        }
      });
  
      //Without these headers, the connection closes before it can send the whole base64String
      res.set({
        'Connection': 'Keep-Alive',
        'Keep-Alive': 'timeout=5, max=1000'
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
  });

 /**
 * This function updates a rooms details.
 * @param req The request object must exist and have the correct fields. It will be denied if not.
 * The request object should contain the following:
 *   roomNumber: string
 *   roomName: string
 *   floorNumber: string
 *   roomArea: num
 *   deskArea: num
 *   numberDesks: num
 *   capacityPercentage: num
 * @param res The response object is sent back to the requester, containing the status code and a message.
 * @returns res - HTTP status indicating whether the request was successful or not.
 */
/**
 * @swagger
 * /floorplan/room:
 *   put:
 *     description: update a room's details
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
  floorPlanApp.post('/api/floorplan/room/update',async (req, res) => {

    let reqJson = JSON.parse(req.body);
    console.log(reqJson);
    
  try {
    let room =new Room(0,reqJson.roomNumber, reqJson.roomName, reqJson.floorNumber,reqJson.roomArea,reqJson.deskArea,reqJson.numberDesks,reqJson.capacityPercentage);
    let roomData;
    if(reqJson.base64String==="" || reqJson.base64String === null)
    {
      roomData = {
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
    }
    else
    {
    roomData = {
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
      capacityOfPeopleForSixFtCircle:room.capacityOfPeopleForSixFtCircle,
      base64String: reqJson.base64String
    }
  }
    //editRoom()
    await database.collection('rooms').doc(roomData.roomNumber).update(
      roomData
      );
    
    return res.status(200).send({
      message: 'room successfully updated',
      data: reqJson
    });
  } catch (error) {
    console.log(error);
    return res.status(500).send(error);
  }
  
  });


/**
 * This function deletes a room with all its desks.
 * @param req The request object must exist and have the correct fields. It will be denied if not.
 * The request object should contain the following:
 *   roomNumber:roomNumber
 * @param res The response object is sent back to the requester, containing the status code and a message.
 * @returns res - HTTP status indicating whether the request was successful or not.
 */
/**
 * @swagger
 * /floorplan/room:
 *   delete:
 *     description: delete a room by roomNumber
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
  floorPlanApp.delete('/api/floorplan/room/delete', async (req, res) => {
  try {
        // getDesk()
        const document = database.collection('desks');
        const snapshot = await document.get();
        
        let desks = [];
        
        snapshot.forEach(doc => {
            let data = doc.data();
            desks.push(data);
        });


      let reqJson = JSON.parse(req.body);
      console.log(reqJson);

        desks.forEach(obj4 =>{
        if(obj4.roomNumber===reqJson.roomNumber)
        {
           //deletedesk()
           database.collection('desks').doc(obj4.deskNumber).delete();
        }
        else
        {
  
        }

        });
    
    //getFloor()
    let response = database.collection('floors').doc(reqJson.floorNumber);
    let doc = await response.get();
    let floor=doc.data()
    //removeRoom()
    let numRooms=parseInt(floor.numRooms)-1;
    await database.collection('floors').doc(reqJson.floorNumber).update(
      {
        "numRooms": numRooms
    }
    );
    //deleteRoom()
    database.collection('rooms').doc(reqJson.roomNumber).delete();

    // company-data summary
     //getCompanyData()
     let result = database.collection('company-data').doc(floor.companyId);
     doc = await result.get();
     let companyData = doc.data();
     //decreaseNumberOfRoomsCompanyData()
    let newNumRooms = parseInt(companyData.numberOfRooms) - 1;
    newNumRooms = newNumRooms.toString();

    await database.collection('company-data').doc(floor.companyId).update({
        "numberOfRooms": newNumRooms
    });

      return res.status(200).send({
        message: 'Room successfully deleted',
      });
  } catch (error) {
    console.log(error);
    return res.status(500).send(error);
  }
});
/**
 * This function deletes a floor with all its rooms and desks of those rooms.
 * @param req The request object must exist and have the correct fields. It will be denied if not.
 * The request object should contain the following:
 *   floorNumber:floorNumber
 * @param res The response object is sent back to the requester, containing the status code and a message.
 * @returns res - HTTP status indicating whether the request was successful or not.
 */
/**
 * @swagger
 * /floorplan/floor:
 *   delete:
 *     description: delete a floor by floorNumber
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
 floorPlanApp.delete('/api/floorplan/floor/delete', async (req, res) => {
  try {
    let filteredList=[];
    //getRooms()
    let document = database.collection('rooms');
    let snapshot = await document.get();
    
    let rooms = [];
    
    snapshot.forEach(doc => {
        let data = doc.data();
        rooms.push(data);
    });
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

    //getDesks()
    document = database.collection('desks');
    snapshot = await document.get();
    
    let desks = [];
    
    snapshot.forEach(doc => {
        let data = doc.data();
        desks.push(data);
    });

    filteredList.forEach(obj => {
      
        desks.forEach(obj4 =>{
        if(obj4.roomNumber===obj.roomNumber)
        {
          //deleteDesk()
          const document = database.collection('desks').doc(obj4.deskNumber); 
          document.delete();
        }
        else
        {
  
        }

        });
    //deleteRoom()
    let document = database.collection('rooms').doc(obj.roomNumber); 
    document.delete();
    });
    //getFloorPlan()
    let result = database.collection('floorplans').doc(reqJson.floorplanNumber);
    let doc = await result.get();
    let floorplan=doc.data()
    //removeFloor()
    let numFloors=parseInt(floorplan.numFloors)-1;
    await database.collection('floorplans').doc(reqJson.floorplanNumber).update(
      {
        "numFloors": numFloors
    }
    );
    //deleteFloor()
    document = database.collection('floors').doc(reqJson.floorNumber); 
    await document.delete();

    // company-data summary
    //getCompanyData()
    result = database.collection('company-data').doc(floorplan.companyId);
    document = await result.get();
    let companyData = document.data();

    //decreaseNumberOfFloorsCompanyData()
    if (parseInt(companyData.numberOfFloors) > 0)
    {
        let newNumFloors = parseInt(companyData.numberOfFloors) - 1;
        newNumFloors = newNumFloors.toString();

        await database.collection('company-data').doc(floorplan.companyId).update({
            "numberOfFloors": newNumFloors
        });
    
    }
   
    if (parseInt(companyData.numberOfRooms) > 0)
      {
          let newNumRooms = parseInt(companyData.numberOfRooms) - numRoomsToDelete;
          newNumRooms = newNumRooms.toString();

          await database.collection('company-data').doc(floorplan.companyId).update({
              "numberOfRooms": newNumRooms
          });
      
      }

      return res.status(200).send({
        message: 'Floor successfully deleted',
      });
  } catch (error) {
    console.log(error);
    return res.status(500).send(error);
  }
});


/**
 * This function deletes a floorplan with all its floors,rooms and desks of those rooms.
 * @param req The request object must exist and have the correct fields. It will be denied if not.
 * The request object should contain the following:
 *   floorplanNumber:floorplanNumber
 * @param res The response object is sent back to the requester, containing the status code and a message.
 * @returns res - HTTP status indicating whether the request was successful or not.
 */
/**
 * @swagger
 * /floorplan:
 *   delete:
 *     description: delete a floorplan by floorplanNumber
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
 floorPlanApp.delete('/api/floorplan/delete', async (req, res) => {
  try {
    let filteredList=[];
    //getFloors()
    let document = database.collection('floors');
    let snapshot = await document.get();
    
    let floors = [];
    
    snapshot.forEach(doc => {
        let data = doc.data();
        floors.push(data);
    });
    let numFloorsToDelete = 0;
    let numRoomsToDelete = 0;

    let reqJson = JSON.parse(req.body);
    console.log(reqJson);

    //getFloorPlan()
    let response = database.collection('floorplans').doc(reqJson.floorplanNumber);
    let doc = await response.get();
    let floorplan=doc.data();

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

    //getDesks()
     document = database.collection('desks');
    snapshot = await document.get();
    
    let desks = [];
    
    snapshot.forEach(doc => {
        let data = doc.data();
        desks.push(data);
    });
    
    //getRooms()
    document = database.collection('rooms');
    snapshot = await document.get();
    
    let rooms = [];
    
    snapshot.forEach(doc => {
        let data = doc.data();
        rooms.push(data);
    });

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
           database.collection('desks').doc(obj4.deskNumber).delete();
        }
        else
        {
  
        }

        });
        database.collection('rooms').doc(obj3.roomNumber).delete();
        });
    database.collection('floors').doc(obj.floorNumber).delete();
    });

    database.collection('floorplans').doc(reqJson.floorplanNumber).delete();

    // company-data summary
    //getCompanyData();
    response = database.collection('company-data').doc(floorplan.companyId);
    doc = await response.get();
    let companyData = doc.data()
    //decreaseNumberOfFloorplansCompanyData()
    let newNumFloorplans = parseInt(companyData.numberOfFloorplans) - 1;
    newNumFloorplans = newNumFloorplans.toString();
    await database.collection('company-data').doc(floorplan.companyId).update({
        "numberOfFloorplans": newNumFloorplans
    });
    //decreaseNumberOfFloorsCompanyData()
   let newNumFloors = parseInt(companyData.numberOfFloors) - numFloorsToDelete;
  newNumFloors = newNumFloors.toString();

  response = await database.collection('company-data').doc(floorplan.companyId).update({
      "numberOfFloors": newNumFloors
  });
    //decreaseNumberOfRoomsCompanyData()
    let newNumRooms = parseInt(companyData.numberOfRooms) - numRoomsToDelete;
    newNumRooms = newNumRooms.toString();

    await database.collection('company-data').doc(floorplan.companyId).update({
        "numberOfRooms": newNumRooms
    });

      return res.status(200).send({
        message: 'Floor Plan successfully deleted',
      });
  } catch (error) {
    console.log(error);
    return res.status(500).send(error);
  }
});


  exports.floorplan = functions.https.onRequest(floorPlanApp);
  