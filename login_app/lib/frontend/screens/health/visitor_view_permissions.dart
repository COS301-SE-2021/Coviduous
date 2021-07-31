import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:login_app/frontend/screens/admin_homepage.dart';
import 'package:login_app/frontend/screens/health/visitor_home_health.dart';
import 'package:login_app/frontend/screens/login_screen.dart';

import 'package:login_app/frontend/front_end_globals.dart' as globals;

class VisitorViewPermissions extends StatefulWidget {
  static const routeName = "/visitor_view_permissions";

  @override
  _VisitorViewPermissionsState createState() => _VisitorViewPermissionsState();
}

class _VisitorViewPermissionsState extends State<VisitorViewPermissions> {
  @override
  Widget build(BuildContext context) {
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
     Widget getList(){
       int numOfPermissions = 1;
       if(numOfPermissions == 0){
         return Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Container(
                 alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                  height: MediaQuery.of(context).size.height/(24*globals.getWidgetScaling()),
                 color: Theme.of(context).primaryColor,
                 child: Text('No permissions granted', style: TextStyle(color: Colors.white, fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)),
               ),
               Container(
                   alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                    height: MediaQuery.of(context).size.height/(12*globals.getWidgetScaling()),
                   color: Colors.white,
                   padding: EdgeInsets.all(12),
                   child: Text('No permissions have been granted to you.', style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5))
               )

             ]
         );
       } else {
         return ListView.builder(

             padding: const EdgeInsets.all(8),
             itemCount: numOfPermissions,
             itemBuilder: (context, index) { //Display a list tile FOR EACH permission in permissions[]
               return ListTile(
                 title: Column(
                     children:[
                       Container(
                         alignment: Alignment.center,
                         width: MediaQuery.of(context).size.width,
                         height: MediaQuery.of(context).size.height/24,
                         color: Theme.of(context).primaryColor,
                         child: Text('Permission ' + (index+1).toString(), style: TextStyle(color: Colors.white)),
                       ),
                       ListView(
                           shrinkWrap: true,
                           physics: NeverScrollableScrollPhysics(), //The lists within the list should not be scrollable
                           children: <Widget>[
                             Container(
                               height: 50,
                               color: Colors.white,
                               child: Text('Type: Office access', style: TextStyle(color: Colors.black)),
                             ),
                             Container(
                               height: 50,
                               color: Colors.white,
                               child: Text('Granted by: admin ID, name and surname here', style: TextStyle(color: Colors.black)),
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
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('Permissions'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(VisitorHealth.routeName);
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