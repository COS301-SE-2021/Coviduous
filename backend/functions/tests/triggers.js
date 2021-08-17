// triggers.js
//var admin = require('firebase-admin');

function create(event) {
  console.log(event.params.uid);
  console.log("Stored Notification Object Into The Mock Database Successfully");
}

function read(event) {
    console.log(event.params.uid);
    console.log("Read Notification Object In The Mock Database Successfully");
  }

function update(event) {
  console.log(event.params.uid);
  console.log("Updated Notification Object In The Mock Database Successfully");
}

function remove(event) {
  console.log(event.params.uid);
  console.log("Removed Notification Object In The Mock Database Successfully");
}

module.exports = {
  create: create,
  read: read,
  update: update,
  remove: remove
}