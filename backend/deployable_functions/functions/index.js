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

module.exports = {
    ...require("./controllers/office.controller.js"),
    ...require("./controllers/user.controller.js"),
    ...require("./controllers/shift.controller.js"),
}

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
              const document = database.collection('notifications').doc(reqJson.notificationId); // delete document based on notificationId
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
            const document = database.collection('notifications').where("userEmail", "==", reqJson.userEmail);
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
        const document = database.collection('notifications');
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



app.post('/api/reporting/health/sick-employees', async (req, res) =>  {
   
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

    let sickEmployeeId = "SCK-" + uuid.v4();
    let timestamp = new Date().today() + " @ " + new Date().timeNow();

    let sickEmployeeData = {
        sickEmployeeId: sickEmployeeId,
        userId: reqJson.userId,
        userEmail: reqJson.userEmail,
        timeOfDiagnosis: timestamp,
        companyId: reqJson.companyId
    }

    try {
        await database.collection('sick-employees').doc(sickEmployeeId)
          .create(sickEmployeeData);
          return res.status(200).send({
            message: 'Sick Employee successfully created',
            data: sickEmployeeData
         });
    } catch (error) {
      console.log(error);
        return res.status(500).send({
            message: '500 Server Error: DB error',
            error: error
        });
    }
    





});


app.post('/api/reporting/health/recovered-employees', async (req, res) =>  {
 
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

    try {
        await database.collection('recovered-employees').doc(recoveredData.userId)
          .create(recoveredData);
          return res.status(200).send({
            message: 'Recovered Employee successfully created',
            data: recoveredData
         });
    } catch (error) {
      console.log(error);
        return res.status(500).send({
            message: '500 Server Error: DB error',
            error: error
        });
    }
    



    
});
app.post('/api/reporting/health/recovered-employees/view', async (req, res) =>  {

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

    
    try{
        const document = database.collection('recovered-employees').where("companyId", "==", reqJson.companyId);
        const snapshot = await document.get();
    
        let list =[];
       snapshot.forEach(doc => {
          let data = doc.data();
            list.push(data);
        });
        return res.status(200).send({
            message: 'Successfully retrieved recovered-employees',
            data: list
        });
    
    }catch(error){
        console.log(error);
        return res.status(500).send({message: "Some error occurred while fetching recovered-employees."}); 

    }    


});

app.post('/api/reporting/health/sick-employees/view', async (req, res) =>  {
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

    if (reqJson.companyId == null || reqJson.companyId === '') {
        fieldErrors.push({field: 'companyId', message: 'companyId may not be empty'});
    }

    if (fieldErrors.length > 0) {
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }


    try{
        const document = database.collection('sick-employees').where("companyId", "==", reqJson.companyId);
        const snapshot = await document.get();
    
        let list =[];
       snapshot.forEach(doc => {
          let data = doc.data();
            list.push(data);
        });
        return res.status(200).send({
            message: 'Successfully retrieved sick-employees',
            data: list
        });
    
    }catch(error){
        console.log(error);
        return res.status(500).send({message: "Some error occurred while fetching sick-employees."}); 

    }    
});

app.delete('/api/reporting/health/sick-employees', async (req, res) =>  {
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

    if (reqJson.userId == null || reqJson.userId === '') {
        fieldErrors.push({field: 'userId', message: 'User ID may not be empty'});
    }

    if (fieldErrors.length > 0) {
        console.log(fieldErrors);
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }

    try {
        const document = database.collection('sick-employees').doc(reqJson.userId);
        await document.delete();

        return res.status(200).send({
          message: 'Sick-employees successfully created'
       });
  } catch (error) {
    console.log(error);
      return res.status(500).send({
          message: '500 Server Error: DB error',
          error: error
      });        


    }

});




app.post('/api/reporting/company/company-data', async (req, res) => {
    if (req == null || req.body == null) {
        return res.status(400).send({
            message: '400 Bad Request: Null request object',
        });
    }

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

    if (reqJson.companyId == null || reqJson.companyId === "") {
        fieldErrors.push({field: 'companyId', message: 'Company ID may not be empty'})
    }

    if (fieldErrors.length > 0) {
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }

    let companyData = {
        companyId: reqJson.companyId,
        numberOfRegisteredUsers: "0",
        numberOfRegisteredAdmins: "0",
        numberOfFloorplans: "0",
        numberOfFloors: "0",
        numberOfRooms: "0"
    }

    let response = database.collection('company-data').doc(reqJson.companyId);
        let doc = await response.get();
        let result2 = doc.data()
    
    if (result2 != null) // check if entry exists in database
    {
        return res.status(200).send({
            message: 'Database entry already exists for companyId:' + reqJson.companyId,
        });
    }
    else
    {
        try {
            await database.collection('company-data').doc(companyData.companyId)
              .create(companyData);
              return res.status(200).send({
                message: 'Company Data successfully created',
                data: companyData
             });
        } catch (error) {
          console.log(error);
            return res.status(500).send({
                message: '500 Server Error: DB error',
                error: error
            });
        }
              
    }
});

