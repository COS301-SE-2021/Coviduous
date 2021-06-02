import 'package:flutter/material.dart';

import 'admin_homepage.dart';
import 'calc_floorplan.dart';
//import 'screens/selectfloors.dart';
import '../models/globals.dart' as globals;

class AddFloorPlan extends StatefulWidget {
  static const routeName = "/addfloorplan";

  @override
  _AddFloorPlanState createState() => _AddFloorPlanState();
}

class _AddFloorPlanState extends State<AddFloorPlan> {
  String _numFloor;
  String _numRooms;

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

  Widget _buildRooms(){
    return TextFormField(
      textInputAction: TextInputAction.done, //The "return" button becomes a "done" button when typing
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
                          Navigator.of(context).pushReplacementNamed(CalcFloorPlan.routeName);
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