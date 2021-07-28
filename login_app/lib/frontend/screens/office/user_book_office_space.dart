import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../user_homepage.dart';
import 'package:login_app/subsystems/floorplan_subsystem/floor.dart';
//import 'package:login_app/backend/controllers/office_controller.dart';
import 'package:login_app/frontend/screens/admin_homepage.dart';
import 'package:login_app/frontend/screens/login_screen.dart';

import 'package:login_app/frontend/front_end_globals.dart' as globals;
import 'package:login_app/backend/backend_globals/floor_globals.dart' as floorGlobals;

class UserBookOfficeSpace extends StatefulWidget {
  static const routeName = "/user_book_space";
  @override
  _UserBookOfficeSpaceState createState() => _UserBookOfficeSpaceState();
}

class _UserBookOfficeSpaceState extends State<UserBookOfficeSpace> {
  String dropdownFloorValue = '1';
  String dropdownFloorInfo = ' ';
  List<Floor> listOfFloors = floorGlobals.globalFloors;
  List<String> floorNumbers = ['1', '2'];
  //int numberOfFloors = globals.globalNumFloors;
  int numberOfFloors = 2;

  //OfficeController services = new OfficeController();

  Widget getList() {
    /*
    for (int i = 0; i <= numberOfFloors; i++) {
        floorNumbers.add((i+1).toString());
    }
     */
    if (numberOfFloors == 0) {
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
                  crossAxisAlignment: CrossAxisAlignment.center, //Center row contents vertically
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
                          /*
                          dropdownFloorInfo = 'Number of rooms: ' + listOfFloors[int.parse(dropdownFloorValue)].numOfRooms.toString() +
                                              '\nMaximum capacity: ' + listOfFloors[int.parse(dropdownFloorValue)].maxCapacity.toString() +
                                              '\nCurrent capacity: ' + listOfFloors[int.parse(dropdownFloorValue)].currentCapacity.toString();
                           */
                        });
                      },
                      items: <String>['1', '2'].map<DropdownMenuItem<String>>((String value) {
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
                    showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text('Placeholder'),
                          content: Text('Booking successfully created.'),
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
                    /*
                    if (listOfFloors[int.parse(dropdownFloorValue)].currentCapacity < listOfFloors[int.parse(dropdownFloorValue)].maxCapacity) { //Check if floor has space

                    }
                    else {
                      showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('No space'),
                            content: Text('Floor has no more space available. Try a different floor or contact your administrator.'),
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
                  } */
              )
            ],
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
    if (globals.loggedInUserType != 'User') {
      if (globals.loggedInUserType == 'Admin') {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
        });
      } else {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
        });
      }
      return Container();
    }

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: new Scaffold(
        backgroundColor: Colors.transparent, //To show background image
        appBar: AppBar(
            title: Text('Book an office space'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(UserHomePage.routeName);
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
      ),
    );
  }
}