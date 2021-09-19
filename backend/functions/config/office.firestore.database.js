let admin = require('firebase-admin');
let db = admin.firestore();

exports.createBooking = async (data, bookingData) => {
    try {
        let c ="";
         await db.collection('bookings').doc(bookingData.bookingNumber)
            .create(bookingData);
            
        const document =  db.collection('summary-bookings').where("month","==",data.month);
        let snapshot = await document.get(); 

       let list = [];

        snapshot.forEach(doc => {
            let d = doc.data();
            list.push(d);
        });
        
        for (const element of list) {
            if(data.month===element.month){
                c="checked";  
            }
        }
        if(c==="")
        {
            await db.collection('summary-bookings').doc(data.summaryBookingId)
            .create(data); 
        }
        if(c==="checked")
        {
            const documents =  db.collection('summary-bookings').where("month","==",data.month);
            let s = await documents.get(); 
    
           let lists = [];
    
            s.forEach(doc => {
                let ds = doc.data();
                lists.push(ds);
            });
            
            let summaryId;
            let count;
            for (const elements of lists) {
                
                summaryId = elements.summaryBookingId;
                count =elements.numBookings;

            }

              
            let numBookings = parseInt(count) + 1;
            numBookings = numBookings.toString();
        
            
            const documented = db.collection('summary-bookings').doc(summaryId);
            await documented.update({ 
                numBookings:numBookings
             });

    }    

        return true;
    } catch (error) {
        console.log(error);
        return false;
    }
}

exports.getBookings = async (userId) => {
    try {
        const document = db.collection('bookings').where("userId","==", userId);
        const snapshot = await document.get();

        let list = [];

        snapshot.forEach(doc => {
            let data = doc.data();
            list.push(data);
        });

        return list;
    } catch (error) {
        console.log(error);
        return null;
    }
}

exports.deleteBooking= async (bookingNumber) => {
    try {

        const documents = db.collection('bookings').where("bookingNumber","==",bookingNumber);
        const snapshot = await documents.get();

        let list = [];

        snapshot.forEach(doc => {
            let data = doc.data();
            list.push(data);
        });

        let companyId;

        for (const element of list) {
         companyId = element.companyId;
        }

        const document = db.collection('bookings').doc(bookingNumber);
        await document.delete();

         const doc =   db.collection('summary-bookings').where("companyId","==",companyId) 
         const snap = await doc.get();    
          
         
        let lists = [];

        snap.forEach(docs => {
            let dat = docs.data();
            lists.push(dat);
        });
      
        let numBooking;
        let summaryId;
        for (const element of lists) {
            summaryId = element.summaryBookingId,
            numBooking = element.numBookings;
           }
        
        console.log(numBooking);   
        let numBookings = parseInt(numBooking)-1;
        numBookings = numBookings.toString();   
        
        const documented = db.collection('summary-bookings').doc(summaryId);
            await documented.update({ 
                numBookings:numBookings
             });   
        return true;
    } catch (error) {
        console.log(error);
        return false;
    }
}