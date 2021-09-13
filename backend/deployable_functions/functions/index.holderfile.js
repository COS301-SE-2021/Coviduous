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

app.delete('/reporting/health/sick-employees', async (req, res) =>  {
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




app.post('/reporting/company/company-data', async (req, res) => {
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

app.post('/reporting/company/company-data/view', async (req, res) =>  {
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






exports.updateNumberOfRegisteredUsers = async (req, res) => {
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
};

exports.updateNumberOfRegisteredAdmins = async (req, res) => {
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
};

exports.addNumberOfRegisteredUsersCompanyData = async (req, res) => {
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
    let currentNumRegisteredUsersInCompanyData = companyData.numberOfRegisteredUsers;
    
    try{
        if (parseInt(currentNumRegisteredUsersInCompanyData) >= 0)
        {
            let newNumRegisteredUsers = parseInt(currentNumRegisteredUsersInCompanyData) + 1;
            newNumRegisteredUsers = newNumRegisteredUsers.toString();

            response =await database.collection('company-data').doc(reqJson.companyId).update({
                numberOfRegisteredUsers: newNumRegisteredUsers
            });
            return res.status(200).send({
                message: "Successfully added number of registered users",
                //data: req.body
            });
        }
    }catch (error) {
        console.log(error);
        return res.status(500).send({message: "Some error occurred while updating number of registered users."});       
    }
    


};

exports.decreaseNumberOfRegisteredUsersCompanyData = async (req, res) => {
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
    let currentNumRegisteredUsersInCompanyData =companyData.numberOfRegisteredUsers;


    try {
        if (parseInt(currentNumRegisteredUsersInCompanyData) > 0)
        {
            let newNumRegisteredUsers = parseInt(currentNumRegisteredUsersInCompanyData) - 1;
            newNumRegisteredUsers = newNumRegisteredUsers.toString();

             response = await db.collection('company-data').doc(companyId).update({
                numberOfRegisteredUsers: newNumRegisteredUsers
            });
            return res.status(200).send({
                message: "Successfully added number of registered users",
                //data: req.body
            });
  
           
        }
    } catch (error) {
        console.log(error);
        return res.status(500).send({message: "Some error occurred while updating number of registered users."});           
    }
};
exports.addNumberOfRegisteredAdminsCompanyData = async (req, res) => {
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
    let currentNumRegisteredAdminsInCompanyData =companyData.numberOfRegisteredAdmins;

    try {
        if (parseInt(currentNumRegisteredAdminsInCompanyData) >= 0)
        {
            let newNumRegisteredAdmins = parseInt(currentNumRegisteredAdminsInCompanyData) + 1;
            newNumRegisteredAdmins = newNumRegisteredAdmins.toString();

            response = await db.collection('company-data').doc(companyId).update({
                numberOfRegisteredAdmins: newNumRegisteredAdmins
            });
            return res.status(200).send({
                message: "Successfully added number of registered admins",
                //data: req.body
            });
      
            
        }
    } catch (error) {
        console.log(error);
        return res.status(500).send({message: "Some error occurred while updating number of registered admins."});
   
    }
};

exports.decreaseNumberOfRegisteredAdminsCompanyData = async (req, res) => {
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
    let currentNumRegisteredAdminsInCompanyData =companyData.numberOfRegisteredAdmins;

    try {
        if (parseInt(currentNumRegisteredAdminsInCompanyData) > 0)
        {
            let newNumRegisteredAdmins = parseInt(currentNumRegisteredAdminsInCompanyData) - 1;
            newNumRegisteredAdmins = newNumRegisteredAdmins.toString();

            response = await database.collection('company-data').doc(reqJson.companyId).update({
                "numberOfRegisteredAdmins": newNumRegisteredAdmins
            });
            return res.status(200).send({
                message: "Successfully decreased number of registered admins",
                //data: req.body
            });
       

        }
    } catch (error) {
        console.log(error);
        return res.status(500).send({message: "Some error occurred while updating number of registered admins."});
    }


    
};

exports.addNumberOfFloorplansCompanyData = async (req, res) => {
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
};

exports.decreaseNumberOfFloorplansCompanyData = async (req, res) => {
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
};

exports.addNumberOfFloorsCompanyData = async (req, res) => {
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
    
    };

exports.decreaseNumberOfFloorsCompanyData = async (req, res) => {
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
            let newNumFloors = parseInt(currentNumFloorsInCompanyData) - 1;
            newNumFloors = newNumFloors.toString();

            response = await database.collection('company-data').doc(reqJson.companyId).update({
                numberOfFloors: newNumFloors
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
};

















app.get('/api', (req, res) => {
    return res.status(200).send('Connected to the coviduous api');
   });

 exports.app = functions.https.onRequest(app);