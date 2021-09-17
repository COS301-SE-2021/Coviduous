// Chatbot controller
library controllers;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/models/chatbot/chatbot_response.dart';

import 'package:frontend/globals.dart' as globals;
import 'package:frontend/controllers/announcement/announcement_helpers.dart' as announcementHelpers;
import 'package:frontend/controllers/floor_plan/floor_plan_helpers.dart' as floorPlanHelpers;
import 'package:frontend/controllers/health/health_helpers.dart' as healthHelpers;
import 'package:frontend/controllers/notification/notification_helpers.dart' as notificationHelpers;
import 'package:frontend/controllers/office/office_helpers.dart' as officeHelpers;
import 'package:frontend/controllers/server_info.dart' as serverInfo;

String chatbotServer = serverInfo.getChatbotServer();

Future<ChatbotResponse> sendAndReceive(String message) async {
  String url = chatbotServer;
  var request;

  try {
    request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "question": message
    });
    request.headers.addAll(globals.getRequestHeaders());

    var response = await request.send();

    print(await response.statusCode);

    if (response.statusCode == 200) {
      var jsonString = (await response.stream.bytesToString());
      var jsonMap = jsonDecode(jsonString);

      print(jsonMap);

      return ChatbotResponse.fromJson(jsonMap);
    }
  } catch(error) {
    print(error);
  }

  return null;
}

void navigateShortcut(BuildContext context, String shortcutRoute) {
  if (globals.loggedInUserType == 'ADMIN') {
    switch (shortcutRoute) {
      case '/admin_announcements': {
        announcementHelpers.getAnnouncements().then((result) {
          _checkResult(context, shortcutRoute, result);
        });
      }
      break;

      case '/admin_make_announcement':
      case '/admin_add_floor_plan':
      case '/admin_make_notification':
      case '/reporting': {
        Navigator.of(context).pushReplacementNamed(shortcutRoute);
      }
      break;

      case '/admin_view_notifications': {
        notificationHelpers.getNotifications().then((result) {
          _checkResult(context, shortcutRoute, result);
        });
      }
      break;

      case '/admin_modify_floor_plans':
      case '/admin_add_shift_floor_plans':
      case '/admin_view_shifts_floor_plans': {
        floorPlanHelpers.getFloorPlans().then((result) {
          _checkResult(context, shortcutRoute, result);
        });
      }
      break;

      case '/admin_contact_trace_shifts': {
        TextEditingController _email = TextEditingController();
        final GlobalKey<FormState> _formKey = GlobalKey();

        showDialog(
            context: context,
            builder: (context) {
              _email.clear();
              return AlertDialog(
                  title: Text('Enter employee email'),
                  content: Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _email,
                      decoration: InputDecoration(hintText: 'Enter employee email', filled: true, fillColor: Colors.white),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'please enter an email address';
                        } else if (value.isNotEmpty) {
                          if (!value.contains('@')) {
                            return 'invalid email';
                          }
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        _email.text = value;
                      },
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: Text('Submit'),
                      onPressed: () {
                        healthHelpers.viewShifts(_email.text).then((result) {
                          if (result == true) {
                            globals.selectedUserEmail = _email.text;
                            Navigator.of(context).pushReplacementNamed(shortcutRoute);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("An error occurred while retrieving employee shifts. Please try again later.")));
                            Navigator.of(context).pop();
                          }
                        });
                      },
                    ),
                    TextButton(
                      child: Text('Cancel'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ]);
            });
      }
      break;

      default: {
        _showErrorMessage(context, 'You do not have access to this page.');
      }
      break;
    }
  } else if (globals.loggedInUserType == "USER") {
    switch (shortcutRoute) {
      case '/user_announcements': {
        announcementHelpers.getAnnouncements().then((result) {
          _checkResult(context, shortcutRoute, result);
        });
      }
      break;

      case '/user_upload_test_result':
      case '/user_upload_vaccine_confirm':
      case '/user_health':
      case '/user_health_check':
      case '/user_report_infection': {
        Navigator.of(context).pushReplacementNamed(shortcutRoute);
      }
      break;

      case '/user_view_permissions': {
        healthHelpers.getPermissionsUser().then((result) {
          _checkResult(context, shortcutRoute, result);
        });
      }
      break;

      case '/user_view_notifications': {
        notificationHelpers.getNotifications().then((result) {
          _checkResult(context, shortcutRoute, result);
        });
      }
      break;

      case '/user_office_floor_plans': {
        floorPlanHelpers.getFloorPlans().then((result) {
          _checkResult(context, shortcutRoute, result);
        });
      }
      break;

      case '/user_view_bookings': {
        officeHelpers.getBookings().then((result) {
          _checkResult(context, shortcutRoute, result);
        });
      }
      break;

      default: {
        _showErrorMessage(context, 'You do not have access to this page.');
      }
      break;
    }
  } else {
    if (shortcutRoute == '/visitor_health_check') {
      Navigator.of(context).pushReplacementNamed(shortcutRoute);
    } else {
      _showErrorMessage(context, 'You do not have access to this page.');
    }
  }
}

void _checkResult(BuildContext context, String shortcutRoute, bool result) {
  if (result == true) {
    Navigator.of(context).pushReplacementNamed(shortcutRoute);
  } else {
    _showErrorMessage(context, 'An error occurred while trying to access this page. Please try again later.');
  }
}

void _showErrorMessage(BuildContext context, String message) {
  showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: (){
              Navigator.of(ctx).pop();
            },
          )
        ],
      )
  );
}