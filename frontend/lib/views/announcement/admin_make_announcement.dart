import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/announcement/admin_view_announcements.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/controllers/announcement_controller.dart' as announcementController;
import 'package:frontend/globals.dart' as globals;

class MakeAnnouncement extends StatefulWidget {
  static const routeName = "/admin_make_announcement";
  MakeAnnouncement() : super();

  final String title = "Make announcement";

  @override
  MakeAnnouncementState createState() => MakeAnnouncementState();
}

bool createdAnnouncement = false;

Future createAnnouncement(String type, String description) async {
  await Future.wait([
    announcementController.createAnnouncement("test ID", type, description, "test timestamp")
  ]).then((results) {
    createdAnnouncement = results.first;
  });
}

Future getAnnouncements() async {
  await Future.wait([
    announcementController.getAnnouncements()
  ]).then((lists) {
    globals.currentAnnouncements = lists.first;
  });
}

//class make announcement
class MakeAnnouncementState extends State<MakeAnnouncement> {
  TextEditingController _description = TextEditingController();

  List<String> _announceType = ['General', 'Emergency'];
  List<DropdownMenuItem<String>> _dropdownMenuItems;
  String _selectedType;

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_announceType);
    _selectedType = _dropdownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<String>> buildDropdownMenuItems(List typeofAnnounce) {
    List<DropdownMenuItem<String>> items = [];
    for (String _type in typeofAnnounce) {
      items.add(
        DropdownMenuItem(
          value: _type,
          child: Text(_type),
        ),
      );
    }
    return items;
  }
  onChangeDropdownItem(String selected_type) {
    setState(() {
      _selectedType = selected_type;
    });
  }

  Future<bool> _onWillPop() async {
    getAnnouncements().then((result) {
      Navigator.of(context).pushReplacementNamed(AdminViewAnnouncements.routeName);
    });
    return (await true);
  }

  @override
  Widget build(BuildContext context) {
    //If incorrect type of user, don't allow them to view this page.
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

    return WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
          appBar: new AppBar(
            title: new Text("Make announcement"),
            leading: BackButton( //Specify back button
              onPressed: (){
                getAnnouncements().then((result) {
                  Navigator.of(context).pushReplacementNamed(AdminViewAnnouncements.routeName);
                });
              },
            ),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: new Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height/(3*globals.getWidgetScaling()),
                width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Select announcement type"),
                    SizedBox(
                      height: 20.0,
                    ),
                    Theme(
                      data: ThemeData.light(),
                      child: DropdownButton(
                        value: _selectedType,
                        items: _dropdownMenuItems,
                        onChanged: onChangeDropdownItem,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: "Write your announcement",
                          labelText: "Description",
                      ),
                      obscureText: false,
                      maxLines: 3,
                      controller: _description,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom (
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text("Post"),
                      onPressed: () {
                        createAnnouncement(_selectedType, _description.text).then((result){
                          if (createdAnnouncement == true) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Announcement successfully created.")));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Announcement creation unsuccessful.")));
                          }
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
      ),
    );
  }
}