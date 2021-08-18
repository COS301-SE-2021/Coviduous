import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/views/floor_plan/admin_add_floor_plan.dart';

import 'package:frontend/globals.dart' as globals;

void main() {
  setUpAll(() => HttpOverrides.global = null);

  testWidgets('Correct widgets appear', (WidgetTester tester) async {
    //Create widget for testing
    Widget createWidgetForTesting({Widget child}) {
      return MaterialApp(
          home: child
      );
    }

    globals.loggedInUserType = "ADMIN";

    //Build add floor plan screen
    await tester.pumpWidget(createWidgetForTesting(child: new AddFloorPlan()));

    //Verify that the correct widgets appear in the correct order
    expect(find.text('Enter number of floors'), findsOneWidget); //Find one widget containing 'Enter number of rooms'
    expect(find.text('Proceed'), findsOneWidget); //Find one widget containing 'Proceed'
  });
}