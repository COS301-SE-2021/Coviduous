import 'package:flutter/material.dart';

import 'admin_view_announcements.dart';
import '../services/globals.dart' as globals;

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

  List<DropdownMenuItem<Announcement>> buildDropdownMenuItems(List typeofAnnounc) {
    List<DropdownMenuItem<Announcement>> items = List();
    for (Announcement _type in typeofAnnounc) {
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
                  TextField(
                    decoration: InputDecoration(
                        labelText: "Topic",
                    ),
                    obscureText: false,
                    maxLength: 20,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        hintText: "Write your announcement",
                        labelText: "Description",
                    ),
                    obscureText: false,
                    maxLines: 3,
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
                      // handleSubmit(); (function for backend)
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