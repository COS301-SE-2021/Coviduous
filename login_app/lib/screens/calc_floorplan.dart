import 'package:flutter/material.dart';
import 'package:login_app/screens/add_floor_plan.dart';

class CalcFloorPlan extends StatefulWidget {
  static const routeName = "/calcfloorplan";

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
        labelText: 'Desk dimensions',
      ),
      validator: (String value) {
        int dimension = int.tryParse(value);
        if(dimension == null || dimension <= 0){
          return 'Dimensions are required in order to proceed';
        }
        return null;
      },
      onSaved: (String value){
        _dimensions = value;
      },
    );
  }

  Widget _buildDesks(){
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Number of desks'
      ),
      keyboardType: TextInputType.number,
      validator: (String value) {
        int desk = int.tryParse(value);
        if(desk == null || desk <= 0){
          return 'Number of desks is required';
        }
        return null;
      },
      onSaved: (String value){
        _numdesks = value;
      },
    );
  }

  Widget _buildLength(){
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Length'
      ),
      keyboardType: TextInputType.number,
      validator: (String value) {

        int length = int.tryParse(value);
        if(length == null || length <= 0){
          return 'Width must be greater than zero';
        }
        return null;
      },
      onSaved: (String value){
        _length = value;
      },
    );
  }

  Widget _buildWidth(){
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Width'
      ),
      keyboardType: TextInputType.number,
      validator: (String value) {

        int _wid = int.tryParse(value);
        if(_wid == null || _wid <= 0){
          return 'Length must be greater than zero';
        }
        return null;
      },
      onSaved: (String value){
        _width = value;
      },
    );
  }


  final GlobalKey<FormState> _formKey  = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculate floor plan"),
        leading: BackButton( //Specify back button
          onPressed: (){
            Navigator.of(context).pushReplacementNamed(AddFloorPlan.routeName);
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

                _buildDimensions(),
                _buildDesks(),
                _buildLength(),
                _buildWidth(),

                SizedBox(height: 50),

                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(100.0,40.0),
                    ),
                    child: Text('Save'),

                    onPressed: () {
                      if(!_formKey.currentState.validate()) {
                        return;
                      }

                      _formKey.currentState.save();

                      print(_dimensions);
                      print(_numdesks);
                      print(_length);
                      print(_width);
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



