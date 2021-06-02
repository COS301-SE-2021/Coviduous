import 'package:flutter/material.dart';

class CalcFloorPlan extends StatefulWidget {
  static const routeName = "/calc";
  @override
  _CalcFloorPlanState createState() => _CalcFloorPlanState();
}
class _CalcFloorPlanState extends State<CalcFloorPlan> {
  String _dimensions;
  String _numdesks;
  String _length;
  String _width;

  Widget _buildDimensions(){
    return TextFormField(
      maxLength: 15,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Desk Dimensions',
      ),
      validator: (String value) {
        int dimension = int.tryParse(value);
        if(dimension == null || dimension <= 0){
          return 'Dimensions are required in order to proceed';
        }
      },
      onSaved: (String value){
        _dimensions = value;
      },
    );
  }

