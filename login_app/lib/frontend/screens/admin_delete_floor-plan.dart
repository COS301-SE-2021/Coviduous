import 'package:flutter/material.dart';
///import 'package:flutter/rendering.dart';

class DeleteFloorPlan extends StatefulWidget {
  @override
  DeleteFloorPlanState createState() {
    return DeleteFloorPlanState();
  }
}

class DeleteFloorPlanState extends State<DeleteFloorPlan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Floor-Plan'),
        backgroundColor: Colors.grey,
      ),
      backgroundColor: Colors.white70,
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Padding(
                padding: EdgeInsets.fromLTRB(350, 1, 350, 2),
                child: TextField(
                  //textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                    ),

                    labelText: 'Email:',
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(350, 1, 350, 2),
                child: TextFormField(
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                    ),
                    labelText: 'Password:',
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(350, 1, 350, 2),
                child: TextFormField(
                  decoration: InputDecoration(focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                    ),
                    labelText: 'Confirm Password:',
                  ),
                ),
              ),



            ],
        ),
      ),

    );
  }
}