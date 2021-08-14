const Shift = require("../../models/shift.model");
const uuid = require("uuid");

let db;
/**
 * This function creates a shift for the employee.
 * This function stores the shift in the database.
 * @returns status which will tell if the creation of the shift was successful/unsuccessful.
 */

exports.setDatabse = async(_db) => {
    db =_db;
};

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

/**
 * This function deletes a specified shift via an HTTP DELETE request.
 * @param req The request object must exist and have the correct fields. It will be denied if not.
 * The request object should contain the following:
 *  shiftId: string
 * @param res The response object is sent back to the requester, containing the status code and a message.
 * @returns res - HTTP status indicating whether the request was successful or not.
 */
exports.deleteShift = async (req, res) => {
  // try {
      // data validation
      let fieldErrors = [];

      if(req.body == null) {
          fieldErrors.push({field: null, message: 'Request object may not be null'});
      }

      if (reqJson.shiftID == null || reqJson.shiftID === '') {
          fieldErrors.push({field: 'shiftID', message: 'Shift ID may not be empty'});
      }

      if (fieldErrors.length > 0) {
          return res.status(400).send({
              message: '400 Bad Request: Incorrect fields',
              errors: fieldErrors
          });
      }

      if (await db.deleteShift(req.body.shiftID) == true)
      {
          return res.status(200).send({
              message: "Shift successfully deleted"
          });
      }
      else
      {
          return res.status(500).send({message: "500 server error."});
      }
  // } catch (error) {
  //     console.log(error);
  //     return res.status(500).send(error);
  // }
};

/**
 * This function updates a specified shift via an HTTP UPDATE request.
 * @param req The request object must exist and have the correct fields. It will be denied if not.
 * The request object should contain the following:
 *  shiftId: string
 * @param res The response object is sent back to the requester, containing the status code and a message.
 * @returns res - HTTP status indicating whether the request was successful or not.
 */
exports.updateShift = async (req, res) => {
  // try {
    // data validation
    let fieldErrors = [];

    if(req.body == null) {
        fieldErrors.push({field: null, message: 'Request object may not be null'});
    }

    if (reqJson.shiftID == null || reqJson.shiftID === '') {
        fieldErrors.push({field: 'shiftID', message: 'Shift ID may not be empty'});
    }

    if (fieldErrors.length > 0) {
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }

    if (await db.updateShift(req.body.shiftID, req.body) == true)
    {
      return res.status(200).send({
        data: req.body
      });
    }
    else
    {
      return res.status(500).send({message: "Some error occurred while updating shifts."});
    }
    
  // } catch (error) {
  //   console.log(error);
  //   console.log(req.body.shiftID);
  //   console.log(req.body);
  //   return res.status(500).send(error);
  // }

};

/**
 * This function retrieves all shifts via an HTTP GET request.
 * @param req The request object may be null.
 * @param res The response object is sent back to the requester, containing the status code and retrieved data.
 * @returns res - HTTP status indicating whether the request was successful or not, and data, where applicable.
 */
exports.viewShifts = async (req, res) => {
  // try {
      let viewShifts = await db.viewShifts(); 
      
      if (viewShifts != null)
      {
        return res.status(200).send({
          message: 'Successfully retrieved shifts',
          data: viewShifts
        });
      }
      else
      {
        return res.status(500).send({message: "Some error occurred while fetching shifts."});
      }
  // } catch (error) {
  //     console.log(error);
  //     return res.status(500).send({
  //       message: err.message 
  //     });
  // }
};