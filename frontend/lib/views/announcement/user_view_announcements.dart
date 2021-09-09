import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/admin_homepage.dart';
import 'package:frontend/views/login_screen.dart';
import 'package:frontend/views/user_homepage.dart';

import 'package:frontend/globals.dart' as globals;

class UserViewAnnouncements extends StatefulWidget {
  static const routeName = "/user_announcements";

  @override
  _UserViewAnnouncementsState createState() => _UserViewAnnouncementsState();
}

class _UserViewAnnouncementsState extends State<UserViewAnnouncements> {
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
      int numberOfAnnouncements = 0;
      if (globals.currentAnnouncements != null) {
        numberOfAnnouncements = globals.currentAnnouncements.length;
        print(numberOfAnnouncements);
      }
      print(numberOfAnnouncements);

      if (numberOfAnnouncements == 0) {
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
                      width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                      height: MediaQuery.of(context).size.height/(24*globals.getWidgetScaling()),
                      color: Theme.of(context).primaryColor,
                      child: Text('No announcements found', style: TextStyle(color: Colors.white,
                          fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5)),
                    ),
                    Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                        height: MediaQuery.of(context).size.height/(12*globals.getWidgetScaling()),
                        color: Colors.white,
                        padding: EdgeInsets.all(12),
                        child: Text('You have no announcements.', style: TextStyle(fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5))
                    ),
                  ],
                ),
              )
            ]
        );
      } else {
        //Else create and return a list
        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: numberOfAnnouncements,
            itemBuilder: (context, index) {
              return ListTile(
                title: Container(
                  color: (globals.currentAnnouncements[index].getType() == "EMERGENCY")
                      ? globals.sixthColor
                      : globals.firstColor,
                  child: Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height/5,
                    margin: EdgeInsets.all(5),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:[
                          Container(
                            height: MediaQuery.of(context).size.height/6,
                            child: (globals.currentAnnouncements[index].getType() == "EMERGENCY")
                                ? Image(
                                image: AssetImage('assets/images/warning-icon.png')
                            )
                                : Image(
                                image: AssetImage('assets/images/placeholder-announcement.png')
                            ),
                          ),
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children:[
                                  Expanded(
                                    child: Container(
                                      color: Colors.white,
                                      padding: EdgeInsets.all(12),
                                      child: Column(
                                        children: [
                                          Text(globals.currentAnnouncements[index].getTimestamp()),
                                          Divider(
                                            color: (globals.currentAnnouncements[index].getType() == "EMERGENCY")
                                                ? globals.sixthColor
                                                : globals.firstColor,
                                            thickness: 2,
                                          ),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  child: Text(
                                                    globals.currentAnnouncements[index].getMessage(),
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
                                                          primary: (globals.currentAnnouncements[index].getType() == "EMERGENCY")
                                                              ? globals.sixthColor
                                                              : globals.firstColor,
                                                        ),
                                                        onPressed: () {
                                                          showDialog(
                                                              context: context,
                                                              builder: (ctx) => AlertDialog(
                                                                title: Text('Announcement details'),
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
                                                                            child: (globals.currentAnnouncements[index].getType() == "EMERGENCY")
                                                                                ? Image(
                                                                                image: AssetImage('assets/images/warning-icon.png')
                                                                            )
                                                                                : Image(
                                                                                image: AssetImage('assets/images/placeholder-announcement.png')
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                            child: Container(
                                                                              alignment: Alignment.center,
                                                                              color: (globals.currentAnnouncements[index].getType() == "EMERGENCY")
                                                                                  ? globals.sixthColor
                                                                                  : globals.firstColor,
                                                                              height: MediaQuery.of(context).size.height/5,
                                                                              child: Text('  Announcement ' + (index+1).toString() + '  ',
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
                                                                                child: Text('Date: ' + globals.currentAnnouncements[index].getTimestamp(),
                                                                                    style: TextStyle(color: Colors.black)),
                                                                                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                                                              ),
                                                                              Container(
                                                                                alignment: Alignment.topLeft,
                                                                                height: 50,
                                                                                child: Text('Type: ' + globals.currentAnnouncements[index].getType(),
                                                                                    style: TextStyle(color: Colors.black)),
                                                                                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                                                              ),
                                                                              Container(
                                                                                alignment: Alignment.topLeft,
                                                                                child: Text('Message: ' + globals.currentAnnouncements[index].getMessage(),
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
            title: Text('Announcements'),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(UserHomePage.routeName);
              },
            ),
          ),
          body: Stack (
              children: <Widget>[
                SingleChildScrollView(
                  child: Center (
                      child: getList()
                  ),
                ),
              ]
          )
      ),
    );
  }
}