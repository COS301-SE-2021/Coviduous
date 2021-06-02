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

  Widget _buildAge() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Enter number of floors'
      ),
      keyboardType: TextInputType.number,
      validator: (String value) {
        int num = int.tryParse(value);
        if (num == null || num <= 0) {
          return 'floor number must be greater than zero';
        }
      },
      onSaved: (String value) {
        _numFloor = value;
      },
    );
  }

  Widget _buildRooms() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Enter number of rooms'
      ),
      keyboardType: TextInputType.number,
      validator: (String value) {
        int rooms = int.tryParse(value);
        if (rooms == null || rooms <= 0) {
          return 'Age must be greater then 0';
        }
      },
      onSaved: (String value) {
        _numRooms = value;
      },
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Add Floor-plan")
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

                RaisedButton(
                    child: Text('Proceed',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16
                      ),
                    ),

                    onPressed: () {
                      if (!_formKey.currentState.validate()) {
                        return;
                      }

                      _formKey.currentState.save();
                      Navigator.of(context).pushReplacementNamed(
                          CalcFloorPlan.routeName);
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