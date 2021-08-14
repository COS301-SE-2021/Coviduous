let database;

// npm install uuid
const uuid = require("uuid");

/**
 * This function returns the current date in a specified format.
 * @returns {string} The current date as a string in the format DD/MM/YYYY
 */
Date.prototype.today = function () { 
  return ((this.getDate() < 10)?"0":"") + this.getDate() +"/"
      +(((this.getMonth()+1) < 10)?"0":"") + (this.getMonth()+1) +"/"+ this.getFullYear();
}

/**
 * This function returns the current time in a specified format.
 * @returns {string} The current time as a string in the format HH:MM:SS.
 */
Date.prototype.timeNow = function () {
   return ((this.getHours() < 10)?"0":"") + this.getHours() +":"
       + ((this.getMinutes() < 10)?"0":"") + this.getMinutes() +":"
       + ((this.getSeconds() < 10)?"0":"") + this.getSeconds();
}

exports.createBooking = async (req, res) => {
        try {
          let bookingNumber = "BKN-" + uuid.v4();
          let timestamp = "Booking Placed On The : " + new Date().today() + " @ " + new Date().timeNow();
          let bookingData = {
            bookingNumber: bookingNumber,
            deskNumber: req.body.deskNumber,
            floorNumber: req.body.floorNumber,
            roomNumber: req.body.roomNumber,
            timestamp: timestamp,
            userId: req.body.userId
          }
          await database.createBooking(bookingNumber,bookingData);
          
          return res.status(200).send({
            message: 'office booking successfully created',
            data: req.body
          });
        } catch (error) {
          console.log(error);
          return res.status(500).send(error);
        }
    };

exports.deleteBooking = async (req, res) => {
      try {
        if (await database.deleteBooking(req.body.bookingNumber) == true)
        {
          return res.status(200).send({
            message: 'Booking successfully deleted',
          });
        }
      } catch (error) {
        console.log(error);
        return res.status(500).send(error);
      }
    };

    //get bookings using companyid
    exports.viewBookings = async (req, res) => {
      try {
        
          let filteredList=[];
          let bookings = await database.getBookings();
          bookings.forEach(obj => {
            if(obj.userId===req.body.userId)
             {
              filteredList.push(obj);
             }
          });

          return res.status(200).send({
            message: 'Successfully retrieved bookings based on your userId',
            data: filteredList
          });
      } catch (error) {
          console.log(error);
          return res.status(500).send({
            message: err.message || "Some error occurred while fetching bookings."
          });
      }
    };

    exports.setDatabse= async(db)=>{

        database=db;
      }