import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminEditShift extends StatefulWidget {
  static const routeName = "/Admin_edit_shifts";
  @override
  _AdminEditShiftState createState() => _AdminEditShiftState();
}

class _AdminEditShiftState extends State<AdminEditShift> {
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
          title: new Text("Edit Shift"),
          leading: BackButton(
          onPressed: (){

          },
        ),
       ),

     ),
    );
  }
}