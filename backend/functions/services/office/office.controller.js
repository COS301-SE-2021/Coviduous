let database;

exports.createBooking = async (req, res) => {
        try {
          await database.createBooking(req.body.bookingNumber,req.body);
          
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
            else
            {
    
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