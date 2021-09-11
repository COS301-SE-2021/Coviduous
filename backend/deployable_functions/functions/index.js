let functions = require("firebase-functions");
let admin = require('firebase-admin');
let express = require('express');
let cors = require('cors');
let app = express();
//var serviceAccount = require("./permissions.json");
const authMiddleware = require('./authMiddleWare.js');

app.use(cors({ origin: true }));
app.use(express.urlencoded({ extended: true }));
app.use(express.json());
admin.initializeApp(); 


let database = admin.firestore();
let uuid = require("uuid");

/*module.exports = {
    ...require("./controllers/office.controller.js"),
    ...require("./controllers/shift.controller.js"),
}*/

 //////////////////////////////////////////////////////////////////General Functions ///////////////////////////////////////////////////
 /**
 * This function returns the current date in a specified format.
 * @returns {string} The current date as a string in the format DD/MM/YYYY
 */
  Date.prototype.today = function () { 
    return ((this.getDate() < 10)?"0":"") + this.getDate() + "/" +
        (((this.getMonth()+1) < 10)?"0":"") + (this.getMonth()+1) +"/"+ this.getFullYear();
  }
  
  /**
  * This function returns the current time in a specified format.
  * @returns {string} The current time as a string in the format HH:MM:SS.
  */
  Date.prototype.timeNow = function () {
    return ((this.getHours() < 10)?"0":"") + this.getHours() + ":" +
        ((this.getMinutes() < 10)?"0":"") + this.getMinutes() + ":" +
        ((this.getSeconds() < 10)?"0":"") + this.getSeconds();
  }
  
///////////////////////////////////////////////////////////////// GENERAL FUNCTIONS ////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////// Announcements //////////////////////////////////////////////////////
 /**
 * This function creates a new announcement via an HTTP POST request.
 * req The request object must exist and have the correct fields. It will be denied if not.
 * The request object should contain the following:
 *  type: "GENERAL" || "EMERGENCY"
 *  message: string
 *  adminId: string
 *  companyId: string
 * The response object is sent back to the requester, containing the status code and a message.
 * res - HTTP status indicating whether the request was successful or not.
 */

app.post('/api/announcements',authMiddleware, async (req, res) =>  {
  let reqJson;
  try {
      reqJson = JSON.parse(req.body);
  } catch (e) {
      reqJson = req.body;
  }
  console.log(reqJson);

  let fieldErrors = [];

  if (reqJson.type == null || reqJson.type === '') {
      fieldErrors.push({field: 'type', message: 'Type may not be empty'});
  }

  if (reqJson.type !== 'GENERAL' && reqJson.type !== 'EMERGENCY') {
      fieldErrors.push({field: 'type', message: 'Type must be either GENERAL or EMERGENCY'});
  }

  if (reqJson.message == null || reqJson.message === "") {
      fieldErrors.push({field: 'message', message: 'Message may not be empty'})
  }

  if (reqJson.adminId == null || reqJson.adminId === "") {
      fieldErrors.push({field: 'adminId', message: 'Admin ID may not be empty'})
  }

  if (reqJson.companyId == null || reqJson.companyId === "") {
      fieldErrors.push({field: 'companyId', message: 'Company ID may not be empty'})
  }

  if (fieldErrors.length > 0) {
      console.log(fieldErrors);
      return res.status(400).send({
          message: '400 Bad Request: Incorrect fields',
          errors: fieldErrors
      });
  }

  let announcementId = "ANNOUNC-" + uuid.v4();
  let timestamp = new Date().today() + " " + new Date().timeNow();

  let announcementData = {
      announcementId: announcementId,
      type: reqJson.type,
      message: reqJson.message,
      timestamp: timestamp,
      adminId: reqJson.adminId,
      companyId: reqJson.companyId
  }


  try {
      await database.collection('announcements').doc(announcementId)
        .create(announcementData);
        return res.status(200).send({
          message: 'Announcement successfully created',
          data: announcementData
       });
  } catch (error) {
    console.log(error);
      return res.status(500).send({
          message: '500 Server Error: DB error',
          error: error
      });
  }

});

