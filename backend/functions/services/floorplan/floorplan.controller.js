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

  exports.createFloorPlanMock = async (floorplanNumber, data) => {
      return await database.createFloorPlan(floorplanNumber,data);

};

exports.setDatabse= async(db)=>{

  database=db;
}