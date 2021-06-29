import 'package:flutter/material.dart';

class EditFloorPlan extends StatefulWidget {
  @override
  EditFloorPlanState createState() {
    return EditFloorPlanState();
  }
}

class EditFloorPlanState extends State<EditFloorPlan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Floor-Plan'),
        backgroundColor: Colors.grey,
      ),
    );
  }
}