/**
 * This function gets announcements from a HTTP POST request.
 * req The request object must exist and have the correct fields. It will be denied if not.
 * The request object should contain the following:
 *  companyId: string
 * The response object is sent back to the requester, containing the status code and a message and data.
 * res - HTTP status indicating whether the request was successful or not.
 */
app.post('/api/announcements/view',authMiddleware, async (req, res) =>  {

  let reqJson;
  try {
      reqJson = JSON.parse(req.body);
  } catch (e) {
      reqJson = req.body;
  }
  console.log(reqJson);

  let fieldErrors = [];

  if (reqJson.companyId == null || reqJson.companyId === "") {
    fieldErrors.push({field: 'companyId', message: 'Company ID may not be empty'})
}

if (fieldErrors.length > 0) {
    console.log(fieldErrors);
    return res.status(400).send({
        message: '400 Bad Request: Incorrect fields',
        errors: fieldErrors
    });
}


  try {
    const document = database.collection('announcements');
    const snapshot = await document.get();
  
     let list = [];
  
    snapshot.forEach(doc => {
        let data = doc.data();
        list.push(data);
    });

    let filteredList=[]; 
    list.forEach(obj => {
     if(obj.companyId===reqJson.companyId)
          {
            filteredList.push(obj);
          }
          else
          {
    
          }
        });
    return res.status(200).send({
      message: 'Successfully retrieved announcements',
      data: filteredList
  });

} catch (error) {
  console.log(error);
    return res.status(500).send({
        message: '500 Server Error: DB error',
        error: error
    });
}
});


/**
 * This function deletes an announcement HTTP POST request.
 * req The request object must exist and have the correct fields. It will be denied if not.
 * The request object should contain the following:
 *  announcementId: string
 * The response object is sent back to the requester, containing the status code and a message and data.
 * res - HTTP status indicating whether the request was successful or not.
 */

