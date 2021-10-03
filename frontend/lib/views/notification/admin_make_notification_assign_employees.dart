import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:frontend/models/notification/temp_notification.dart';
import 'package:frontend/views/notification/admin_home_notifications.dart';
import 'package:frontend/views/notification/admin_make_notification.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/controllers/notification/notification_helpers.dart' as notificationHelpers;
import 'package:frontend/controllers/user/user_helpers.dart' as userHelpers;
import 'package:frontend/views/global_widgets.dart' as globalWidgets;
import 'package:frontend/globals.dart' as globals;

class MakeNotificationAssignEmployees extends StatefulWidget {
  static const routeName = "/admin_make_notification_employees";
  @override
  _MakeNotificationAssignEmployeesState createState() => _MakeNotificationAssignEmployeesState();
}

class _MakeNotificationAssignEmployeesState extends State<MakeNotificationAssignEmployees> {
  TextEditingController _email = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final String tokenId = "tokenId";

  Future<Response> push_sendNotification(List<String> tokenIdList, String contents, String heading) async {
    return await post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>
      {
        "app_id": "db07da80-4ecf-4f74-9ce8-a8437c6c4c88",// The App Id that one get from the OneSignal When the application is registered.

        "include_player_ids": tokenIdList,//tokenIdList Is the List of All the Token Id to to Whom notification must be sent.

        // android_accent_color represent the color of the heading text in the notification
        "android_accent_color":"FF9976D2",

        "small_icon":"ic_stat_onesignal_default",
        //replace with coviduous icon
        "large_icon":"https://www.filepicker.io/api/file/zPloHSmnQsix82nlj9Aj?filename=name.jpg",

        "headings": {"en": heading},

        "contents": {"en": contents},

      }),
    );
  }

  Future<bool> _onWillPop() async {
    notificationHelpers.getNotifications().then((result){
      if (result == true) {
        Navigator.of(context).pushReplacementNamed(MakeNotification.routeName);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error occurred while retrieving notifications.')));
        Navigator.of(context).pushReplacementNamed(AdminNotifications.routeName);
      }
    });
    return (await true);
  }

  addEmployee() {
    _email.clear();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Enter employee email'),
              content: Form(
                key: _formKey,
                child: TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
                      controller: _email,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        labelText: 'Email',
                      )
                  ),
                  suggestionsCallback: (pattern) {
                    return globals.CurrentEmails.getSuggestions(pattern);
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      tileColor: Colors.white,
                      title: Text(suggestion),
                    );
                  },
                  transitionBuilder: (context, suggestionsBox, controller) {
                    return suggestionsBox;
                  },
                  onSuggestionSelected: (suggestion) {
                    _email.text = suggestion;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter an email';
                    } else {
                      if (!globals.currentEmails.contains(value)) {
                        return 'Invalid email';
                      }
                    }
                    return null;
                  },
                  onSaved: (value) => _email.text = value,
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Submit'),
                  onPressed: () {
                    if (!_formKey.currentState.validate()) {
                      return;
                    }
                    _formKey.currentState.save();
                    print(_email.text);

                    globals.tempUsers.add(new TempNotification("temp", _email.text));
                    setState(() {});
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.pop(context),
                ),
              ]);
        });
  }

  sendNotification(int numOfUsers) {
    if (numOfUsers <= 0) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Not enough employees assigned'),
            content: Text('A notification must have at least one employee assigned to it.'),
            actions: <Widget>[
              TextButton(
                child: Text('Okay'),
                onPressed: (){
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ));
    } else {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Warning'),
            content: Text('Are you sure you are done creating this notification?'),
            actions: <Widget>[
              TextButton(
                child: Text('Yes'),
                onPressed: (){
                  notificationHelpers.createNotifications(globals.tempUsers).then((result){
                    if (result == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Notification successfully sent.")));
                      Navigator.of(context).pushReplacementNamed(AdminNotifications.routeName);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Notification sending unsuccessful.")));
                    }
                  });
                },
              ),
              TextButton(
                child: Text('No'),
                onPressed: (){
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
    if (globals.loggedInUserType != 'ADMIN') {
      if (globals.loggedInUserType == 'USER') {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.of(context).pushReplacementNamed(UserHomePage.routeName);
        });
      } else {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
        });
      }
      return Container();
    }

    int numOfUsers = 0;
    if (globals.tempUsers != null) {
      numOfUsers = globals.tempUsers.length;
    }
    print(numOfUsers);

    Widget getList() {
      if (numOfUsers == 0) { //If the number of users = 0, don't display a list
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height /
                    (5 * globals.getWidgetScaling()),
              ),
              globalWidgets.notFoundMessage(context, 'Notification is empty', 'No employees have been assigned to this notification yet.'),
            ]
        );
      } else {
        //Else create and return a list
        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: numOfUsers,
            itemBuilder: (context, index) {
              //Display a list tile FOR EACH user in users[]
              return ListTile(
                title: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height / 6,
                            child: Image(
                              image: AssetImage('assets/images/placeholder-employee-image.png'),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('User ' + (index + 1).toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: (MediaQuery
                                            .of(context)
                                            .size
                                            .height * 0.01) * 2.5,
                                      )
                                  ),
                                ],
                              ),
                              Container(
                                color: Colors.white,
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
                                                child: Container(
                                                  child: Text(globals.tempUsers[index].getUserEmail()),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width / 48,
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              SizedBox(
                                                height: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .height / 20,
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .height / 20,
                                                child: ElevatedButton(
                                                  child: Text('X',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: (MediaQuery
                                                          .of(context)
                                                          .size
                                                          .height * 0.01) * 2.5,
                                                    ),
                                                  ),
                                                  style: ElevatedButton.styleFrom(
                                                    primary: globals.sixthColor,
                                                  ),
                                                  onPressed: () {
                                                    globals.tempUsers.removeAt(index);
                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ]
                        ),
                      ),
                    ]
                ),
              );
            });
      }
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
          appBar: AppBar(
            title: Text('Assign employees'),
            leading: BackButton( //Specify back button
              onPressed: (){
                notificationHelpers.getNotifications().then((result){
                  if (result == true) {
                    Navigator.of(context).pushReplacementNamed(MakeNotification.routeName);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error occurred while retrieving notifications.')));
                    Navigator.of(context).pushReplacementNamed(AdminNotifications.routeName);
                  }
                });
              },
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            child: (!globals.getIfOnPC()) ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Text('+',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: (MediaQuery.of(context).size.height * 0.01) * 3,
                        ),
                      ),
                      onPressed: () {
                        addEmployee();
                      },
                    )
                ),
              ),
              Expanded(
                child: Container(
                    padding: EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text('Finish'),
                      onPressed: () {
                        List<Map<String, String>> emails = [];
                        for (int i = 0; i < globals.tempUsers.length; i++) {
                          emails.add({"email": globals.tempUsers[i].getUserEmail()});
                        }
                        userHelpers.getTokenIds(emails);
                        push_sendNotification(globals.selectedTokenIds, globals.currentMessageField, globals.currentSubjectField);
                        sendNotification(numOfUsers);
                      },
                    )
                ),
              ),
            ],
          ) : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: Text('+',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: (MediaQuery.of(context).size.height * 0.01) * 3,
                          ),
                        ),
                        onPressed: () {
                          addEmployee();
                        },
                      )
                  ),
                ),
                Expanded(
                  child: Container(
                      padding: EdgeInsets.all(10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Finish',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: (MediaQuery.of(context).size.height * 0.01) * 3,
                          ),
                        ),
                        onPressed: () {
                          sendNotification(numOfUsers);
                          ///push_sendNotification([widget.tokenId],"how are you","Clementine");
                        },
                      )
                  ),
                ),
              ],
            )
          ),
          body: Stack(
              children: <Widget>[
                SingleChildScrollView(
                  child: Center(
                    child: (globals.getIfOnPC())
                        ? Container(
                          width: 640,
                          child: getList(),
                    )
                        : Container(
                          child: getList(),
                    ),
                  ),
                ),
              ]
          )
      ),
    );
  }
}