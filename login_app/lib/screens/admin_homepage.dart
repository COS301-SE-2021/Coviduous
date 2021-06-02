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
    body: Stack (
    children: <Widget>[
    SingleChildScrollView( //So the element doesn't overflow when you open the keyboard
    child: Center(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Container (
    alignment: Alignment.center,
    margin: EdgeInsets.all(20.0),
    child: Image(
    alignment: Alignment.center,
    image: AssetImage('assets/placeholder.com-logo1.png'),
    color: Colors.indigo,
    width: double.maxFinite,
    height: MediaQuery.of(context).size.height/8,
    ),
    ),
    SizedBox (
    height: MediaQuery.of(context).size.height/48,
    width: MediaQuery.of(context).size.width,
    ),
    Container (
    height: MediaQuery.of(context).size.height/(4*globals.getWidgetScaling()),
    width: MediaQuery.of(context).size.width/(2*globals.getWidgetScaling()),
    padding: EdgeInsets.all(16),
    child: Column (
    children: <Widget>[
    ElevatedButton (
    child: Row (
    children: <Widget>[
    Expanded(child: Text('Add a Floor-plan')),
    Icon(Icons.add_circle_rounded)
    ],
    mainAxisAlignment: MainAxisAlignment.spaceBetween, //Align text and icon on opposite sides
    crossAxisAlignment: CrossAxisAlignment.center //Center row contents vertically
    ),
    onPressed: () {
    Navigator.of(context).pushReplacementNamed(FloorPlan.routeName);
    }