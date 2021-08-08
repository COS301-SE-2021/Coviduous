//var database = require("../../config/firestore.database.js");
let database;
let lastCallSucceeded=false;

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

  exports.createFloorPlanMock = async (floorplanNumber, data) => {
      return await database.createFloorPlan(floorplanNumber,data);

};

exports.setDatabse= async(db)=>{

  database=db;
}