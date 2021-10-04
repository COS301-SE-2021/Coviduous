import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/admin_homepage.dart';
import 'package:frontend/views/health/covid_info_center.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/health/visitor_health_check.dart';
import 'package:frontend/views/health/visitor_view_guidelines.dart';
import 'package:frontend/views/health/visitor_view_permissions.dart';
import 'package:frontend/views/main_homepage.dart';
import 'package:frontend/views/chatbot/app_chatbot.dart';

import 'package:frontend/controllers/health/health_helpers.dart' as healthHelpers;
import 'package:frontend/globals.dart' as globals;

class VisitorHealth extends StatefulWidget {
  static const routeName = "/visitor_health";

  @override
  _VisitorHealthState createState() => _VisitorHealthState();
}

TextEditingController _email = TextEditingController();
final GlobalKey<FormState> _formKey = GlobalKey();

class _VisitorHealthState extends State<VisitorHealth> {
  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(HomePage.routeName);
    return (await true);
  }

  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
    if (globals.loggedInUserType == 'ADMIN') {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
      });
      return Container();
    } else if (globals.loggedInUserType == 'USER') {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.of(context).pushReplacementNamed(UserHomePage.routeName);
      });
      return Container();
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Visitor'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(HomePage.routeName);
              },
            ),
          ),
          bottomNavigationBar: BottomAppBar(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          globals.previousPage = VisitorHealth.routeName;
                          Navigator.of(context).pushReplacementNamed(CovidInformationCenter.routeName);
                        },
                        child: Text('COVID-19 information')
                    )
                  ]
              )
          ),
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/city-silhouette.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Center(
                  child: Column (
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container (
                          alignment: Alignment.center,
                          margin: EdgeInsets.all(20.0),
                          child: Image(
                            alignment: Alignment.center,
                            image: AssetImage('assets/images/logo.png'),
                            color: Colors.white,
                            width: double.maxFinite,
                            height: MediaQuery.of(context).size.height/8,
                          ),
                        ),
                        SizedBox (
                          height: MediaQuery.of(context).size.height/30,
                          width: MediaQuery.of(context).size.width,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width/(2*globals.getWidgetWidthScaling()),
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
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
                                          Expanded(child: Text('Complete health check')),
                                          Icon(
                                            Icons.check,
                                            size: (!globals.getIfOnPC())
                                                ? MediaQuery.of(context).size.width * 0.01 * 5
                                                : MediaQuery.of(context).size.width * 0.01 * 2,
                                          )
                                        ],
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                                        crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pushReplacementNamed(VisitorHealthCheck.routeName);
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
                                          Expanded(child: Text('View permissions')),
                                          Icon(
                                            Icons.zoom_in,
                                            size: (!globals.getIfOnPC())
                                                ? MediaQuery.of(context).size.width * 0.01 * 5
                                                : MediaQuery.of(context).size.width * 0.01 * 2,
                                          )
                                        ],
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                                        crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                                    ),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                                title: Text('Enter your email'),
                                                content: Form(
                                                  key: _formKey,
                                                  child: TextFormField(
                                                    controller: _email,
                                                    decoration: InputDecoration(hintText: 'Enter your email address', filled: true, fillColor: Colors.white),
                                                    validator: (value) {
                                                      if (value.isEmpty) {
                                                        return 'please enter your email address';
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
                                                      FormState form = _formKey.currentState;
                                                      if (form.validate()) {
                                                        healthHelpers.getPermissionsVisitor(_email.text).then((result) {
                                                          _email.clear();
                                                          Navigator.of(context).pushReplacementNamed(VisitorViewPermissions.routeName);
                                                        });
                                                      } else {
                                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid email')));
                                                      }
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
                                          Expanded(child: Text('View company guidelines')),
                                          Icon(
                                            Icons.zoom_in,
                                            size: (!globals.getIfOnPC())
                                                ? MediaQuery.of(context).size.width * 0.01 * 5
                                                : MediaQuery.of(context).size.width * 0.01 * 2,
                                          )
                                        ],
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                                        crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pushReplacementNamed(VisitorViewGuidelines.routeName);
                                    }
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]
                  )
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
                          globals.previousPage = VisitorHealth.routeName;
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