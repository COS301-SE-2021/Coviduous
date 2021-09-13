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
  response=await db.collection('floors').doc(floorNumber).create(floorData);
  console.log("Floor with floorNumber : "+floorNumber+" succesfully created under floorplan : "+floorplanNumber);

  }
  console.log("Floorplan with floorplanNumber : "+floorplanNumber+" succesfully created");

  // company-data summary
  // This needs a review
  let response = db.collection('company-data').doc(reqJson.companyId);
  let doc = await response.get();
  let companyData = doc.data()

  // Needs review
  
  let newNumFloorplans = parseInt(companyData.numberOfFloorplans) + 1;
  newNumFloorplans = newNumFloorplans.toString();

  response = await db.collection('company-data').doc(reqJson.companyId).update({
      "numberOfFloorplans": newNumFloorplans
  });
  
  for (let i = 0; i < reqJson.numFloors; i++) {
    
        let newNumFloors = parseInt(companyData.numberOfFloors) + 1;
        newNumFloors = newNumFloors.toString();

        response = await db.collection('company-data').doc(reqJson.companyId).update({
            "numberOfFloors": newNumFloors
        });

  }

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
      await database.collection('floorplans').doc(floorplanNumber).update(
      {
            "numFloors": numFloors
        });
      //create floor
      await db.collection('floors').doc(floorNumber).create(floorData);
      console.log("Floor with floorNumber : "+floorNumber+" succesfully created under floorplan : "+reqJson.floorplanNumber);
      
      // company-data summary
      //getCompanyData()
      let response = database.collection('company-data').doc(reqJson.companyId);
      let doc = await response.get();
      let companyData = doc.data();
      //addNumberOfFloorsCompanyData()
      let newNumFloors = parseInt(companyData.numberOfFloors) + 1;
      newNumFloors = newNumFloors.toString();
      response = await db.collection('company-data').doc(reqJson.companyId).update({
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

  //This function adds a single floor to a specific floorplan
  floorPlanApp.post('/api/floorplan/room',async (req, res) => {
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
      capacityOfPeopleForSixFtCircle:room.capacityOfPeopleForSixFtCircle,
      base64String: reqJson.base64String
    }
    
    //getFloor()
    let response = database.collection('floors').doc(reqJson.floorNumber);
    let doc = await response.get();
    let floor=doc.data()
  
    //addRoom()
    let rooms = parseInt(reqJson.currentNumberRoomInFloor)+1;
    response= await db.collection('floors').doc(reqJson.floorNumber).update(
      {
        "numRooms": rooms
    }
    );
   //createRoom()
   await db.collection('rooms').doc(roomNumber).create(roomData);
   console.log("Room with roomNumber : "+roomNumber+" succesfully created under floor : "+reqJson.floorNumber);
  
    // company-data summary
    //getCompanyData()
    let response = database.collection('company-data').doc(floor.companyId);
    let doc = await response.get();
    let companyData = doc.data();
    //addNumberOfRoomsCompanyData()
    let newNumRooms = parseInt(companyData.numberOfRooms) + 1;
    newNumRooms = newNumRooms.toString();
    response = await db.collection('company-data').doc(floor.companyId).update({
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
      await db.collection('desks').doc(deskNumber).create(deskData);
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

  exports.floorplan = functions.https.onRequest(floorPlanApp);
  