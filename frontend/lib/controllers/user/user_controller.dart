// Shift controller
library controllers;

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:frontend/models/user/user.dart';
import 'package:frontend/controllers/server_info.dart' as serverInfo;
import 'package:frontend/globals.dart' as globals;

/**
 * List<User> userDatabaseTable acts like a database table that holds users, this is to mock out functionality for testing
 * numUsers keeps track of number of announcements in the mock announcement database table
 */
List<User> userDatabaseTable = [];
int numUsers = 0;

String server = serverInfo.getServer(); //server needs to be running on Firebase

/**
 * createUser() : Creates a user and returns whether the operation was successful or not.
 */
Future<bool> createUser(String uid, String type, String firstName, String lastName, String email,
    String userName, String companyId, String companyName, String companyAddress) async {
  String path = 'users';
  String url = server + path;
  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "userId": uid,
      "type": type.toUpperCase(),
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "userName": userName,
      "companyId": companyId,
      "companyName": companyName,
      "companyAddress": companyAddress,
    });
    request.headers.addAll(globals.requestHeaders);

    var response = await request.send();

    print(await response.statusCode);

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());

  return true;
  }
  } catch (error) {
  print(error);
  }

  return false;
}

/**
 * getUsers() : Returns a list of all users.
 */
Future<List<User>> getUsers() async {
  String path = '/users';
  String url = server + path;
  var response;

  try {
    response = await http.get(Uri.parse(url), headers: globals.requestHeaders);

    if (response.statusCode == 200) {
      //print(response.body);

      var jsonString = response.body;
      var jsonMap = jsonDecode(jsonString);

      //Added these lines so that it doesn't just keep adding and adding to the list indefinitely everytime this function is called
      userDatabaseTable.clear();
      numUsers = 0;

      for (var data in jsonMap["data"]) {
        var userData = User.fromJson(data);
        userDatabaseTable.add(userData);
        numUsers++;
      }

      return userDatabaseTable;
    }
  } catch (error) {
    print(error);
  }

  return null;
}

/**
 * getUser() : Returns a single user.
 */
Future<User> getUserDetails(String userId) async {
  String path = '/users/user-id';
  String url = server + path;
  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "userId": userId,
    });
    request.headers.addAll(globals.requestHeaders);
    print(request.body);

    var response = await request.send();

    if (response.statusCode == 200) {
      var jsonString = (await response.stream.bytesToString());
      var jsonMap = jsonDecode(jsonString);

      //Added these lines so that it doesn't just keep adding and adding to the list indefinitely everytime this function is called
      userDatabaseTable.clear();
      numUsers = 0;

      for (var data in jsonMap["data"]) {
        var userData = User.fromJson(data);
        userDatabaseTable.add(userData);
        numUsers++;
      }

      return userDatabaseTable.first;
    }
  } catch (error) {
    print(error);
  }

  return null;
}

/**
 * getUserDetailsByEmail() : Returns a single user using their email.
 */
Future<User> getUserDetailsByEmail(String email) async {
  String path = '/users/email';
  String url = server + path;
  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "email": email,
    });
    request.headers.addAll(globals.requestHeaders);
    print(request.body);

    var response = await request.send();

    if (response.statusCode == 200) {
      var jsonString = (await response.stream.bytesToString());
      var jsonMap = jsonDecode(jsonString);

      //Added these lines so that it doesn't just keep adding and adding to the list indefinitely everytime this function is called
      userDatabaseTable.clear();
      numUsers = 0;

      for (var data in jsonMap["data"]) {
        var userData = User.fromJson(data);
        userDatabaseTable.add(userData);
        numUsers++;
      }

      return userDatabaseTable.first;
    }
  } catch (error) {
    print(error);
  }

  return null;
}

/**
 * updateUser() : Updates a user's details in the database.
 */
Future<bool> updateUser(String type, String firstName, String lastName, String email,
    String userName, String companyName, String companyAddress) async {
  String path = 'users';
  String url = server + path;
  var request;

  try {
    request = http.Request('PUT', Uri.parse(url));
    request.body = json.encode({
      "userId": globals.loggedInUserId,
      "type": type.toUpperCase(),
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "userName": userName,
      "companyName": companyName,
      "companyAddress": companyAddress,
    });
    request.headers.addAll(globals.requestHeaders);

    var response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());

      return true;
    }
  } catch (error) {
    print(error);
  }

  return false;
}

/**
 * deleteUser() : Deletes a user based on their user ID.
 */
Future<bool> deleteUser() async {
  String path = 'users';
  String url = server + path;
  var request;

  try {
    request = http.Request('DELETE', Uri.parse(url));
    request.body = json.encode({
      "userId": globals.loggedInUserId,
    });
    request.headers.addAll(globals.requestHeaders);

    var response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());

      return true;
    }
  } catch (error) {
    print(error);
  }

  return false;
}