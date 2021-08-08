//var database = require("../../config/firestore.database.js");
let database;

exports.createFloorPlan = async (req, res) => {
        try {
          await database.createFloorPlan(req.body.floorplanNumber,req.body);
          
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
    console.log(req.body.companyID);
      let filteredList=[];
      let floorplans = await database.getFloorPlans();
      floorplans.forEach(obj => {
        if(obj.companyID===req.body.companyID)
        {
          console.log("Accepted");
          console.log(obj.companyID);
          filteredList.push(obj);
        }
        else
        {
          console.log("rejected");
          console.log(obj.companyID);

        }
      });
      return res.status(200).send({
        message: 'Successfully retrieved floorplans',
        data: filteredList
      });
  } catch (error) {
      console.log(error);
      return res.status(500).send({
        message: err.message || "Some error occurred while fetching floorplans."
      });
  }
};

  exports.createFloorPlanMock = async (floorplanNumber, data) => {
      return await database.createFloorPlan(floorplanNumber,data);

};

exports.setDatabse= async(db)=>{

  database=db;
}