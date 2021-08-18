import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/views/admin_homepage.dart';
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

    //Build admin homepage screen
    await tester.pumpWidget(createWidgetForTesting(child: new AdminHomePage()));

    //Verify that the correct widgets appear in the correct order
    expect(find.text('Floor plans'), findsOneWidget); //Find one widget containing 'Floor plans'
    expect(find.text('Shifts'), findsOneWidget); //Find one widget containing 'Shifts'
    expect(find.text('Permissions'), findsOneWidget); //Find one widget containing 'Permissions'
    expect(find.text('Reports'), findsOneWidget); //Find one widget containing 'Reports'
  });
}