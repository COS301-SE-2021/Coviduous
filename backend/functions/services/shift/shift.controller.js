let db;

exports.createShift = async (req,res) => {
try{
    await db.createShift(req.body.shiftID);
    return res.status(200).send({
        data: req.body
    });
} catch (error) {
    console.log(error);
    return res.status(500).send(error);
  }
};


exports.setDatabse= async(_db)=>{
    db=_db;
  };