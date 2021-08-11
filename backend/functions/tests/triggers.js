// triggers.js
//var admin = require('firebase-admin');

function create(event) {
  console.log(event.params.uid);
}

function read(event) {
    console.log(event.params.uid);
  }

function update(event) {
  console.log(event.params.uid);
}

function remove(event) {
  console.log(event.params.uid);
}

module.exports = {
  create: create,
  read: read,
  update: update,
  remove: remove
}