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
                  //update
                c="checked";  

            }
          
        }
        console.log(c);
        if(c==="")
        {
            const documents =  db.collection('summary-bookings').where("month","==",data.month);
            let snapshots = await documents.get(); 

            let lists = [];

            snapshots.forEach(doc => {
            let ds = doc.data();
            lists.push(ds);
        });
        let numBook;
        for (const elements of lists) {

            console.log(elements.numBookings);
            
            numBook = elements.numBookings;
            
            console.log(numBook);
        }
            //create 
            console.log(numBook);
            console.log("Chaks");
            console.log(data.numBookings);
            data.numBookings=numBook+1;
            console.log(data.numBookings);
            await db.collection('summary-bookings').doc(data.companyId)
            .create(data); 
        }
        if(c==="checked")
        {
            //update 
        }    
        
           

        console.log(list.length);    


        
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