app.post('/api/reporting/company/company-data/view', async (req, res) =>  {
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

    if (reqJson.companyId == null || reqJson.companyId === '') {
        fieldErrors.push({field: 'companyId', message: 'companyId may not be empty'});
    }

    if (fieldErrors.length > 0) {
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }
      
    let response = database.collection('company-data').doc(reqJson.companyId);
        let doc = await response.get();
        let companyData = doc.data()
    
    if (companyData != null)
    {
        return res.status(200).send({
            message: 'Successfully retrieved company data',
            data: companyData
        });      
    }
    else
    {
        return res.status(500).send({message: "Some error occurred while fetching company data."});
    }
});





app.put('/api/reporting/company/company-data/registered-users', async (req, res) =>  {

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
       
    if(req.body == null) {
        fieldErrors.push({field: null, message: 'Request object may not be null'});
    }

    if (reqJson.companyId == null || reqJson.companyId === '') {
        fieldErrors.push({field: 'companyId', message: 'Company ID may not be empty'});
    }

    if(reqJson.numberOfRegisteredUsers == null || reqJson.numberOfRegisteredUsers === ''){
        fieldErrors.push({field: 'numberOfRegisteredUsers', message: 'Number of registered users may not be empty'});
    }

    if (fieldErrors.length > 0) {
        console.log(fieldErrors);
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }

    try {
        const document = database.collection('company-data').doc(reqJson.companyId);

        await document.update({
            numberOfRegisteredUsers: reqJson.numberOfRegisteredUsers
        });
        return res.status(200).send({
            message: 'Successfully updated company data',
        });
    }catch (error) {
        console.log(error);
          return res.status(500).send({
              message: '500 Server Error: DB error',
              error: error
          });
      }
});


app.put('/api/reporting/company/company-data/registered-admins', async (req, res) =>  {
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
       
    if(req.body == null) {
        fieldErrors.push({field: null, message: 'Request object may not be null'});
    }

    if (reqJson.companyId == null || reqJson.companyId === '') {
        fieldErrors.push({field: 'companyId', message: 'Company ID may not be empty'});
    }

    if(reqJson.numberOfRegisteredAdmins == null || reqJson.numberOfRegisteredAdmins === ''){
        fieldErrors.push({field: 'numberOfRegisteredAdmins', message: 'Number of registered users may not be empty'});
    }

    if (fieldErrors.length > 0) {
        console.log(fieldErrors);
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }

    try {
        const document = database.collection('company-data').doc(reqJson.companyId);

        await document.update({
            numberOfRegisteredAdmins: reqJson.numberOfRegisteredAdmins
        });
        return res.status(200).send({
            message: 'Successfully updated company data',
        });
    }catch (error) {
        console.log(error);
          return res.status(500).send({
              message: '500 Server Error: DB error',
              error: error
          });
      }
});




app.put('/api/reporting/company/company-data/floorplans/inc', async (req, res) =>  {
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
       
    if(req.body == null) {
        fieldErrors.push({field: null, message: 'Request object may not be null'});
    }

    if (reqJson.companyId == null || reqJson.companyId === '') {
        fieldErrors.push({field: 'companyId', message: 'Company ID may not be empty'});
    }

    if (fieldErrors.length > 0) {
        console.log(fieldErrors);
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }
    
    
    let response = database.collection('company-data').doc(reqJson.companyId);
    let doc = await response.get();
    let companyData = doc.data();
    let currentNumFloorplansInCompanyData =companyData.numberOfFloorplans;



    try {
        if (parseInt(currentNumFloorplansInCompanyData) >= 0)
        {
            let newNumFloorplans = parseInt(currentNumFloorplansInCompanyData) + 1;
            newNumFloorplans = newNumFloorplans.toString();

            response = await database.collection('company-data').doc(reqJson.companyId).update({
                numberOfFloorplans: newNumFloorplans
            });
            return res.status(200).send({
                message: "Successfully added number of floorplans",
                //data: req.body
            });
    
        }
    } catch (error) {
        console.log(error);
        return res.status(500).send({message: "Some error occurred while updating number of floorplans."});
        
    }
});


