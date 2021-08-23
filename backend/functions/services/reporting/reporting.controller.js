const uuid = require("uuid");

let database;

/**
 * This function sets the database used by the office controller.
 * @param db The database to be used. It can be any interface with CRUD operations.
 */
 exports.setDatabase = async(db) => {
    database = db;
}

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

// functions