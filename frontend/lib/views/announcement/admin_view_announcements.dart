import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/admin_homepage.dart';
import 'package:frontend/views/announcement/admin_make_announcement.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/controllers/announcement/announcement_helpers.dart' as announcementHelpers;
import 'package:frontend/views/global_widgets.dart' as globalWidgets;
import 'package:frontend/globals.dart' as globals;

class AdminViewAnnouncements extends StatefulWidget {
  static const routeName = "/admin_announcements";

  @override
  _AdminViewAnnouncementsState createState() => _AdminViewAnnouncementsState();
}

class _AdminViewAnnouncementsState extends State<AdminViewAnnouncements> {
  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
    return (await true);
  }

  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
    if (globals.loggedInUserType != 'ADMIN') {
      if (globals.loggedInUserType == 'USER') {
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
                height: MediaQuery.of(context).size.height / (5 * globals.getWidgetScaling()),
              ),
              globalWidgets.notFoundMessage(context, 'No announcements found', 'You have no announcements.'),
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
                    height: (!globals.getIfOnPC())
                        ? MediaQuery.of(context).size.height/5
                        : MediaQuery.of(context).size.height/7,
                    margin: EdgeInsets.all(5),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:[
                          Container(
                            height: (!globals.getIfOnPC())
                                ? MediaQuery.of(context).size.height/5
                                : MediaQuery.of(context).size.height/7,
                            child: Container(
                              width: 80,
                              child: (globals.currentAnnouncements[index].getType() == "EMERGENCY")
                                  ? Image(
                                  image: AssetImage('assets/images/warning-icon.png')
                              )
                                  : Image(
                                  image: AssetImage('assets/images/placeholder-announcement.png')
                              ),
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
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(globals.currentAnnouncements[index].getTimestamp()),
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
                                                      announcementHelpers.deleteAnnouncement(globals.currentAnnouncements[index].getAnnouncementId()).then((result) {
                                                        if (result == true) {
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                              SnackBar(content: Text("Announcement successfully deleted.")));
                                                          announcementHelpers.getAnnouncements().then((result) {
                                                            if (result == true) {
                                                              setState(() {});
                                                            } else {
                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                  SnackBar(content: Text('Error occurred while retrieving announcements. Please try again later.')));
                                                            }
                                                          });
                                                        } else {
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                              SnackBar(content: Text("Announcement deletion unsuccessful.")));
                                                        }
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
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
                                                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
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
                                                                            height: (!globals.getIfOnPC())
                                                                                ? MediaQuery.of(context).size.height/8
                                                                                : MediaQuery.of(context).size.height/8,
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
                                                                              height: (!globals.getIfOnPC())
                                                                                  ? MediaQuery.of(context).size.height/8
                                                                                  : MediaQuery.of(context).size.height/8,
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
                                                                              Divider(
                                                                                color: globals.lineColor,
                                                                                thickness: 2,
                                                                              ),
                                                                              Container(
                                                                                alignment: Alignment.topLeft,
                                                                                height: 50,
                                                                                child: Text('Type: ' + globals.currentAnnouncements[index].getType(),
                                                                                    style: TextStyle(color: Colors.black)),
                                                                                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                                                              ),
                                                                              Divider(
                                                                                color: globals.lineColor,
                                                                                thickness: 2,
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
                Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
              },
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            child: Container(
                alignment: Alignment.bottomCenter,
                height: MediaQuery.of(context).size.height/10,
                child: TextButton(
                  child: Text('+',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: (MediaQuery.of(context).size.height * 0.01) * 5,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(MakeAnnouncement.routeName);
                  },
                ))
          ),
          body: Stack (
              children: <Widget>[
                SingleChildScrollView(
                  child: Center (
                    child: (globals.getIfOnPC())
                        ? Container(
                          width: 640,
                          child: getList(),
                    )
                        : Container(
                          child: getList(),
                    ),
                  ),
                ),
              ]
          )
      ),
    );
  }
}
