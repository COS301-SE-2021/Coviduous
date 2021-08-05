const functions = require("firebase-functions");
const admin = require("firebase-admin");
const express = require('express');
const cors = require('cors');
const firebase = require("../mocks/firebase.mock");
const auth0 = require("../mocks/auth0.mock");
const server = require("../mocks/server.mock");

//var serviceAccount = require("../../permissions.json");

const serverRef = server;
const firebaseClient = new firebase();
const auth0Client = new auth0();

class User {
    constructor() {
        console.log("Created user class");
    }

    signIn() {
        auth0Client.signIn();
        console.log("Signed in");
        return true;
    }

    signOut() {
        auth0Client.signOut();
        firebaseClient.signOut();
        console.log("Signed out");
        return true;
    }

    viewNotifications() {
        var message = firebaseClient.getMessage();
        console.log("Message received: " + message);
        return true;
    }
}

module.exports = User;