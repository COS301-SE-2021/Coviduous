import 'package:flutter/material.dart';

import 'admin_homepage.dart';
import 'calc_floorplan.dart';
//import 'screens/selectfloors.dart';

class AddFloorPlan extends StatefulWidget {
  static const routeName = "/addfloorplan";

  @override
  _AddFloorPlanState createState() => _AddFloorPlanState();
}

class _AddFloorPlanState extends State<AddFloorPlan> {
  String _numFloor;
  String _numRooms;

  Widget _buildAge(){
    return TextFormField(
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
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildAge(),
                _buildRooms(),

                SizedBox(height: 50),

                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(100.0,40.0),
                    ),
                    child: Text('Proceed'),
                    onPressed: () {
                      if(!_formKey.currentState.validate()) {
                        return;
                      }
                      _formKey.currentState.save();
                      Navigator.of(context).pushReplacementNamed(CalcFloorPlan.routeName);
                    }
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}