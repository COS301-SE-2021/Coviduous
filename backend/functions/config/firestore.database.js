exports.createFloorPlan = async (floorplanNumber, floorplanData) => { 
    let admin = require('firebase-admin');
    let db = admin.firestore();
    try {
        await db.collection('floorplan').doc(floorplanNumber)
            .create(floorplanData); 
            return true;
      } catch (error) {
        console.log(error);
        return false;
      }
};