app.put('/api/reporting/company/company-data/floorplans/dec', async (req, res) =>  {
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
       
    if(req.body == null) {
        fieldErrors.push({field: null, message: 'Request object may not be null'});
    }

    if (reqJson.companyId == null || reqJson.companyId === '') {
        fieldErrors.push({field: 'companyId', message: 'Company ID may not be empty'});
    }

    if (fieldErrors.length > 0) {
        console.log(fieldErrors);
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }
    
    let response = database.collection('company-data').doc(reqJson.companyId);
    let doc = await response.get();
    let companyData = doc.data();
    let currentNumFloorplansInCompanyData = companyData.numberOfFloorplans;

    try {
        if (parseInt(currentNumFloorplansInCompanyData) > 0)
        {
            let newNumFloorplans = parseInt(currentNumFloorplansInCompanyData) - 1;
            newNumFloorplans = newNumFloorplans.toString();

            response = await database.collection('company-data').doc(reqJson.companyId).update({
                numberOfFloorplans: newNumFloorplans
            });
            return res.status(200).send({
                message: "Successfully decreased number of floorplans",
                //data: req.body
            });    
        }
    } catch (error) {
        console.log(error);
        return res.status(500).send({message: "Some error occurred while updating number of floorplans."});
    }
});


app.put('/api/reporting/company/company-data/floors/inc', async (req, res) =>  {

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
       
    if(req.body == null) {
        fieldErrors.push({field: null, message: 'Request object may not be null'});
    }

    if (reqJson.companyId == null || reqJson.companyId === '') {
        fieldErrors.push({field: 'companyId', message: 'Company ID may not be empty'});
    }

    if (fieldErrors.length > 0) {
        console.log(fieldErrors);
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }

    
    let response = database.collection('company-data').doc(reqJson.companyId);
    let doc = await response.get();
    let companyData = doc.data();
    let currentNumFloorsInCompanyData = companyData.numberOfFloorplans;

    try {
        if (parseInt(currentNumFloorsInCompanyData) >= 0)
        {
            let newNumFloors = parseInt(currentNumFloorsInCompanyData) + 1;
            newNumFloors = newNumFloors.toString();

            response = await database.collection('company-data').doc(reqJson.companyId).update({
                numberOfFloors: newNumFloors
            });
            return res.status(200).send({
                message: "Successfully added number of floors",
                //data: req.body
            });
            
        }
    } catch (error) {
        console.log(error);
        return res.status(500).send({message: "Some error occurred while updating number of floors."});
    }
    
    });

 app.put('/api/reporting/company/company-data/floors/dec', async (req, res) =>  {    

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
       
    if(req.body == null) {
        fieldErrors.push({field: null, message: 'Request object may not be null'});
    }

    if (reqJson.companyId == null || reqJson.companyId === '') {
        fieldErrors.push({field: 'companyId', message: 'Company ID may not be empty'});
    }

    if (fieldErrors.length > 0) {
        console.log(fieldErrors);
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }
    
    let response = database.collection('company-data').doc(reqJson.companyId);
    let doc = await response.get();
    let companyData = doc.data();
    let currentNumFloorsInCompanyData = companyData.numberOfFloors;

    try {
        if (parseInt(currentNumFloorsInCompanyData) >= 0)
        {
            let newNumFloors = parseInt(currentNumFloorsInCompanyData) - 1;
            newNumFloors = newNumFloors.toString();

            response = await database.collection('company-data').doc(reqJson.companyId).update({
                "numberOfFloors": newNumFloors
            });
            return res.status(200).send({
                message: "Successfully deleted number of floors",
                //data: req.body
            });
            
        }
    } catch (error) {
        console.log(error);
        return res.status(500).send({message: "Some error occurred while updating number of floors."});
    }
});
app.put('/api/reporting/company/company-data/rooms/inc', async (req, res) =>  {    
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
       
    if(req.body == null) {
        fieldErrors.push({field: null, message: 'Request object may not be null'});
    }

    if (reqJson.companyId == null || reqJson.companyId === '') {
        fieldErrors.push({field: 'companyId', message: 'Company ID may not be empty'});
    }

    if (fieldErrors.length > 0) {
        console.log(fieldErrors);
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }
    let response = database.collection('company-data').doc(reqJson.companyId);
    let doc = await response.get();
    let companyData = doc.data();
    let currentNumRoomsInCompanyData = companyData.numberOfRooms;


    try {
        if (parseInt(currentNumRoomsInCompanyData) >= 0)
        {
            let newNumRooms = parseInt(currentNumRoomsInCompanyData) + 1;
            newNumRooms = newNumRooms.toString();

            response = await database.collection('company-data').doc(reqJson.companyId).update({
                "numberOfRooms": newNumRooms
            });
            return res.status(200).send({
                message: "Successfully added number of rooms",
                //data: req.body
            });
            
        }
    } catch (error) {
        console.log(error);
        return res.status(500).send({message: "Some error occurred while updating number of floors."});
    }    
});


