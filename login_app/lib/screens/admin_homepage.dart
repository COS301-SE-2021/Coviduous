import 'package:flutter/material.dart';
import 'package:mypages/screens/home_screen.dart';
import 'package:mypages/screens/add_floor_plan.dart';
import '../models/globals.dart' as globals;
class AdminHomePage extends StatefulWidget {
  static const routeName = "/admin";
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}
class _AdminHomePageState extends State<AdminHomePage> {
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async => false, //Prevent the back button from working
        child: Scaffold(
        appBar: AppBar(
        title: Text('Admin Profile '),
    automaticallyImplyLeading: false, //Back button will not show up in app bar
    ),