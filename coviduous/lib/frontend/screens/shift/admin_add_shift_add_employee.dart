import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:coviduous/backend/controllers/shift_controller.dart';
import 'package:coviduous/frontend/screens/shift/admin_add_shift_assign_employees.dart';
import 'package:coviduous/frontend/screens/user_homepage.dart';
import 'package:coviduous/frontend/screens/login_screen.dart';

import 'package:coviduous/frontend/front_end_globals.dart' as globals;

class AddShiftAddEmployee extends StatefulWidget {
  static const routeName = "/admin_add_shift_add_employee";

  @override
  _AddShiftAddEmployeeState createState() => _AddShiftAddEmployeeState();
}

class _AddShiftAddEmployeeState extends State<AddShiftAddEmployee> {
  String _employeeEmail = "";

  ShiftController services = new ShiftController();

  Widget _buildEmail() {
    return TextFormField(
      textInputAction: TextInputAction.done, //The "return" button becomes a "done" button when typing
      decoration: InputDecoration(labelText: 'Enter employee email address'),
      keyboardType: TextInputType.number,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Please enter this field';
        } else if (value.isNotEmpty) {
          if(!value.contains('@'))
          {
            return 'invalid email format';
          }
        }
        return null;
      },
      onSaved: (String value) {
        _employeeEmail = value;
      },
    );
  }

//global key _formkey.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
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

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, //To show background image
        appBar: AppBar(
          title: Text("Add employee"),
          leading: BackButton(
            //Specify back button
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(AddShiftAssignEmployees.routeName);
            },
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            //So the element doesn't overflow when you open the keyboard
            child: Container(
              width: MediaQuery.of(context).size.width / (2 * globals.getWidgetScaling()),
              color: Colors.white,
              margin: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: _buildEmail()),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 48,
                        width: MediaQuery.of(context).size.width,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text('Proceed'),
                          onPressed: () {
                            if (!_formKey.currentState.validate()) {
                              return;
                            }
                            _formKey.currentState.save();
                            print(_employeeEmail);

                            services.addToTempGroup(globals.currentGroupNum, globals.currentGroupNum, globals.currentGroupDescription, _employeeEmail, globals.currentFloorNum, globals.currentRoomNum, globals.loggedInUserId, globals.currentShiftNum);

                            Navigator.of(context).pushReplacementNamed(AddShiftAssignEmployees.routeName);
                          }),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 48,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}