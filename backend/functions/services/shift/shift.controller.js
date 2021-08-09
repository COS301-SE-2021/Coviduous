let db;
exports.createShift = async (req,res) => {
try{
    await db.createShift(req.body.shiftID,req.body);
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
      if (await database.deleteShift(req.body.shiftID) == true)
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
    await database.updateShift(req.body.shiftID);
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