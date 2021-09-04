import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frontend/views/admin_homepage.dart';
import 'package:frontend/views/announcement/admin_view_announcements.dart';
import 'package:frontend/views/user_homepage.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/controllers/announcement/announcement_helpers.dart' as announcementHelpers;
import 'package:frontend/globals.dart' as globals;

class MakeAnnouncement extends StatefulWidget {
  static const routeName = "/admin_make_announcement";
  MakeAnnouncement() : super();

  final String title = "Make announcement";

  @override
  MakeAnnouncementState createState() => MakeAnnouncementState();
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
    announcementHelpers.getAnnouncements().then((result) {
      if (result == true) {
        Navigator.of(context).pushReplacementNamed(AdminViewAnnouncements.routeName);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error occurred while retrieving announcements. Please try again later.')));
        Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
      }
    });
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

    return WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
          appBar: new AppBar(
            title: new Text("Create announcement"),
            leading: BackButton( //Specify back button
              onPressed: (){
                announcementHelpers.getAnnouncements().then((result) {
                  if (result == true) {
                    Navigator.of(context).pushReplacementNamed(AdminViewAnnouncements.routeName);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error occurred while retrieving announcements. Please try again later.')));
                    Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
                  }
                });
              },
            ),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                  padding: EdgeInsets.zero,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height/6,
                            child: Image(
                              image: (_selectedType == "Emergency")
                                  ? AssetImage('assets/images/warning-icon.png')
                                  : AssetImage('assets/images/placeholder-announcement.png')
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text("Select type"),
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
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.center,
                        color: (_selectedType == "Emergency")
                            ? globals.sixthColor
                            : globals.firstColor,
                        padding: EdgeInsets.all(16),
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          'Message',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                  hintText: "Write your announcement",
                              ),
                              obscureText: false,
                              maxLines: 3,
                              controller: _description,
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: (_selectedType == "Emergency")
                                    ? globals.sixthColor
                                    : globals.firstColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text("Post"),
                              onPressed: () {
                                announcementHelpers.createAnnouncement(_selectedType, _description.text).then((result) {
                                  if (result == true) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Announcement successfully created.")));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Announcement creation unsuccessful.")));
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
      ),
    );
  }
}