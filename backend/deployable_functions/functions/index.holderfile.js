app.get('/api', (req, res) => {
    return res.status(200).send('Connected to the coviduous api');
   });