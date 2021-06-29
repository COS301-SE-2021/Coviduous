import 'package:flutter/material.dart';

class EditFloorPlan extends StatefulWidget {
  @override
  EditFloorPlanState createState() {
    return EditFloorPlanState();
  }
}

class EditFloorPlanState extends State<EditFloorPlan> {
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

                    labelText: 'Room Number',
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
                    labelText: 'Room area',
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
                    labelText: 'Desk area',
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
                    labelText: 'Number of desks',
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 50, right: 3),
                child: FlatButton(
                  color: Colors.blue,
                  child: Text('Proceed',
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
      ),
    );
  }
}
