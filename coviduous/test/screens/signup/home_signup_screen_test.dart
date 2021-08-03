import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:coviduous/frontend/screens/signup/home_signup_screen.dart';

void main() {
  setUpAll(() => HttpOverrides.global = null);

  testWidgets('Correct widgets appear', (WidgetTester tester) async {
    //Create widget for testing
    Widget createWidgetForTesting({Widget child}) {
      return MaterialApp(
          home: child
      );
    }

    //Build signup screen
    await tester.pumpWidget(createWidgetForTesting(child: new Register()));

    //Verify that the correct widgets appear in the correct order
    expect(find.text('Admin signup'), findsOneWidget); //Find one widget containing 'Admin signup'
    expect(find.text('User signup'), findsOneWidget); //Find one widget containing 'User signup'
  });
}