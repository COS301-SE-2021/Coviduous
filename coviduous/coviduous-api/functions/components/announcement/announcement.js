const functions = require('firebase-functions');

exports.delete('/api/announcement/delete-announcement', (req, res) => {
    (async () => {
        try {
            const document = db.collection('announcements').doc(req.body.announcementId);
            await document.delete();
            return res.status(200).send();
        } catch (error) {
            console.log(error);
            return res.status(500).send(error);
        }
        })();
    })
  
exports.post('/api/announcement/create-announcement', (req, res) => {
    (async () => {
        try {
          await db.collection('announcements').doc('/' + req.body.id + '/')
              .create({announcents: req.body});
          return res.status(200).send();
        } catch (error) {
          console.log(error);
          return res.status(500).send(error);
        }
      })();
  });
  
  exports.get('/api/announcement/view-announcements', (req, res) => {
    (async () => {
        try {
          if(!req.body.adminId) {
            return res.status(400).send({
                message: "No adminID received"
            });
          }
            const document = db.collection('announcements');
            const snapshot = await document.get();
            
            let list = [];
            snapshot.forEach(doc => {
              let id = doc.id;
              let data = doc.data();
              list.push({id,data});
            });
            //let response = item.data();
            let announce=list;
            return res.json({
              status: 200,
              message: 'Announcements successfully fetched',
              data: announce
          });
        } catch (error) {
            console.log(error);
            return res.status(500).send({
              message: err.message || "Some error occurred while fetching announcements."
          });
        }
        })();
    });