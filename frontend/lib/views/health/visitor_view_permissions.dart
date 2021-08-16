import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/admin_homepage.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/health/visitor_home_health.dart';

import 'package:frontend/globals.dart' as globals;

class VisitorViewPermissions extends StatefulWidget {
  static const routeName = "/visitor_view_permissions";

  @override
  _VisitorViewPermissionsState createState() => _VisitorViewPermissionsState();
}

class _VisitorViewPermissionsState extends State<VisitorViewPermissions> {
  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(VisitorHealth.routeName);
    return (await true);
  }

  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
    if (globals.loggedInUserType == 'ADMIN') {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
      });
      return Container();
    } else if (globals.loggedInUserType == 'USER') {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.of(context).pushReplacementNamed(UserHomePage.routeName);
      });
      return Container();
    }

     Widget getList(){
      int numOfPermissions = 0;
      if (globals.currentPermissions != null) {
        numOfPermissions = globals.currentPermissions.length;
      }

       if(numOfPermissions == 0) {
         return Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Container(
                 alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                  height: MediaQuery.of(context).size.height/(24*globals.getWidgetScaling()),
                 color: Theme.of(context).primaryColor,
                 child: Text('No permissions granted', style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)),
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
             padding: const EdgeInsets.all(16),
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
                         child: Text('Permission ' + globals.currentPermissions[index].getPermissionId()),
                       ),
                       ListView(
                           shrinkWrap: true,
                           physics: NeverScrollableScrollPhysics(), //The lists within the list should not be scrollable
                           children: <Widget>[
                             Container(
                               height: 50,
                               color: Colors.white,
                               child: Text('Type: ' + globals.currentPermissions[index].getOfficeAccess()),
                               padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                             ),
                             Container(
                               height: 50,
                               color: Colors.white,
                               child: Text('Granted by: ' + globals.currentPermissions[index].getGrantedBy()),
                               padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                             ),
                             Container(
                               height: 50,
                               color: Colors.white,
                               child: Text('Date: ' + globals.currentPermissions[index].getTimestamp()),
                               padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
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