app.put('/api/reporting/company/company-data/rooms/dec', async (req, res) =>  {    
    
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
       
    if(req.body == null) {
        fieldErrors.push({field: null, message: 'Request object may not be null'});
    }

    if (reqJson.companyId == null || reqJson.companyId === '') {
        fieldErrors.push({field: 'companyId', message: 'Company ID may not be empty'});
    }

    if (fieldErrors.length > 0) {
        console.log(fieldErrors);
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }
    
    
    let response = database.collection('company-data').doc(reqJson.companyId);
    let doc = await response.get();
    let companyData = doc.data();
    let currentNumRoomsInCompanyData = companyData.numberOfRooms;


    try {
        if (parseInt(currentNumRoomsInCompanyData) >= 0)
        {
            let newNumRooms = parseInt(currentNumRoomsInCompanyData) - 1;
            newNumRooms = newNumRooms.toString();

            response = await database.collection('company-data').doc(reqJson.companyId).update({
                "numberOfRooms": newNumRooms
            });
            return res.status(200).send({
                message: "Successfully deleted number of rooms",
                //data: req.body
            });
            
        }
    } catch (error) {
        console.log(error);
        return res.status(500).send({message: "Some error occurred while updating number of floors."});
    }
});


app.post('/api/reporting/health-summary/setup', async (req, res) =>  {    
    
let reqJson;
      try {
          reqJson = JSON.parse(req.body);
      } catch (e) {
          reqJson = req.body;
      }
    
    // First we get all the health summaries in our database and check if there is an exisiting health summary with
    // our companyId
    
        const document = db.collection('health-summary');
        const snapshot = await document.get();
        
        let list = [];
        
        snapshot.forEach(doc => {
            let data = doc.data();
            list.push(data);
        });
    
    let healthSummaries =list;

    let filteredList=[];   
    healthSummaries.forEach(obj => {
    if(obj.companyId===reqJson.companyId)
          {
            filteredList.push(obj);
          }
          else
          {
    
          }
        });

    if(filteredList.length>0)
    {
        // company was previously initialized no need to re-initilize
        return res.status(200).send({
            message: 'Company Health Summary Already Has An Initial Instance',
        });

    }
    else
    {
        
      //company was never registered before so we setup their health summary table
      let healthSummaryId = "HSID-" + uuid.v4();
      let timestamp = new Date().today() + " @ " + new Date().timeNow();
      let month= timestamp.charAt(3)+timestamp.charAt(4);
      let year= timestamp.charAt(6)+timestamp.charAt(7)+timestamp.charAt(8)+timestamp.charAt(9);

      let healthSummary = {
        healthSummaryId: healthSummaryId,
        month: month,
        year:year,
        timestamp: timestamp,
        companyId: reqJson.companyId,
        numHealthChecksUsers: 0,
        numHealthChecksVisitors: 0,
        numReportedInfections: 0,
        numReportedRecoveries:0
          
        }
        try{
            await db.collection('health-summary').doc(healthSummaryId)
            .create(healthSummary);
             return res.status(200).send({
            message: 'Company Health Summary Successfuly Set',
            data:healthSummary
        });
    } catch (error) {
        console.log(error);
        return res.status(500).send({message: "Some error occurred while setting up the heatlh check."});
    }
 }

});

