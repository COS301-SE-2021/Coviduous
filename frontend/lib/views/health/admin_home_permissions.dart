import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/health/admin_contact_trace_shifts.dart';
import 'package:frontend/views/health/admin_employee_permissions.dart';
import 'package:frontend/views/admin_homepage.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';
import 'package:frontend/views/health/admin_view_access_requests.dart';
import 'package:frontend/views/chatbot/app_chatbot.dart';

import 'package:frontend/controllers/reporting/reporting_helpers.dart' as reportingHelpers;
import 'package:frontend/controllers/user/user_controller.dart' as userController;
import 'package:frontend/controllers/user/user_helpers.dart' as userHelpers;
import 'package:frontend/controllers/health/health_helpers.dart' as healthHelpers;
import 'package:frontend/globals.dart' as globals;

class AdminPermissions extends StatefulWidget {
  static const routeName = "/admin_permissions_home";

  @override
  _AdminPermissionsState createState() => _AdminPermissionsState();
}

TextEditingController _email = TextEditingController();
final GlobalKey<FormState> _formKey = GlobalKey();

class _AdminPermissionsState extends State<AdminPermissions> {
  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
    return (await true);
  }

  @override
  Widget build(BuildContext context) {
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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Health permissions'),
          leading: BackButton( //Specify back button
            onPressed: (){
              Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
            },
          ),
        ),
          bottomNavigationBar: BottomAppBar(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          globals.previousPage = AdminPermissions.routeName;
                        },
                        child: Text('COVID-19 information')
                    )
                  ]
              )
          ),
        body: Stack(
          children: [
        SingleChildScrollView(
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width/(2*globals.getWidgetWidthScaling()),
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                      Icons.vpn_key,
                      color: Colors.white,
                      size: (globals.getIfOnPC())
                          ? MediaQuery.of(context).size.width/8
                          : MediaQuery.of(context).size.width/4
                  ),
                  SizedBox (
                    height: MediaQuery.of(context).size.height/30,
                    width: MediaQuery.of(context).size.width,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height/16,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton (
                        style: ElevatedButton.styleFrom (
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row (
                            children: <Widget>[
                              Expanded(child: Text('View permissions')),
                              Icon(Icons.zoom_in)
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                            crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                        ),
                        onPressed: () {
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
                                          healthHelpers.getPermissionsForEmployee(_email.text).then((result) {
                                            if (result == true) {
                                              userHelpers.getOtherUser(globals.currentPermissions[0].getUserId()).then((result) {
                                                if (result == true) {
                                                  Navigator.of(context).pushReplacementNamed(EmployeePermissions.routeName);
                                                } else {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(content: Text("No permissions found for this user.")));
                                                }
                                              });
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text("There was an error while retrieving user permissions. Please try again later.")));
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
                    ),
                  ),
                  SizedBox (
                    height: MediaQuery.of(context).size.height/30,
                    width: MediaQuery.of(context).size.width,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height/16,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton (
                        style: ElevatedButton.styleFrom (
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row (
                            children: <Widget>[
                              Expanded(child: Text('Grant permissions')),
                              Icon(Icons.add_alert)
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                            crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                        ),
                        onPressed: () {
                          userController.getUsers().then((result) {
                            if (result != null) {
                              globals.selectedUsers = result;
                              healthHelpers.getPermissionRequests().then((result) {
                                if (result == true) {
                                  Navigator.of(context).pushReplacementNamed(AdminViewAccessRequests.routeName);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("There was an error while retrieving permission requests. Please try again later.")));
                                }
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("There was an error while retrieving permission requests. Please try again later.")));
                            }
                          });
                        }
                    ),
                  ),
                  SizedBox (
                    height: MediaQuery.of(context).size.height/30,
                    width: MediaQuery.of(context).size.width,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height/16,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton (
                        style: ElevatedButton.styleFrom (
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row (
                            children: <Widget>[
                              Expanded(child: Text('Set employee recovery status')),
                              Icon(Icons.medical_services)
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                            crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                        ),
                        onPressed: () {
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
                                          reportingHelpers.addRecoveredEmployee(_email.text).then((result) {
                                            if (result == true) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text("Employee's status set to recovered successfully.")));
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text("An error occurred while setting employee status. Please try again later.")));
                                            }
                                            Navigator.pop(context);
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
                    ),
                  ),
                  SizedBox (
                    height: MediaQuery.of(context).size.height/30,
                    width: MediaQuery.of(context).size.width,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height/16,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton (
                        style: ElevatedButton.styleFrom (
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row (
                            children: <Widget>[
                              Expanded(child: Text('Contact trace')),
                              Icon(Icons.search)
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                            crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                        ),
                        onPressed: () {
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
                                              Navigator.of(context).pushReplacementNamed(AdminContactTraceShifts.routeName);
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
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
            Container(
              alignment: Alignment.bottomRight,
              child: Align(
                heightFactor: 0.8,
                widthFactor: 0.8,
                child: ClipRect(
                  child: AvatarGlow(
                    startDelay: Duration(milliseconds: 1000),
                    glowColor: Colors.white,
                    endRadius: 60,
                    duration: Duration(milliseconds: 2000),
                    repeat: true,
                    showTwoGlows: true,
                    repeatPauseDuration: Duration(milliseconds: 100),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: CircleBorder(),
                      ),
                      child: ClipOval(
                        child: Image(
                          image: AssetImage('assets/images/chatbot-icon.png'),
                          width: 70,
                        ),
                      ),
                      onPressed: () {
                        globals.previousPage = AdminPermissions.routeName;
                        Navigator.of(context).pushReplacementNamed(ChatMessages.routeName);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}