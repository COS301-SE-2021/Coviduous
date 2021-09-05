import 'package:flutter/material.dart' hide Notification;
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/admin_homepage.dart';
import 'package:frontend/views/login_screen.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/models/notification/notification.dart';

import 'package:frontend/globals.dart' as globals;

class UserViewNotifications extends StatefulWidget {
  static const routeName = "/user_view_notifications";

  @override
  _UserViewNotificationsState createState() => _UserViewNotificationsState();
}

class _UserViewNotificationsState extends State<UserViewNotifications> {
  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(UserHomePage.routeName);
    return (await true);
  }

  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
    if (globals.loggedInUserType != 'USER') {
      if (globals.loggedInUserType == 'ADMIN') {
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

    Widget getList() {
      int numberOfNotifications = 0;
      if (globals.currentNotifications != null) {
        numberOfNotifications = globals.currentNotifications.length;
      }
      print(numberOfNotifications);

      if (numberOfNotifications == 0) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height /
                    (5 * globals.getWidgetScaling()),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / (2 * globals.getWidgetScaling()),
                      height: MediaQuery.of(context).size.height / (24 * globals.getWidgetScaling()),
                      color: Theme.of(context).primaryColor,
                      child: Text('No notifications found',
                          style: TextStyle(color: Colors.white,
                              fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)),
                    ),
                    Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                        height: MediaQuery.of(context).size.height/(12*globals.getWidgetScaling()),
                        color: Colors.white,
                        padding: EdgeInsets.all(12),
                        child: Text('You have no notifications.',
                            style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5))
                    ),
                  ],
                ),
              )
            ]
        );
      } else {
        List<Notification> reverseNotifications = globals.currentNotifications.reversed.toList(); //To display the newest notifications first

        //Else create and return a list
        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: numberOfNotifications,
            itemBuilder: (context, index) {
              return ListTile(
                title: Container(
                  color: globals.firstColor,
                  child: Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height/5.5,
                    margin: EdgeInsets.all(5),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children:[
                          Container(
                            height: MediaQuery.of(context).size.height/5.5,
                            child: Image(image: AssetImage('assets/images/placeholder-notification.png')),
                          ),
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:[
                                  Container(
                                    color: Colors.white,
                                    padding: EdgeInsets.all(8),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(reverseNotifications[index].getTimestamp()),
                                            Container(
                                              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                              child: SizedBox(
                                                height: MediaQuery.of(context).size.height/20,
                                                width: MediaQuery.of(context).size.height/20,
                                                child: ElevatedButton(
                                                  child: Text('X',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5,
                                                    ),
                                                  ),
                                                  style: ElevatedButton.styleFrom(
                                                    primary: globals.sixthColor,
                                                  ),
                                                  onPressed: () {
                                                    globals.currentNotifications.removeAt(numberOfNotifications-index-1);
                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                child: Text(
                                                  reverseNotifications[index].getMessage(),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width/48,
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(8),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  SizedBox(
                                                    child: ElevatedButton(
                                                      child: Text('View'),
                                                      style: ElevatedButton.styleFrom(
                                                        primary: globals.firstColor,
                                                      ),
                                                      onPressed: () {
                                                        showDialog(
                                                            context: context,
                                                            builder: (ctx) => AlertDialog(
                                                              title: Text('Notification details'),
                                                              content: Container(
                                                                color: Colors.white,
                                                                height: 350,
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: [
                                                                    Row(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Container(
                                                                          height: MediaQuery.of(context).size.height/5,
                                                                          child: Image(image: AssetImage('assets/images/placeholder-notification.png')),
                                                                        ),
                                                                        Expanded(
                                                                          child: Container(
                                                                            alignment: Alignment.center,
                                                                            color: globals.firstColor,
                                                                            height: MediaQuery.of(context).size.height/5,
                                                                            child: Text('  Notification ' + (index+1).toString() + '  ',
                                                                              style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Flexible(
                                                                      child: SingleChildScrollView(
                                                                        child: Column(
                                                                          children: [
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Container(
                                                                              alignment: Alignment.topLeft,
                                                                              height: 50,
                                                                              child: Text('From: ' + reverseNotifications[index].getAdminId(),
                                                                                  style: TextStyle(color: Colors.black)),
                                                                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                                                            ),
                                                                            Container(
                                                                              alignment: Alignment.topLeft,
                                                                              height: 50,
                                                                              child: Text('Date: ' + reverseNotifications[index].getTimestamp(),
                                                                                  style: TextStyle(color: Colors.black)),
                                                                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                                                            ),
                                                                            Container(
                                                                              alignment: Alignment.topLeft,
                                                                              height: 50,
                                                                              child: Text('Subject: ' + reverseNotifications[index].getSubject(),
                                                                                  style: TextStyle(color: Colors.black)),
                                                                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                                                            ),
                                                                            Container(
                                                                              alignment: Alignment.topLeft,
                                                                              child: Text('Message: ' + reverseNotifications[index].getMessage(),
                                                                                  style: TextStyle(color: Colors.black)),
                                                                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
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
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ]
                            ),
                          ),
                        ]
                    ),
                  ),
                ),
              );
            });
      }
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
          appBar: AppBar(
            title: Text('Your notifications'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(UserHomePage.routeName);
              },
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            child: Container (
                alignment: Alignment.bottomRight,
                height: 50,
                width: 170,
                padding: EdgeInsets.all(8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom (
                    primary: globals.sixthColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Clear notifications'),
                  onPressed: (){
                    globals.currentNotifications.clear();
                    setState(() {});
                  },
                )
            ),
          ),
          body: Stack (
              children: <Widget>[
                SingleChildScrollView(
                  child: Center(
                    child: getList(),
                  ),
                ),
              ]
          )
      ),
    );
  }
}
