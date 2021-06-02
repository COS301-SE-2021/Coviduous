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
  List<String> listOfFloors = new List<String>.generate(
    globals.numberOfFloors,
    (int index) => (index+1).toString(),
  );

  Widget getList() {
    if (globals.numberOfFloors == 0) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
              height: MediaQuery.of(context).size.height/(24*globals.getWidgetScaling()),
              color: Theme.of(context).primaryColor,
              child: Text('No floor plans found', style: TextStyle(color: Colors.white, fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)),
            ),
            Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                height: MediaQuery.of(context).size.height/(12*globals.getWidgetScaling()),
                color: Colors.white,
                padding: EdgeInsets.all(12),
                child: Text('No floors have been registered for your company.', style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5))
            )
          ]
      );
    } else {
      return Container (
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
                      icon: const Icon(Icons.arrow_downward, color: Color(0xff056676)),
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
                      items: listOfFloors
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
                  style: ElevatedButton.styleFrom (
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
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
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
          title: Text('Book an office space'),
          leading: BackButton( //Specify back button
            onPressed: (){
              Navigator.of(context).pushReplacementNamed(UserHomepage.routeName);
            },
          ),
      ),
      body: Stack (
        children: <Widget>[
          Center (
            child: getList()
            ),
        ]
      )
    );
  }
}