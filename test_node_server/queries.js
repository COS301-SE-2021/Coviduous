const Pool = require("pg").Pool;

var user = 'postgres';
var database = 'test';
var pass = 'postgres';
var host = 'localhost';
var port = 5432

const pool = new Pool({
	user: user,
	host: host,
	database: database,
	password: pass,
	port: port,
});

//View all users
const getUsers = (req, res) => {
	pool.query('SELECT * FROM users ORDER BY id ASC;', [], function (err, result) {
		if (err) {
			throw err;
		}
		res.json({status: 'OK', message: result.rows});
	});
};

//Add new user to database
const createUser = (req, res) => {
	const name = req.body.name;
	
	pool.query('INSERT INTO users (name) VALUES ($1);', [name], function (err, result) {
		if (err) {
			throw err;
		}
		res.json({status: 'OK', message: 'User added successfully'});
	});
};

module.exports = {
  getUsers,
  createUser,
  host,
  port
}