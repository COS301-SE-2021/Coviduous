const admin = require('firebase-admin');
//var serviceAccount = require("../../permissions.json");


//  admin.initializeApp({
//    credential: admin.credential.cert(serviceAccount),
//    databaseURL: "https://fir-api-9a206..firebaseio.com"
// });


const db = admin.firestore();
exports.createFloorPlan = async (req, res) => {
    //(async () => {
        try {
          await db.collection('floorplan').doc(req.body.floorplanNumber)
              .create(req.body); // .add - auto generates document id
          
          return res.status(200).send({
            message: 'floorplan successfully created',
            data: req.body
          });
        } catch (error) {
          console.log(error);
          return res.status(500).send(error);
        }
      //});
  };

  //module.exports = floorplan;