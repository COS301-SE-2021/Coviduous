//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_app/backend/controllers/announcements_controller.dart';
import 'package:login_app/requests/announcements_requests/create_announcement_request.dart';
import 'package:login_app/responses/announcement_responses/create_announcement_response.dart';

import 'admin_view_announcements.dart';
import 'package:login_app/frontend/front_end_globals.dart' as globals;
import 'package:login_app/backend/backend_globals/user_globals.dart' as userGlobals;

class MakeAnnouncement extends StatefulWidget {
  static const routeName = "/admin_make_announcement";
  MakeAnnouncement() : super();

  final String title = "Make announcement";

  @override
  MakeAnnouncementState createState() => MakeAnnouncementState();
}

//class make announcement
class MakeAnnouncementState extends State<MakeAnnouncement> {
  TextEditingController _topic = TextEditingController();
  TextEditingController _description = TextEditingController();
  String _adminId = globals.loggedInUserId;
  String _companyId = userGlobals.getCompanyId(globals.loggedInUserId);

  AnnouncementsController services = new AnnouncementsController();
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: new Scaffold(
          backgroundColor: Colors.transparent,
          appBar: new AppBar(
            title: new Text("Make announcement"),
            leading: BackButton( //Specify back button
              onPressed: (){
                Navigator.of(context).pushReplacementNamed(AdminViewAnnouncements.routeName);
              },
            ),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: new Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height/(2*globals.getWidgetScaling()),
                width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Select announcement type"),
                    SizedBox(
                      height: 20.0,
                    ),
                    DropdownButton(
                      value: _selectedType,
                      items: _dropdownMenuItems,
                      onChanged: onChangeDropdownItem,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text('Selected: ${_selectedType}'),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: "Topic",
                      ),
                      obscureText: false,
                      maxLength: 20,
                      controller: _topic,
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
                        /*
                        //get admin ID and company ID
                        FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
                          var query = FirebaseFirestore.instance.collection('Users')
                              .where("Email", isEqualTo: FirebaseAuth.instance.currentUser.email).limit(1);
                          query.get().then((data) {
                            if (data.docs.length > 0) {
                              _adminId = data.docs[0].get('uid');
                              _companyId = data.docs[0].get('Company ID');
                            }
                          });
                        });
                         */

                        CreateAnnouncementResponse response = services.createAnnouncementMock(CreateAnnouncementRequest(_description.text, _selectedType, _adminId, _companyId));
                        print(response.getAnnouncementID() + " " + response.getResponse().toString());
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Announcement " + response.getAnnouncementID() + " successfully created.")));
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