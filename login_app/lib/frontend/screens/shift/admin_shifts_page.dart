import 'package:flutter/material.dart';

class AdminShiftsPage extends StatefulWidget {
  static const routeName = "/Admin_shifts_pages";

  @override
  _AdminShiftsPageState createState() => _AdminShiftsPageState();
}
class _AdminShiftsPageState extends State<AdminShiftsPage> {
  //String _userId = globals.loggedInUserId;

  @override
  Widget build(BuildContext context) {

    Widget getList() {
      int numberofshifts = 1;

      if (numberofshifts == 0) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

            ]
        );
      }
    }
  }
}