app.post('/api/reporting/permission-summary/setup', async (req, res) =>  {    
    let reqJson;
      try {
          reqJson = JSON.parse(req.body);
      } catch (e) {
          reqJson = req.body;
      }
    
    // First we get all the permission summaries in our database and check if there is an exisiting permission summary with
    // our companyId
    const document = db.collection('health-summary');
    const snapshot = await document.get();
    
    let list = [];
    
    snapshot.forEach(doc => {
        let data = doc.data();
        list.push(data);
    });

    let permissionSummaries =list;
    
    let filteredList=[];   
    permissionSummaries.forEach(obj => {
    if(obj.companyId===reqJson.companyId)
          {
            filteredList.push(obj);
          }
          else
          {
    
          }
        });

    if(filteredList.length>0)
    {
        // company was previously initialized no need to re-initilize
        return res.status(200).send({
            message: 'Company Permission Summary Already Has An Initial Instance',
        });

    }
    else
    {
        
      //company was never registered before so we setup their permission summary table
      let permissionSummaryId = "PMSN-" + uuid.v4();
      let timestamp = new Date().today() + " @ " + new Date().timeNow();
      let month= timestamp.charAt(3)+timestamp.charAt(4);
      let year= timestamp.charAt(6)+timestamp.charAt(7)+timestamp.charAt(8)+timestamp.charAt(9);

      let permissionSummary = {
        permissionSummaryId: permissionSummaryId,
        month: month,
        year:year,
        timestamp: timestamp,
        companyId: reqJson.companyId,
        numPermissionDeniedUsers: 0,
        numPermissionDeniedVisitors: 0,
        numPermissionGrantedUsers: 0,
        numPermissionGrantedVisitors: 0,
        totalPermissions:0
          
        }
        try{
        await db.collection('permission-summary').doc(permissionSummaryId)
          .create(permissionSummary);
        
        return res.status(200).send({
            message: 'Company Permission Summary Successfuly Set',
            data:permissionSummary
        });
    } catch (error) {
        console.log(error);
        return res.status(500).send({message: "Some error occurred while setting up the heatlh check."});
    }
    
    }
});

app.post('/api/reporting/summary-shifts', async (req, res) =>  {    
    let reqJson;
    try {
        reqJson = JSON.parse(req.body);
    } catch (e) {
        reqJson = req.body;
    }
        const document = db.collection('summary-shifts').where("companyId", "==", companyId);
        const snapshot = await document.get();
  
        let list = [];
        snapshot.forEach(doc => {
            let data = doc.data();
            list.push(data);
        });
        

    let getNumberShift = list;
      
    if (getNumberShift != null) {
      return res.status(200).send({
        message: 'Successfully retrieved number of shifts',
        data: getNumberShift
      });
    } else {
      return res.status(500).send({message: "Some error occurred while fetching number of shifts."});
    }
});
app.post('/api/reporting/summary-bookings', async (req, res) =>  {    

    let reqJson;
    try {
        reqJson = JSON.parse(req.body);
    } catch (e) {
        reqJson = req.body;
    }
        const document = db.collection('summary-bookings').where("companyId", "==", companyId);
        const snapshot = await document.get();
  
        let list = [];
        snapshot.forEach(doc => {
            let data = doc.data();
            list.push(data);
        });
           
    let getNumberBooking = list;
      
    if (getNumberBooking != null) {
      return res.status(200).send({
        message: 'Successfully retrieved number of bookings',
        data: getNumberBooking
      });
    } else {
      return res.status(500).send({message: "Some error occurred while fetching number of bookings."});
    }
});
app.post('/api/reporting/summary-summary', async (req, res) =>  {    
    let reqJson;
      try {
          reqJson = JSON.parse(req.body);
      } catch (e) {
          reqJson = req.body;
      }

      const document = db.collection('health-summary');
      const snapshot = await document.get();
      
      let list = [];
      
      snapshot.forEach(doc => {
          let data = doc.data();
          list.push(data);
      });
  

    let healthSummaries = list;
    
    let filteredList=[];   
    healthSummaries.forEach(obj => {
    if(obj.companyId===reqJson.companyId && reqJson.month===obj.month && reqJson.year==obj.year)
          {
            filteredList.push(obj);
          }
          else
          {
    
          }
        });
    
        if(filteredList.length>0)
        {
            return res.status(200).send({
                message: 'Successfully retrieved health summary',
                data: filteredList
            });
       
         }
        else{
            return res.status(500).send({
                message: 'Problem with either the companId,month or year you requesting for',
            });
        }

});

app.post('/api/reporting/permission-summary', async (req, res) =>  {    

    let reqJson;
      try {
          reqJson = JSON.parse(req.body);
      } catch (e) {
          reqJson = req.body;
      }
      
        const document = db.collection('permission-summary');
        const snapshot = await document.get();
        
        let list = [];
        
        snapshot.forEach(doc => {
            let data = doc.data();
            list.push(data);
        });

    let permissionSummaries = list;
    
    let filteredList=[];   
    permissionSummaries.forEach(obj => {
    if(obj.companyId===reqJson.companyId && reqJson.month===obj.month && reqJson.year==obj.year)
          {
            filteredList.push(obj);
          }
          else
          {
    
          }
        });
    
        if(filteredList.length>0)
        {
            return res.status(200).send({
                message: 'Successfully retrieved permission summary',
                data: filteredList
            });
       
         }
        else{
            return res.status(500).send({
                message: 'Problem with either the companId,month or year you requesting for',
            });
        }

});
















app.get('/api', (req, res) => {
    return res.status(200).send('Connected to the coviduous api');
   });

 exports.app = functions.https.onRequest(app);