app.post('/api/announcements/delete', authMiddleware,async (req, res) =>  {

  if (req == null || req.body == null) {
    return res.status(400).send({
        message: '400 Bad Request: Null request object',
    });
}

let reqJson;
try {
    reqJson = JSON.parse(req.body);
} catch (e) {
    reqJson = req.body;
}
console.log(reqJson);

let fieldErrors = [];

if (reqJson.announcementId == null || reqJson.announcementId === "") {
    fieldErrors.push({field: 'announcementId', message: 'Announcement ID may not be empty'});
}

if (fieldErrors.length > 0) {
  console.log(fieldErrors);
    return res.status(400).send({
        message: '400 Bad Request: Incorrect fields',
        errors: fieldErrors
    });
}

try {
    const document = database.collection('announcements').doc(reqJson.announcementId); // delete document based on announcementID
    await document.delete();
    return res.status(200).send({
        message: 'Announcement successfully deleted',
    });
} catch (error) {
    console.log("Error Occured While Trying To Delete The Following Object");
    console.log(error);
    return res.status(500).send({
        message: '500 Server Error: DB error',
        error: error
    });
}



});
////////////////////////////////////////////////////////////////// Announcements //////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////Notification//////////////////////////////////////////////////////////
/**
 * This function creates a new notification via an HTTP POST request.
 * @param req The request object must exist and have the correct fields. It will be denied if not.
 * The request object should contain the following:
 *  userId: string
 *  userEmail: string
 *  subject: string
 *  timestamp: string
 *  message: string
 *  adminId: string
 *  companyId: string
 * @param res The response object is sent back to the requester, containing the status code and a message.
 * @returns res An HTTP status indicating whether the request was successful or not.
 */
 app.post('/api/notifications', async (req, res) =>  {
 // try {
        // data validation
        let fieldErrors = [];
        
        let reqJson;
        try {
            reqJson = JSON.parse(req.body);
        } catch (e) {
            reqJson = req.body;
        }
        console.log(reqJson);


        if(req.body == null) {
            fieldErrors.push({field: null, message: 'Request object may not be null'});
        }

        if (reqJson.userId == null || reqJson.userId === '') {
            fieldErrors.push({field: 'userId', message: 'User ID may not be empty'});
        }

        if (reqJson.userEmail == null || reqJson.userEmail === "") {
            fieldErrors.push({field: 'userEmail', message: 'User email may not be empty'});
        }

        if (reqJson.subject == null || reqJson.subject === "") {
            fieldErrors.push({field: 'subject', message: 'Subject may not be empty'});
        }

        if (reqJson.message == null || reqJson.message === "") {
            fieldErrors.push({field: 'message', message: 'Message may not be empty'});
        }

        if (reqJson.adminId == null || reqJson.adminId === "") {
            fieldErrors.push({field: 'adminId', message: 'Admin ID may not be empty'});
        }

        if (reqJson.companyId == null || reqJson.companyId === "") {
            fieldErrors.push({field: 'companyId', message: 'Company ID may not be empty'});
        }

        if (fieldErrors.length > 0) {
            return res.status(400).send({
                message: '400 Bad Request: Incorrect fields',
                errors: fieldErrors
            });
        }

        let notificationId = "NTFN-" + uuid.v4();
        let timestamp = new Date().toISOString();
    
        let notificationObj = new Notification(notificationId, reqJson.userId, reqJson.userEmail,
            reqJson.subject, reqJson.message, timestamp, reqJson.adminId, reqJson.companyId);
    
        let notificationData = {
          notificationId: notificationId,
          userId: reqJson.userId,
          userEmail: reqJson.userEmail,
          subject: reqJson.subject,
          message: reqJson.message,
          timestamp: timestamp,
          adminId: reqJson.adminId,
          companyId: reqJson.companyId
        }
   
        try {
            await database.collection('notifications').doc(notificationId)
              .create(notificationData);
              return res.status(200).send({
                message: 'Notifications successfully created',
                data: notificationData
             });
        } catch (error) {
          console.log(error);
            return res.status(500).send({
                message: '500 Server Error: DB error',
                error: error
            });
        }
          





   
});
/**
 * This function deletes a specified notification via an HTTP DELETE request.
 * @param req The request object must exist and have the correct fields. It will be denied if not.
 * The request object should contain the following:
 *  notificationId: string
 * @param res The response object is sent back to the requester, containing the status code and a message.
 * @returns res - HTTP status indicating whether the request was successful or not.
 */
 app.delete('/api/notifications', async (req, res) =>  {
    // try {0
        // data validation
        let fieldErrors = [];

        let reqJson;
        try {
            reqJson = JSON.parse(req.body);
        } catch (e) {
            reqJson = req.body;
        }
        console.log(reqJson);

        if(req.body == null) {
            fieldErrors.push({field: null, message: 'Request object may not be null'});
        }

        if (reqJson.notificationId == null || reqJson.notificationId === '') {
            fieldErrors.push({field: 'notificationId', message: 'Notification ID may not be empty'});
        }

        if (fieldErrors.length > 0) {
            return res.status(400).send({
                message: '400 Bad Request: Incorrect fields',
                errors: fieldErrors
            });
        }

        try {
              const document = db.collection('notifications').doc(notificationId); // delete document based on notificationId
              await document.delete();
              return res.status(200).send({
                message: 'Notifications successfully created'
             });
        } catch (error) {
          console.log(error);
            return res.status(500).send({
                message: '500 Server Error: DB error',
                error: error
            });
        }

});

