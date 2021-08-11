// triggers.js
//var admin = require('firebase-admin');

function create(event) {
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
  update: update,
  remove: remove
}