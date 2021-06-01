import 'package:flutter/material.dart';

import 'package:login_app/screens/user_homepage.dart';
import '../models/globals.dart' as globals;

class UserBookOfficeSpace extends StatefulWidget {
  static const routeName = "/bookspace";
  @override
  _UserBookOfficeSpaceState createState() => _UserBookOfficeSpaceState();
}

class _UserBookOfficeSpaceState extends State<UserBookOfficeSpace> {
  String dropdownFloorValue = '1';
  String dropdownFloorInfo = 'Information about the floor, including its rooms.';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
          title: Text('Book an office space'),
          backgroundColor: Colors.blue,
          leading: BackButton( //Specify back button
            onPressed: (){
              Navigator.of(context).pushReplacementNamed(UserHomepage.routeName);
            },
          ),
      ),
      body: Stack (
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Color(0xff0B0C20),
                        Color(0xff193A59),
                      ]
                  )
              )
          ),
          Center (
            child: Container (
              height: MediaQuery.of(context).size.height/(4*globals.getWidgetScaling()),
              width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
              color: Colors.white,
              padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row (
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center, //Center row contents vertically,
                      children: <Widget>[
                        Text('Select floor', style: TextStyle(color: Colors.black)),
                        DropdownButton<String>(
                          value: dropdownFloorValue,
                          icon: const Icon(Icons.arrow_downward, color: Colors.black),
                          iconSize: 24,
                          style: const TextStyle(color: Colors.black),
                          dropdownColor: Colors.white,
                          underline: Container(
                            height: 2,
                            color: Colors.white,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              dropdownFloorValue = newValue;
                            });
                          },
                          items: <String>['1', '2', '3', '4']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        )
                      ]
                    ),
                    Text(dropdownFloorInfo),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue, //Button color
                        minimumSize: Size(100.0,40.0),
                      ),
                      child: Text('Proceed'),
                      onPressed: () {
                        if (true) { //Check if floor has space
                          showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text('Placeholder'),
                                content: Text('Proceeding to next step.'),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Okay'),
                                    onPressed: (){
                                      Navigator.of(ctx).pop();
                                    },
                                  )
                                ],
                              )
                          );
                        }
                        else {
                          //Not allowed; try again
                        }
                      }
                    )
                  ],
                )
              )
            ),
        ]
      )
    );
  }
}