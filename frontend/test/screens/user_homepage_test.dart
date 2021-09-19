import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/views/user_homepage.dart';
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

    globals.loggedInUserType = "USER";
    globals.showChatBot = false;

    //Build user homepage screen
    await tester.pumpWidget(createWidgetForTesting(child: new UserHomePage()));

    //Verify that the correct widgets appear in the correct order
    expect(find.text('Bookings'), findsOneWidget); //Find one widget containing 'Bookings'
    expect(find.text('Health'), findsOneWidget); //Find one widget containing 'Health'
  });
}