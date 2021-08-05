const functions = require("firebase-functions");
const admin = require("firebase-admin");
const express = require('express');
const cors = require('cors');
const firebase = require("../../services/user/firebase");
const auth0 = require("../../services/user/auth0");
const server = require("../../services/user/server");

var serviceAccount = require("../../permissions.json");

const serverRef = new server();
const firebaseClient = new firebase();
const auth0Client = new auth0();

class User {
    constructor() {
        console.log("created user class");
    }

    signIn() {
        auth0Client.signIn();
        console.log("signed in");
        return true;
    }

    signOut() {
        auth0Client.signOut();
        firebaseClient.signOut();
        console.log("signed out");
        return true;
    }

    viewNotifications() {
        var message = firebaseClient.getMessage();
        console.log("message received: " + message);
        return true;
    }
}

module.exports = User;