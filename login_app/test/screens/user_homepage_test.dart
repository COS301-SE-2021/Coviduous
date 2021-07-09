import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:login_app/frontend/screens/user_homepage.dart';

void main() {
  setUpAll(() => HttpOverrides.global = null);

  testWidgets('Correct widgets appear', (WidgetTester tester) async {
    //Create widget for testing
    Widget createWidgetForTesting({Widget child}) {
      return MaterialApp(
          home: child
      );
    }

    //Build user homepage screen
    await tester.pumpWidget(createWidgetForTesting(child: new UserHomePage()));

    //Verify that the correct widgets appear in the correct order
    expect(find.text('Manage bookings'), findsOneWidget); //Find one widget containing 'Manage floor plans'
    expect(find.text('View announcements'), findsOneWidget); //Find one widget containing 'View announcements'
    expect(find.text('Manage account'), findsOneWidget); //Find one widget containing 'Manage account'
    expect(find.text('Log out'), findsOneWidget); //Find one widget containing 'Log out'
  });
}