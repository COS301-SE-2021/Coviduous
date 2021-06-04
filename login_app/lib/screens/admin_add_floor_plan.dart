import 'package:flutter/material.dart';

import 'admin_homepage.dart';
import 'admin_calc_floor_plan.dart';
//import 'screens/selectfloors.dart';
import '../services/globals.dart' as globals;
import '../services/services.dart';
import '../services/request/create_floor_plan_request.dart';
import '../services/response/create_floor_plan_response.dart';

class AddFloorPlan extends StatefulWidget {
  static const routeName = "/addfloorplan";

  @override
  _AddFloorPlanState createState() => _AddFloorPlanState();
}
//add floor plan
class _AddFloorPlanState extends State<AddFloorPlan> {
  String _numFloor;
  String _numRooms;
  //String _maxCapacity;
  //String _currCapacity;

  Services service = new Services();

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
//build for rooms
  Widget _buildRooms(){
    return TextFormField(
      textInputAction: TextInputAction.next, //The "return" button becomes a "next" button when typing
      decoration: InputDecoration(
          labelText: 'Enter number of rooms'
      ),
      keyboardType: TextInputType.number,
      validator: (String value) {

        int rooms = int.tryParse(value);
        if(rooms == null || rooms <= 0){
          return 'Number of rooms must be greater than zero';
        }
        return null;
      },
      onSaved: (String value){
        _numRooms = value;
      },
    );
  }

  Widget _buildMaxCapacity(){
    return TextFormField(
      textInputAction: TextInputAction.next, //The "return" button becomes a "next" button when typing
      decoration: InputDecoration(
          labelText: 'Set maximum capacity'
      ),
      keyboardType: TextInputType.number,
      validator: (String value) {

        int rooms = int.tryParse(value);
        if(rooms == null || rooms <= 0){
          return 'Maximum capacity must be greater than zero';
        }
        return null;
      },
      onSaved: (String value){
        //_maxCapacity = value;
      },
    );
  }


  Widget _buildCurrentCapacity(){
    return TextFormField(
      textInputAction: TextInputAction.done, //The "return" button becomes a "done" button when typing
      decoration: InputDecoration(
          labelText: 'Set current capacity'
      ),
      keyboardType: TextInputType.number,
      validator: (String value) {

        int rooms = int.tryParse(value);
        if(rooms == null || rooms <= 0){
          return 'Current capacity must be greater than zero';
        }
        return null;
      },
      onSaved: (String value){
        //_currCapacity = value;
      },
    );
  }

  final GlobalKey<FormState> _formKey  = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add floor plan"),
        leading: BackButton( //Specify back button
          onPressed: (){
            Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
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
                    Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: _buildRooms()
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: _buildMaxCapacity()
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: _buildCurrentCapacity()
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

                          CreateFloorPlanResponse response = service.createFloorPlan(CreateFloorPlanRequest(globals.email, _numFloor, int.parse(_numRooms)));

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
                                        Navigator.of(context).pushReplacementNamed(CalcFloorPlan.routeName);
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
                                  content: Text('Please check your details.'),
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
    );
  }
}