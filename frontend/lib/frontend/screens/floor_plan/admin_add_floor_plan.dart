import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/backend/controllers/floor_plan_controller.dart';
import 'package:frontend/requests/floor_plan_requests/create_floor_plan_request.dart';
import 'package:frontend/responses/floor_plan_responses/create_floor_plan_response.dart';
import 'package:frontend/frontend/screens/floor_plan/home_floor_plan.dart';
import 'package:frontend/frontend/screens/floor_plan/admin_view_floors.dart';
import 'package:frontend/frontend/screens/user_homepage.dart';
import 'package:frontend/frontend/screens/login_screen.dart';

import 'package:frontend/frontend/front_end_globals.dart' as globals;
import 'package:frontend/backend/backend_globals/floor_globals.dart' as floorGlobals;

class AddFloorPlan extends StatefulWidget {
  static const routeName = "/admin_add_floor_plan";

  @override
  _AddFloorPlanState createState() => _AddFloorPlanState();
}

//add floor plan
class _AddFloorPlanState extends State<AddFloorPlan> {
  String _numFloor;

  FloorPlanController service = new FloorPlanController();

  Widget _buildFloors() {
    return TextFormField(
      textInputAction: TextInputAction
          .done, //The "return" button becomes a "done" button when typing
      decoration: InputDecoration(labelText: 'Enter number of floors'),
      keyboardType: TextInputType.number,
      validator: (String value) {
        int num = int.tryParse(value);
        if (num == null || num <= 0) {
          return 'Number of floors must be greater than zero';
        }
        return null;
      },
      onSaved: (String value) {
        _numFloor = value;
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

    return Scaffold(
      appBar: AppBar(
        title: Text("Add floor plan"),
        leading: BackButton(
          //Specify back button
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(FloorPlanScreen.routeName);
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          //So the element doesn't overflow when you open the keyboard
          child: Container(
            width: MediaQuery.of(context).size.width /
                (2 * globals.getWidgetScaling()),
            color: Colors.white,
            margin: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: _buildFloors()),
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

                          floorGlobals.globalFloors.clear();
                          CreateFloorPlanResponse response = service
                              .createFloorPlanMock(CreateFloorPlanRequest(
                                  globals.loggedInUserId, globals.loggedInCompanyId, int.parse(_numFloor), 0));

                          if (response.getResponse()) {
                            Navigator.of(context).pushReplacementNamed(
                                AdminViewFloors.routeName);
                          } else {
                            showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                      title: Text('Creation unsuccessful'),
                                      content: Text(
                                          'Floor plans must have at least one floor.'),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          child: Text('Okay'),
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                        )
                                      ],
                                    ));
                          }
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
    );
  }
}
