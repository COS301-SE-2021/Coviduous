library controllers;

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:frontend/models/user/user.dart';
import 'package:frontend/controllers/server_info.dart' as serverInfo;
import 'package:frontend/globals.dart' as globals;

/**
 * List<User> userDatabaseTable acts like a database table that holds users, this is to mock out functionality for testing
 * numUsers keeps track of number of user in the mock user database table
 */
List<User> userDatabaseTable = [];
int numUsers = 0;

/**
 * List<String> emails stores emails retrieved from the database
 * numEmails keeps track of the number of emails
 */
List<String> emails = [];
int numEmails = 0;

String server = serverInfo.getServer(); //server needs to be running on Firebase

/**
 * createUser() : Creates a user and returns whether the operation was successful or not.
 */
Future<bool> createUser(String uid, String type, String firstName, String lastName, String email,
    String userName, String companyId, String companyName, String companyAddress) async {
  String path = 'user/api/users/';
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
    request.headers.addAll(globals.getRequestHeaders());

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
 * createCompany() : Creates a new company.
 */
Future<bool> createCompany(String companyId) async {
  bool result = false;

  String path = 'reporting/api/reporting/health-summary/setup/';
  String url = server + path;
  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "companyId": companyId,
    });
    request.headers.addAll(globals.getRequestHeaders());

    var response = await request.send();

    print(await response.statusCode);

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());

      result = true;
    }
  } catch(error) {
    print(error);
    result = false;
  }

  String path2 = 'reporting/api/reporting/permission-summary/setup/';
  String url2 = server + path2;
  var request2;

  try {
    request2 = http.Request('POST', Uri.parse(url2));
    request2.body = json.encode({
      "companyId": companyId,
    });
    request2.headers.addAll(globals.getRequestHeaders());

    var response2 = await request2.send();

    print(await response2.statusCode);

    if (response2.statusCode == 200) {
      print(await response2.stream.bytesToString());

      result = true;
    }
  } catch(error) {
    print(error);
    result = false;
  }

  String path3 = 'reporting/api/reporting/company/company-data/';
  String url3 = server + path3;
  var request3;

  try {
    request3 = http.Request('POST', Uri.parse(url3));
    request3.body = json.encode({
      "companyId": companyId,
    });
    request3.headers.addAll(globals.getRequestHeaders());

    var response3 = await request3.send();

    print(await response3.statusCode);

    if (response3.statusCode == 200) {
      print(await response3.stream.bytesToString());

      result = true;
    }
  } catch(error) {
    print(error);
    result = false;
  }

  return result;
}

/**
 * getUsers() : Returns a list of all users.
 */
Future<List<User>> getUsers() async {
  String path = 'user/api/users/';
  String url = server + path;
  var response;

  try {
    response = await http.get(Uri.parse(url), headers: globals.getRequestHeaders());

    if (response.statusCode == 200) {
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
  String path = 'user/api/users/user-id/';
  String url = server + path;
  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "userId": userId,
    });
    request.headers.addAll(globals.getRequestHeaders());

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
  String path = 'user/api/users/email/';
  String url = server + path;
  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "email": email,
    });
    request.headers.addAll(globals.getRequestHeaders());

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
 * getEmailsByCompany() : Gets all user emails for a specified company.
 */
Future<List<String>> getEmailsByCompany(String companyId) async {
  String path = 'shift/api/group/company-id/';
  String url = server + path;
  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "companyId": companyId,
    });
    request.headers.addAll(globals.getRequestHeaders());

    var response = await request.send();

    if (response.statusCode == 200) {
      var jsonString = (await response.stream.bytesToString());
      var jsonMap = jsonDecode(jsonString);

      //Added these lines so that it doesn't just keep adding and adding to the list indefinitely everytime this function is called
      emails.clear();
      numEmails = 0;

      for (var data in jsonMap["data"]) {
        var userData = User.fromJson(data);
        emails.add(userData.getEmail());
        numEmails++;
      }

      return emails;
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
  String path = 'user/api/users/';
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
    request.headers.addAll(globals.getRequestHeaders());

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
  String path = 'user/api/users/';
  String url = server + path;
  var request;

  try {
    request = http.Request('DELETE', Uri.parse(url));
    request.body = json.encode({
      "userId": globals.loggedInUserId,
    });
    request.headers.addAll(globals.getRequestHeaders());

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