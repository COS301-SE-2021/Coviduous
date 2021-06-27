import 'package:flutter/material.dart';

import 'package:login_app/backend/controllers/floor_plan_controller.dart';
import 'package:login_app/requests/floor_plan_requests/create_floor_plan_request.dart';
import 'package:login_app/responses/floor_plan_responses/create_floor_plan_response.dart';
import 'package:login_app/frontend/screens/home_floor_plan.dart';
import 'package:login_app/frontend/screens/admin_view_floors.dart';

import 'package:login_app/frontend/front_end_globals.dart' as globals;
import 'package:login_app/backend/backend_globals/floor_globals.dart' as floorGlobals;

class AddFloorPlan extends StatefulWidget {
  static const routeName = "/admin_add_floor_plan";

  @override
  _AddFloorPlanState createState() => _AddFloorPlanState();
}
//add floor plan
class _AddFloorPlanState extends State<AddFloorPlan> {
  String _numFloor;

  FloorPlanController service = new FloorPlanController();

  Widget _buildFloors(){
    return TextFormField(
      textInputAction: TextInputAction.next, //The "return" button becomes a "next" button when typing
      decoration: InputDecoration(
          labelText: 'Enter number of floors'
      ),
      keyboardType: TextInputType.number,
      validator: (String value) {

        int num = int.tryParse(value);
        if(num == null || num <= 0){
          return 'Number of floors must be greater than zero';
        }
        return null;
      },
      onSaved: (String value){
        _numFloor = value;
      },
    );
  }

//global key _formkey.
  final GlobalKey<FormState> _formKey  = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
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
          title: Text("Add floor plan"),
          leading: BackButton( //Specify back button
            onPressed: (){
              Navigator.of(context).pushReplacementNamed(FloorPlan.routeName);
            },
          ),
        ),
        body: Center(
          child: SingleChildScrollView( //So the element doesn't overflow when you open the keyboard
            child: Container(
              width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
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
                          child: _buildFloors()
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height/48,
                        width: MediaQuery.of(context).size.width,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom (
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text('Proceed'),
                          onPressed: () {
                            if(!_formKey.currentState.validate()) {
                              return;
                            }
                            _formKey.currentState.save();

                            CreateFloorPlanResponse response = service.createFloorPlanMock(CreateFloorPlanRequest(globals.email, _numFloor, 0));
                            floorGlobals.globalNumFloors = int.parse(_numFloor);

                            if (response.getResponse()) {
                              showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text('Creation successful'),
                                    content: Text('Proceeding to next step.'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('Okay'),
                                        onPressed: (){
                                          Navigator.of(ctx).pop();
                                          Navigator.of(context).pushReplacementNamed(AdminViewFloors.routeName);
                                        },
                                      )
                                    ],
                                  )
                              );
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text('Creation unsuccessful'),
                                    content: Text('Floor plans must have at least one floor.'),
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
                          }
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height/48,
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