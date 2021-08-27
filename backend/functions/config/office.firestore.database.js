let admin = require('firebase-admin');
let db = admin.firestore();

exports.createBooking = async (data, bookingData) => {
    try {
        let c ="";
        console.log(bookingData.bookingNumber);
         await db.collection('bookings').doc(bookingData.bookingNumber)
            .create(bookingData);
            console.log(data.month);
        const document =  db.collection('summary-bookings').where("month","==",data.month);
        let snapshot = await document.get(); 

       let list = [];

        snapshot.forEach(doc => {
            let d = doc.data();
            list.push(d);
        });
        
        for (const element of list) {
            if(data.month===element.month){
                  //update
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
            //update
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

            
            console.log(summaryId);
            console.log(count)



            const documented = db.collection('summary-bookings').doc(data.month);
            await documented.update({ 
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
        const document = db.collection('bookings').doc(bookingNumber);
        await document.delete();
        return true;
    } catch (error) {
        console.log(error);
        return false;
    }
}