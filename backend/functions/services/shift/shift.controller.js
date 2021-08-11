const Shift = require("../../models/shift.model");
const uuid = require("uuid");

let db;
exports.createShift = async (req,res) => {
try{
  let shiftID = "SHI-" + uuid.v4();
  let shift =new Shift(shiftID,req.body.startTime,req.body.endTime,req.body.description,req.body.groupNo,req.body.adminId,req.body.companyId);
  let shiftData = {
    shiftID: shift.shiftID,
    startTime: shift.startTime,
    endTime: shift.endTime, 
    description: shift.description,
    groupNo: shift.groupNo,
    adminId: shift.adminId,
    companyId: shift.companyId
  }
    await db.createShift(shiftID,shiftData);
    return res.status(200).send({
        data: req.body
    });
} catch (error) {
    console.log(error);
    return res.status(500).send(error);
  }
};
exports.deleteShift = async (req, res) => {
  try {
      if (await db.deleteShift(req.body.shiftID) == true)
      {
          return res.status(200).send({
              message: "Shift deleted"
          });
      }
  } catch (error) {
      console.log(error);
      return res.status(500).send(error);
  }
};
exports.updateShift = async (req, res) => {
  try {
    await database.updateShift(req.body.shiftID,req.body);
    return res.status(200).send({
      data: req.body
    });
  } catch (error) {
    console.log(error);
    return res.status(500).send(error);
  }

};
exports.viewShifts = async (req, res) => {
  try {
      let viewShifts = await database.viewShifts();  
      return res.status(200).send({
        data: viewShifts
      });
  } catch (error) {
      console.log(error);
      return res.status(500).send({
        message: err.message 
      });
  }
};

exports.setDatabse= async(_db)=>{
    db=_db;
  };