import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ModifyFloorPlan extends StatefulWidget {
  static const routeName = "/modify_plan";
  @override
  _ModifyFloorPlanState createState() => _ModifyFloorPlanState();
}

class _ModifyFloorPlanState extends State<ModifyFloorPlan> {
    String _chosenValue;

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Modify Floor-plan'),
          backgroundColor: Colors.grey,
        ),
          backgroundColor: Colors.grey[850],
          body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(0.0),
                      color: Colors.grey[300],
                      child: DropdownButton<String>(
                        value: _chosenValue,
                        //elevation: 5,
                        style: TextStyle(color: Colors.black),

                          items: <String>['Floor 1', 'Floor 2', 'Floor 3', 'Floor 4', 'Floor 5', 'Floor 6', 'Floor 7',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        hint: Text(
                          "Please choose a Floor to Modify",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        onChanged: (String value) {
                          setState(() {
                            _chosenValue = value;
                          });
                        },
                      ),
              ),

                    Row(

                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          Padding(
                            padding: EdgeInsets.only(top: 50, right: 3),
                            child: FlatButton(
                              color: Colors.white,
                              child: Text('Edit',
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: () {
                                setState(() {
                                  //darkMode = false;
                                });                    },
                            ),
                          ),

                          ],

                    ),
            ],
          ),
        )
      );

  }
}