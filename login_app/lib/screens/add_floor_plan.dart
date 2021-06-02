import 'package:flutter/material.dart';
//import 'package:login_app/screens/selectfloors.dart';
//import 'package:login_app/screens/calc_floorplan.dart';

class AddFloorPlan extends StatefulWidget {
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
          return 'floor number must be greater than zero';
        }
      },
      onSaved: (String value){
        _numFloor = value;
      },
    );
  }