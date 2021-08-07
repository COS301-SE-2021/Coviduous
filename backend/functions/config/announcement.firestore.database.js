const functions = require('firebase-functions');
const admin = require('firebase-admin'); 

const db = admin.firestore();

// generate random announcementId number and pass in doc('') before creation

exports.createAnnouncement = async (announcementId, data) => {
    try {
        await db.collection('announcements').doc(announcementId)
          .create(data); // .add - auto generates document id
        return true;
    } catch (error) {
        console.log(error);
        return false;
    }
};

exports.deleteAnnouncement = async (announcementId) => {
    try {
        const document = db.collection('announcements').doc(announcementId); // delete document based on announcementID
        await document.delete();
  
        // return res.status(200).send({
        //     message: 'Announcement successfully deleted'
        // });
        return true;
    } catch (error) {
        console.log(error);
        //return res.status(500).send(error);
        return false;
    }
};

exports.viewAnnouncements = async () => {
    try {
        const document = db.collection('announcements');
        const snapshot = await document.get();
        
        let list = [];
        
        snapshot.forEach(doc => {
            let data = doc.data();
            list.push(data);
        });
    
        let announcements = list;
        
        // return res.json({
        //     message: 'Successfully retrieved announcements',
        //     data: announcements 
        // });
        return announcements;
    } catch (error) {
        console.log(error);
        return error;
        // return res.status(500).send({
        //     message: err.message || "Some error occurred while fetching announcements."
        // });
        // return false;
    }
};