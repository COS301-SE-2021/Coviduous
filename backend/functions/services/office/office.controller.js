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

    exports.setDatabse= async(db)=>{

        database=db;
      }