import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:login_app/frontend/screens/user_homepage.dart';
import 'package:login_app/frontend/screens/login_screen.dart';

import 'package:login_app/frontend/front_end_globals.dart' as globals;


class EmployeeRequests extends StatefulWidget {
  static const routeName = "/admin_view_notifications";

  @override
  _EmployeeRequestsState createState() => _EmployeeRequestsState();
}
class _EmployeeRequestsState extends State<EmployeeRequests> {
  @override
  Widget build(BuildContext context) {

    if (globals.loggedInUserType != 'Admin') {
      if (globals.loggedInUserType == 'User') {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.of(context).pushReplacementNamed(UserHomePage.routeName);
        });
      } else {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
        });
      }
      return Container();
    }
    Widget getList() {
      int numberOfRequests = 1;

      if (numberOfRequests == 0) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                height: MediaQuery.of(context).size.height/(24*globals.getWidgetScaling()),
                color: Theme.of(context).primaryColor,
                child: Text('No requests currently available', style: TextStyle(color: Colors.white, fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)),
              ),
              Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                  height: MediaQuery.of(context).size.height/(12*globals.getWidgetScaling()),
                  color: Colors.white,
                  padding: EdgeInsets.all(12),
                  child: Text('No access requests currently made.', style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5))
              )
            ]
        );
      } else { //Else create and return a list
        return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: numberOfRequests,
            itemBuilder: (context, index) { //Display a list tile FOR EACH permission in permissions[]
              return ListTile(
                title: Column(
                    children:[
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height/24,
                        color: Theme.of(context).primaryColor,
                        child: Text('Request ID' + (index+1).toString(), style: TextStyle(color: Colors.white)),
                      ),
                      ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(), //The lists within the list should not be scrollable
                          children: <Widget>[
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text('Employee name: Name and surname displayed here', style: TextStyle(color: Colors.black)),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text('Reason: For client meeting', style: TextStyle(color: Colors.black)),
                            ),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Text('Date: 1 August 2021', style: TextStyle(color: Colors.black)),
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
            backgroundColor: Colors.transparent, //To show background image
            appBar: AppBar(
              title: Text('Employee Requests'),
              leading: BackButton( //Specify back button
                onPressed: (){
                  //Navigator.of(context).pushReplacementNamed(AdminNotifications.routeName);
                },
              ),
            ),
            body: Stack (
                children: <Widget>[
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        getList(),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 18,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ],
                    ),
                  ),
                  Container (
                    alignment: Alignment.center,
                    child: Container (
                        height: 50,
                        width: 170,
                        padding: EdgeInsets.all(10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom (
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text('Clear requests'),
                          onPressed: (){
                            //notifications.clear();
                            setState(() {});
                          },
                        )
                    ),
                  ),
                  Container (
                    alignment: Alignment.centerLeft,
                    child: Container (
                        height: 50,
                        width: 170,
                        padding: EdgeInsets.all(10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom (
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text('Grant Access'),
                          onPressed: (){
                            //notifications.clear();
                            setState(() {});
                          },
                        )
                    ),
                  ),
                  Container (
                    alignment: Alignment.centerRight,
                    child: Container (
                        height: 50,
                        width: 170,
                        padding: EdgeInsets.all(10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom (
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text('View Employee pdfs'),
                          onPressed: (){
                            //notifications.clear();
                            setState(() {});
                          },
                        )
                    ),
                  ),
                ]
            )
        ),
    );
  }
}