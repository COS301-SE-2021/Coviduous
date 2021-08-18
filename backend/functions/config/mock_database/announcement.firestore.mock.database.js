var firebasemock = require('firebase-mock');
var triggers = require('../../tests/triggers.js');
var mockauth = new firebasemock.MockFirebase();
var mockfirestore = new firebasemock.MockFirestore();
var mocksdk = firebasemock.MockFirebaseSdk(null, function() {
    return mockauth;
  }, function() {
    return mockfirestore;
  });
var mockapp = mocksdk.initializeApp();
mockfirestore = new firebasemock.MockFirestore();
mockfirestore.autoFlush();
mockauth = new firebasemock.MockFirebase();
mockauth.autoFlush();

let databucket;

exports.getDataBucket = async () => {
    return databucket;
}

