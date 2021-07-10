import 'package:flutter/material.dart';

import 'package:login_app/backend/controllers/user_controller.dart';
import 'package:login_app/frontend/screens/shift/admin_add_shift_rooms.dart';
import 'package:login_app/frontend/screens/shift/admin_add_shift_add_employee.dart';
import 'package:login_app/subsystems/user_subsystem/user.dart';
import 'package:login_app/frontend/screens/shift/home_shift.dart';

import 'package:login_app/frontend/front_end_globals.dart' as globals;
import 'package:login_app/backend/backend_globals/user_globals.dart' as userGlobals;

class AddShiftAssignEmployees extends StatefulWidget {
  static const routeName = "/admin_add_shift_employees";
  @override
  _AddShiftAssignEmployeesState createState() => _AddShiftAssignEmployeesState();
}

class _AddShiftAssignEmployeesState extends State<AddShiftAssignEmployees> {
  @override
  Widget build(BuildContext context) {
    UserController services = new UserController();
    Widget getList() {
      //List<User> users = services.getUsers();
      List<User> users = userGlobals.userDatabaseTable;
      users.removeWhere((user) => user.adminId == "" || user.adminId.isEmpty); //Only show employees, not admins
      int numOfUsers = users.length;

      print(numOfUsers);

      if (numOfUsers == 0) { //If the number of users = 0, don't display a list
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height /
                    (5 * globals.getWidgetScaling()),
              ),
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                height: MediaQuery.of(context).size.height/(24*globals.getWidgetScaling()),
                color: Theme.of(context).primaryColor,
                child: Text('Shift is empty', style: TextStyle(color: Colors.white, fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)),
              ),
              Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                  height: MediaQuery.of(context).size.height/(12*globals.getWidgetScaling()),
                  color: Colors.white,
                  padding: EdgeInsets.all(12),
                  child: Text('No employees have been assigned to this shift yet.', style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5))
              )
            ]
        );
      } else { //Else create and return a list
        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            itemCount: numOfUsers,
            itemBuilder: (context, index) { //Display a list tile FOR EACH user in users[]
              return ListTile(
                title: Column(
                    children:[
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 24,
                        color: Theme.of(context).primaryColor,
                        child: Text(
                            'Employee ID: ' + users[index].getUserId(),
                            style: TextStyle(color: Colors.white)),
                      ),
                      ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(), //The lists within the list should not be scrollable
                          children: <Widget>[
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text(
                                  'First name: ' + users[index].getFirstName(),
                                  style: TextStyle(color: Colors.black)),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text(
                                  'Last name: ' + users[index].getLastName(),
                                  style: TextStyle(color: Colors.black)),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      child: Text('Remove'),
                                      onPressed: () {
                                        setState(() {});
                                      }),
                                ],
                              ),
                            ),
                          ]
                      )
                    ]
                ),
                //title: floors[index].floor()
              );
            }
        );
      }
    }

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: new Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('Assign employees to shift'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(AddShiftRooms.routeName);
              },
            ),
          ),
          body: Stack(
              children: <Widget>[
                SingleChildScrollView(
                  child: Column(
                      children: [
                        getList(),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 18,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ]
                  ),
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                      height: 50,
                      width: 150,
                      padding: EdgeInsets.all(10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Add employee'),
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed(AddShiftAddEmployee.routeName);
                        },
                      )),
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  child: Container(
                      height: 50,
                      width: 130,
                      padding: EdgeInsets.all(10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Finish'),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text('Warning'),
                                content: Text('Are you sure you are done creating this shift?'),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Yes'),
                                    onPressed: (){
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text("Shift created")));
                                      Navigator.of(context).pushReplacementNamed(Shift.routeName);
                                    },
                                  ),
                                  TextButton(
                                    child: Text('No'),
                                    onPressed: (){
                                      Navigator.of(ctx).pop();
                                    },
                                  )
                                ],
                              ));
                        },
                      )),
                )
              ]
          )
      ),
    );
  }
}