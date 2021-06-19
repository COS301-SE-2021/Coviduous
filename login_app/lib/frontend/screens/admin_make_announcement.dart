import 'package:flutter/material.dart';
import 'package:login_app/backend/controllers/announcements_controller.dart';
import 'package:login_app/requests/announcements_requests/create_announcement_request.dart';
import 'package:login_app/responses/announcement_responses/create_announcement_response.dart';

import 'admin_view_announcements.dart';
import '../front_end_globals.dart' as globals;

class MakeAnnouncement extends StatefulWidget {
  static const routeName = "/admin_make_announcement";
  MakeAnnouncement() : super();

  final String title = "Make announcement";

  @override
  MakeAnnouncementState createState() => MakeAnnouncementState();
}

class Announcement {
  int id;
  String name;

  Announcement(this.id, this.name);

  static List<Announcement> getAnnouncementType() {
    return <Announcement>[
      Announcement(1, 'General'),
      Announcement(2, 'Emergency'),
    ];
  }
}
//class make announcement..
class MakeAnnouncementState extends State<MakeAnnouncement> {
  TextEditingController _topic = TextEditingController();
  TextEditingController _description = TextEditingController();

  AnnouncementsController services = new AnnouncementsController();
  //
  List<Announcement> _announceType = Announcement.getAnnouncementType();
  List<DropdownMenuItem<Announcement>> _dropdownMenuItems;
  Announcement _selectedType;

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_announceType);
    _selectedType = _dropdownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<Announcement>> buildDropdownMenuItems(List typeofAnnounce) {
    List<DropdownMenuItem<Announcement>> items = [];
    for (Announcement _type in typeofAnnounce) {
      items.add(
        DropdownMenuItem(
          value: _type,
          child: Text(_type.name),
        ),
      );
    }
    return items;
  }
  onChangeDropdownItem(Announcement selected_type) {
    setState(() {
      _selectedType = selected_type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
                  Text('Selected: ${_selectedType.name}'),
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
                      CreateAnnouncementResponse response = services.createAnnouncementMock(CreateAnnouncementRequest(_description.text, _selectedType.name, "test", "test"));
                      print(response.getAnnouncementID() + " " + response.getResponse().toString());
                    },
                  )
                ],
              ),
            ),
          ),
        ),
    );
  }
}