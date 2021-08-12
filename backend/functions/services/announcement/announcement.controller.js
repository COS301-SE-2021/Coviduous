const Announcement = require("../../models/announcement.model");
const uuid = require("uuid"); // npm install uuid

let database;

exports.setDatabase = async (db) => {
  database = db;
}

exports.createAnnouncement = async (req, res) => {
  try {
    let announcementId = "ANNOUNC-" + uuid.v4();
    let timestamp = new Date().toISOString();

    let reqJson = JSON.parse(req.body);
    console.log(reqJson);

    let announcementObj = new Announcement(announcementId, reqJson.type,
      reqJson.message, timestamp, reqJson.adminId, reqJson.companyId)

    let announcementData = {
      announcementId: announcementObj.announcementId,
      type: announcementObj.type,
      message: announcementObj.message,
      timestamp: announcementObj.timestamp,
      adminId: announcementObj.adminId,
      companyId: announcementObj.companyId
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

