const functions = require("firebase-functions");

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
 exports.helloWorld = functions.https.onRequest((request, response) => {
   functions.logger.info("Hello logs!", {structuredData: true});
   response.send("Hello from Firebase!");
 });

 exports.api = functions.https.onRequest(async (request, response) => {
     switch (request.method) {
         case 'GET':
             //const res= await axios.get()
             response.send("GET REQUEST!");
             break;
        case 'POST':
             response.send("POST REQUEST!");
             break;
        case 'DELETE':
             response.send("DELETE REQUEST!");
             break;
        case 'PUT':
             response.send("PUT REQUEST!");
             break;
     
         default:
            response.send("CANNOT HANDLE THE REQUEST!");
             break;
     }
   
 });

//AUTH FUNCTIONS EVENTS
exports.userAdded = functions.auth.user().onCreate(user =>{
   console.log("User created");
   return Promise.resolve();
 });

 exports.userDeleted = functions.auth.user().onDelete(user =>{
   console.log("User deleted");
   return Promise.resolve();
 });