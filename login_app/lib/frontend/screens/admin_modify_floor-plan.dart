import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ModifyFloorPlan extends StatefulWidget {
  static const routeName = "/modify_plan";
  @override
  _ModifyFloorPlanState createState() => _ModifyFloorPlanState();
}

class _ModifyFloorPlanState extends State<ModifyFloorPlan> {
    //String _chosenValue;

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

              ),
            ],
          ),
        )
      );

  }
}