const Announcement = require("../../models/announcement.model");
const uuid = require("uuid"); // npm install uuid

let database;
// For todays date;
Date.prototype.today = function () { 
  return ((this.getDate() < 10)?"0":"") + this.getDate() +"/"+(((this.getMonth()+1) < 10)?"0":"") + (this.getMonth()+1) +"/"+ this.getFullYear();
}

// For the time now
Date.prototype.timeNow = function () {
   return ((this.getHours() < 10)?"0":"") + this.getHours() +":"+ ((this.getMinutes() < 10)?"0":"") + this.getMinutes() +":"+ ((this.getSeconds() < 10)?"0":"") + this.getSeconds();
}

exports.setDatabase = async (db) => {
  database = db;
}

exports.containsRequiredFieldsForCreateAnnouncement = async (req) => {
   let hasRequiredFields=false;
   if(req.type!=null && req.type!="" && req.message!=null && req.message!="" &&
       req.adminId!=null && req.adminId!="" && req.companyId!=null && req.companyId!="")
   {
     //check if the type is of the correct type "GENERAL OR EMERGENCY"
      if(req.type==="GENERAL"||req.type==="EMERGENCY")
      {
        hasRequiredFields=true;
      }
   }

   return hasRequiredFields;
}

exports.verifyRequestToken = async (token) => {
  let isTokenValid=true;
  
   return isTokenValid;
  
}

exports.verifyCredentials = async (adminId,companyId) => {
  let isCredentialsValid=true;
  
   return isCredentialsValid;
  
}

exports.createAnnouncement = async (req, res) => {
    let reqJson = JSON.parse(req.body);
    console.log(reqJson);

  try {
    if(await this.containsRequiredFieldsForCreateAnnouncement(reqJson)==true)
    {
      //if the req body has the fields we require we can continue to validate what is inside the the 
      if((await this.verifyRequestToken(reqJson)) && (await this.verifyCredentials(reqJson,reqJson)))
      {
        //continue if we have a valid token and valid credentials

      }
      else
    {
        console.log('400 Bad Request : Announcement unsuccessfully created , Invalid Token , Credentials');
      return res.status(400).send({
        message: '400 Bad Request : Announcement unsuccessfully created , Invalid Token , Credentials',
      });

    }

    }
    else
    {
        console.log('400 Bad Request : Announcement unsuccessfully created , Not all fields are correct');
      return res.status(400).send({
        message: '400 Bad Request : Announcement unsuccessfully created , Not all fields are correct',
      });

    }
    let announcementId = "ANNOUNC-" + uuid.v4();
    let timestamp = new Date().today() + " @ " + new Date().timeNow();

    let announcementData = {
      announcementId: announcementId,
      type: reqJson.type,
      message: reqJson.message,
      timestamp: timestamp,
      adminId: reqJson.adminId,
      companyId: reqJson.companyId
    }

    if (await database.createAnnouncement(announcementData.announcementId, announcementData) == true)
    {
      return res.status(200).send({
        message: 'Announcement successfully created',
        data: announcementData
      });
    }
  } catch (error) {
      console.log(error);
      return res.status(500).send(error);
  }
};

exports.deleteAnnouncement = async (req, res) => {
  try {
    let reqJson = JSON.parse(req.body);
    console.log(reqJson);

    if (await database.deleteAnnouncement(reqJson.announcementId) == true)
    {
      return res.status(200).send({
        message: 'Announcement successfully deleted',
      });
    }
  } catch (error) {
    console.log(error);
    return res.status(500).send(error);
  }
};

exports.viewAnnouncements = async (req, res) => {
  try {
      let announcements = await database.viewAnnouncements();
      
      return res.status(200).send({
        message: 'Successfully retrieved announcements',
        data: announcements
      });
  } catch (error) {
      console.log(error);
      return res.status(500).send({
        message: err.message || "Some error occurred while fetching announcements."
      });
  }
};