//Floorplan controller handles the operations of the floorplan service with business logic and CRUD operations
let database;

//Create floorplan function will create a floorplan under the given database
//when a floorplan is created it is given the number n of floors within that floorplan 
//this function initiates n floors under a created floorplan
exports.createFloorPlan = async (req, res) => {
        try {
          let randInt = Math.floor(1000 + Math.random() * 9000);
          let floorplanNumber = "FLP-" + randInt.toString();
         // let timestamp = new Date().toISOString();
          await database.createFloorPlan(floorplanNumber,req.body);
          for (let index = 0; index < req.body.numFloors; index++) {
            let randInt2 = Math.floor(1000 + Math.random() * 9000);
            let floorNumber = "FLR-" + randInt2.toString();
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

  exports.createFloor = async (req, res) => {
    try {
      await database.createFloor(req.body.floorNumber,req.body);
      
      return res.status(200).send({
        message: 'floor successfully created',
        data: req.body
      });
    } catch (error) {
      console.log(error);
      return res.status(500).send(error);
    }

};

exports.createRoom = async (req, res) => {
  try {
    await database.createFloorPlan(req.body.roomNumber,req.body);
    
    return res.status(200).send({
      message: 'room successfully created',
      data: req.body
    });
  } catch (error) {
    console.log(error);
    return res.status(500).send(error);
  }

};

//NB the spelling of companyId and companyID is very important for this function we query companyID
exports.viewFloorPlans = async (req, res) => {
  try {
    //console.log(req.body.companyID);
      let filteredList=[];
      let floorplans = await database.getFloorPlans();
      floorplans.forEach(obj => {
        if(obj.companyID===req.body.companyID)
        {
          //console.log("Accepted");
          //console.log(obj.companyID);
          filteredList.push(obj);
        }
        else
        {
          //console.log("rejected");
          //console.log(obj.companyID);

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


exports.viewFloors = async (req, res) => {
  try {
    //console.log(req.body.companyID);
      let filteredList=[];
      let floors = await database.getFloors();
      floors.forEach(obj => {
        if(obj.floorplanNumber===req.body.floorplanNumber)
        {
          //console.log("Accepted");
          //console.log(obj.floorplanNumber);
          filteredList.push(obj);
        }
        else
        {
          //console.log("rejected");
          //console.log(obj.floorplanNumber);

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

exports.updateRoom = async (req, res) => {
  try {
    await database.editRoom(req.body.roomNumber,req.body.roomArea,req.body.deskArea,req.body.numDesks,req.body.percentage,req.body.maxCapacity,req.body.currentCapacity);
    
    return res.status(200).send({
      message: 'room successfully updated',
      data: req.body
    });
  } catch (error) {
    console.log(error);
    return res.status(500).send(error);
  }

};

exports.setDatabse= async(db)=>{

  database=db;
}