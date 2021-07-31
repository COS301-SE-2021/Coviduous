import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

 import 'package:login_app/frontend/screens/admin_homepage.dart';
 import 'package:login_app/frontend/screens/login_screen.dart';
import 'package:login_app/frontend/front_end_globals.dart' as globals;

class AdminPermissions extends StatefulWidget {
  static const routeName = "/visitor_health";

  @override
  _AdminPermissionsState createState() => _AdminPermissionsState();
}
//class admin
class _AdminPermissionsState extends State<AdminPermissions> {
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
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Health'),
          leading: BackButton( //Specify back button
            onPressed: (){
              // Navigator.of(context).pushReplacementNamed(UserHomePage.routeName);
            },
          ),
        ),
        body: Center(
          child: Container(
            height: MediaQuery.of(context).size.height/(2*globals.getWidgetScaling()),
            width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ElevatedButton (
                    style: ElevatedButton.styleFrom (
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row (
                        children: <Widget>[
                          Expanded(child: Text('View permissions')),
                          Icon(Icons.zoom_in)
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                        crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                    ),
                    onPressed: () {
                      // Navigator.of(context).pushReplacementNamed(UserViewPermissions.routeName);
                    }
                ),
                SizedBox (
                  height: MediaQuery.of(context).size.height/48,
                  width: MediaQuery.of(context).size.width,
                ),
                ElevatedButton (
                    style: ElevatedButton.styleFrom (
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row (
                        children: <Widget>[
                          Expanded(child: Text('Grant Permissions')),
                          Icon(Icons.zoom_in)
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                        crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                    ),
                    onPressed: () {
                      //Navigator.of(context).pushReplacementNamed(UserViewGuidelines.routeName);
                    }
                ),
                SizedBox (
                  height: MediaQuery.of(context).size.height/48,
                  width: MediaQuery.of(context).size.width,
                ),
                ElevatedButton (
                    style: ElevatedButton.styleFrom (
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row (
                        children: <Widget>[
                          Expanded(child: Text('Manage PPE')),
                          Icon(Icons.help)
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                        crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                    ),
                    onPressed: () {
                      // Navigator.of(context).pushReplacementNamed(UserRequestAccess.routeName);
                    }
                ),
                SizedBox (
                  height: MediaQuery.of(context).size.height/48,
                  width: MediaQuery.of(context).size.width,
                ),
                ElevatedButton (
                    style: ElevatedButton.styleFrom (
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row (
                        children: <Widget>[
                          Expanded(child: Text('Contact Trace')),
                          Icon(Icons.file_upload)
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
                        crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
                    ),
                    onPressed: () {
                    }
                ),
                SizedBox (
                  height: MediaQuery.of(context).size.height/48,
                  width: MediaQuery.of(context).size.width,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}