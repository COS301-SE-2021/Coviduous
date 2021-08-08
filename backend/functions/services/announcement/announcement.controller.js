const Announcement = require("../../models/announcement.model");

let database;

exports.setDatabase = async (db) => {
  database = db;
}
  
// exports.createAnnouncement = async (req, res) => {
//   try {
//     await db.collection('announcements').doc(req.body.announcementId)
//         .create(req.body); // .add - auto generates document id
    
//     return res.status(200).send({
//       message: 'Announcement successfully created',
//       data: req.body
//     });
//   } catch (error) {
//     console.log(error);
//     return res.status(500).send(error);
//   }
// };

exports.createAnnouncement = async (req, res) => {
  try {
    let randInt = Math.floor(1000 + Math.random() * 9000);
    let announcementId = "ANNOUNC-" + randInt.toString();
    let timestamp = new Date().toISOString();

    let announcementObj = new Announcement(announcementId, req.body.type,
      req.body.message, timestamp, req.body.companyId, req.body.adminId)

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

// exports.deleteAnnouncement = async (req, res) => {
//   try {
//     const document = db.collection('announcements').doc(req.body.announcementId); // delete document based on announcementID
//     await document.delete();

//     return res.status(200).send({
//       message: 'Announcement successfully deleted'
//     });
//   } catch (error) {
//     console.log(error);
//     return res.status(500).send(error);
//   }
// };

exports.deleteAnnouncement = async (req, res) => {
  try {
    if (await database.deleteAnnouncement(req.body.announcementId) == true)
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

// exports.viewAnnouncements = async (req, res) => {
//   try {
//     const document = db.collection('announcements');
//     const snapshot = await document.get();
    
//     let list = [];
    
//     snapshot.forEach(doc => {
//       let data = doc.data();
//       list.push(data);
//     });

//     let announcements = list;
    
//     return res.json({
//       message: 'Successfully retrieved announcements',
//       data: announcements 
//     });
//   } catch (error) {
//     console.log(error);
//     return res.status(500).send({
//       message: err.message || "Some error occurred while fetching announcements."
//     });
//   }
// };

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

