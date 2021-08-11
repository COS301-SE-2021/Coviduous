import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:frontend/frontend/screens/user_homepage.dart';
import 'package:frontend/frontend/screens/login_screen.dart';
import 'package:frontend/frontend/front_end_globals.dart' as globals;

class AdminContactTraceName extends StatefulWidget {
  static const routeName = "/admin_view_employeeAccess";

  @override
  _AdminContactTraceNameState createState() => _AdminContactTraceNameState();
}
class _AdminContactTraceNameState extends State<AdminContactTraceName> {
 TextEditingController _employeeId = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (globals.loggedInUserType != 'Admin') {
      if (globals.loggedInUserType == 'User') {
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
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Contact trace"),
        leading: BackButton( //Specify back button
          onPressed: (){
          },
        ),
      ),
      body: Center(
        child: new Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height/(4*globals.getWidgetScaling()),
          width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Enter Employee ID/Number",
                ),
                obscureText: false,
                controller: _employeeId,
              ),
              SizedBox(
                height: 16,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom (
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text("Proceed"),
                onPressed: () {
                },
              )

            ],
          ),
        ),
      ),
    );
  }
}
