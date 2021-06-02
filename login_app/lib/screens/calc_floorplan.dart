import 'package:flutter/material.dart';

class CalcFloorPlan extends StatefulWidget {
  static const routeName = "/calc";
  @override
  _CalcFloorPlanState createState() => _CalcFloorPlanState();
}
class _CalcFloorPlanState extends State<CalcFloorPlan> {
  String _dimensions;
  String _numdesks;
  String _length;
  String _width;