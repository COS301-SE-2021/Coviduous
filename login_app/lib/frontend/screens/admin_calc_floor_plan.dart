import 'package:flutter/material.dart';

import 'admin_add_floor_plan.dart';
import 'package:login_app/services/globals.dart' as globals;

class CalcFloorPlan extends StatefulWidget {
  static const routeName = "/admin_calc_floorplan";

  @override
  _CalcFloorPlanState createState() => _CalcFloorPlanState();
}

class _CalcFloorPlanState extends State<CalcFloorPlan> {
  String _dimensions;
  String _numdesks;
  String _length;
  String _width;

  final dimensionFormat = RegExp(r'^\d\*\d$');

  Widget _buildDimensions() {
    return TextFormField(
      maxLength: 15,
      decoration: InputDecoration(
        labelText: 'Desk dimensions',
      ),
      validator: (String value) {
        //int dimension = int.tryParse(value);
        if (value == null) {
          return 'Dimensions are required';
        } else if (!dimensionFormat.hasMatch(value)) {
          return 'Value must be in the form x*y';
        }
        return null;
      },
      onSaved: (String value) {
        _dimensions = value;
      },
    );
  }

  Widget _buildDesks() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Number of desks'),
      keyboardType: TextInputType.number,
      validator: (String value) {
        int desk = int.tryParse(value);
        if (desk == null || desk <= 0) {
          return 'Number of desks is required';
        }
        return null;
      },
      onSaved: (String value) {
        _numdesks = value;
      },
    );
  }

  Widget _buildLength() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Length'),
      keyboardType: TextInputType.number,
      validator: (String value) {
        int length = int.tryParse(value);
        if (length == null || length <= 0) {
          return 'Width must be greater than zero';
        }
        return null;
      },
      onSaved: (String value) {
        _length = value;
      },
    );
  }

  Widget _buildWidth() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Width'),
      keyboardType: TextInputType.number,
      validator: (String value) {
        int _wid = int.tryParse(value);
        if (_wid == null || _wid <= 0) {
          return 'Length must be greater than zero';
        }
        return null;
      },
      onSaved: (String value) {
        _width = value;
      },
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculate floor plan"),
        leading: BackButton(
          //Specify back button
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(AddFloorPlan.routeName);
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width /
                (2 * globals.getWidgetScaling()),
            color: Colors.white,
            margin: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: _buildDimensions()),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: _buildDesks(),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: _buildLength(),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: _buildWidth(),
                    ),
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
                        child: Text('Save'),
                        onPressed: () {
                          if (!_formKey.currentState.validate()) {
                            return;
                          }

                          _formKey.currentState.save();

                          print('Dimensions: ' + _dimensions);
                          print('Number of desks: ' + _numdesks);
                          print('Length: ' + _length);
                          print('Width: ' + _width);
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