/**
 * This function retrieves all notifications via an HTTP GET request.
 * @param req The request object may be null.
 * @param res The response object is sent back to the requester, containing the status code and retrieved data.
 * @returns res - HTTP status indicating whether the request was successful or not, and data, where applicable.
 */
 app.post('/api/notifications/user-email', async (req, res) =>  {
    // try {
        let fieldErrors = [];

        let reqJson;
        try {
            reqJson = JSON.parse(req.body);
        } catch (e) {
            reqJson = req.body;
        }
        console.log(reqJson);

        if(req.body == null) {
            fieldErrors.push({field: null, message: 'Request object may not be null'});
        }

        if (reqJson.userEmail == null || reqJson.userEmail === '') {
            fieldErrors.push({field: 'userEmail', message: 'User email may not be empty'});
        }

        if (fieldErrors.length > 0) {
            return res.status(400).send({
                message: '400 Bad Request: Incorrect fields',
                errors: fieldErrors
            });
        }

        try {
            const document = db.collection('notifications').where("userEmail", "==", userEmail);
            const snapshot = await document.get();
    
            let list = [];
    
            snapshot.forEach(doc => {
                let data = doc.data();
                list.push(data);
            });
            return res.status(200).send({
                message: '',
                data: list
            });

        } catch (error) {
            console.log(error);
            return error;
        }    
});
/**
 * This function retrieves all notifications via an HTTP GET request.
 * @param req The request object may be null.
 * @param res The response object is sent back to the requester, containing the status code and retrieved data.
 * @returns res - HTTP status indicating whether the request was successful or not, and data, where applicable.
 */
 app.post('/api/notifications', async (req, res) =>  {

    try {
        const document = db.collection('notifications');
        const snapshot = await document.get();

        let list = [];

        snapshot.forEach(doc => {
            let data = doc.data();
            list.push(data);
        });

        return res.status(200).send({
            message: 'Successfully retrieved notifications',
            data: list
        });
        
    } catch (error) {
        console.log(error);
        return res.status(500).send({message: "Some error occurred while fetching notifications."}); 
    }




        
    
});



exports.addSickEmployee = async (req, res) => {
   
    //Look into express.js middleware so that these lines are not necessary
    let reqJson;
    try {
        reqJson = JSON.parse(req.body);
    } catch (e) {
        reqJson = req.body;
    }
    console.log(reqJson);
    //////////////////////////////////////////////////////////////////////

    let fieldErrors = [];

    if (reqJson.userId == null || reqJson.userId === "") {
        fieldErrors.push({field: 'userId', message: 'User ID may not be empty'})
    }

    if (reqJson.userEmail == null || reqJson.userEmail === "") {
        fieldErrors.push({field: 'userEmail', message: 'User email may not be empty'})
    }

    if (reqJson.companyId == null || reqJson.companyId === "") {
        fieldErrors.push({field: 'companyId', message: 'Company ID may not be empty'})
    }

    if (fieldErrors.length > 0) {
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }

    //let sickEmployeeId = "SCK-" + uuid.v4();
    let timestamp = new Date().today() + " @ " + new Date().timeNow();

    let sickEmployeeData = {
        //sickEmployeeId: sickEmployeeId,
        userId: reqJson.userId,
        userEmail: reqJson.userEmail,
        timeOfDiagnosis: timestamp,
        companyId: reqJson.companyId
    }

};
exports.addRecoveredEmployee= async (req,res) =>{
    let reqJson;
    try {
        reqJson = JSON.parse(req.body);
    } catch (e) {
        reqJson = req.body;
    }
    console.log(reqJson);
   
    let fieldErrors = [];

    if (reqJson.userId == null || reqJson.userId === "") {
        fieldErrors.push({field: 'userId', message: 'UserID may not be empty'})
    }

    if (reqJson.userEmail == null || reqJson.userEmail === "") {
        fieldErrors.push({field: 'userEmail', message: 'User email may not be empty'})
    }

    if (reqJson.companyId == null || reqJson.companyId === "") {
        fieldErrors.push({field: 'companyId', message: 'Company ID may not be empty'})
    }

    if (fieldErrors.length > 0) {
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }

    let timestamp = new Date().today() + " @ " + new Date().timeNow();

    let recoveredData = {
        
        userId: reqJson.userId,
        userEmail: reqJson.userEmail,
        recoveredTime: timestamp,
        companyId: reqJson.companyId
    }

    
};
exports.viewRecoveredEmployee = async (req, res) => {

    // data validation
    let fieldErrors = [];

    //Look into express.js middleware so that these lines are not necessary
    let reqJson;
    try {
        reqJson = JSON.parse(req.body);
    } catch (e) {
        reqJson = req.body;
    }
    console.log(reqJson);
    //////////////////////////////////////////////////////////////////////

    if (req.body == null) {
        fieldErrors.push({field: null, message: 'Request object may not be null'});
    }

    if (fieldErrors.length > 0) {
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }

    let viewRecovered = await database.viewRecoveredEmployee(reqJson.companyId);
      
    };




















app.get('/api', (req, res) => {
    return res.status(200).send('Connected to the coviduous api');
   });

 exports.app = functions.https.onRequest(app);
